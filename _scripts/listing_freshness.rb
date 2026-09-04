# frozen_string_literal: true

require 'cgi'
require 'date'
require 'digest'
require 'fileutils'
require 'tempfile'
require 'time'
require 'uri'
require_relative 'show_date_parser'
require_relative 'show-data-trust-audit'

module ListingFreshness
  COMPARISON_MANIFEST_SCHEMA_VERSION = 1
  COMPARISON_MAX_AGE_SECONDS = 24 * 60 * 60
  COMPARISON_CLOCK_SKEW_SECONDS = 5 * 60
  COMPARISON_MAX_DURATION_SECONDS = 60 * 60
  CANDIDATE_MATCH_BASES = %w[literal_name_proximity exact_single_event_page controlled_fixture].freeze
  COMPARISON_ROW_HEADERS = %w[
    comparison_run_id source_key source_type source_url request_url fetched_at show_id show_name current_next_date
    fetch_status fetch_detail redirect_target review_status name_found current_date_found match_basis
    candidate_dates candidate_match_basis cancellation_evidence
  ].freeze
  RISK_RANK = {
    'urgent' => 0,
    'high' => 1,
    'medium' => 2,
    'routine' => 3
  }.freeze

  module_function

  def parse_iso_date(value)
    Date.iso8601(value.to_s)
  rescue ArgumentError, TypeError
    nil
  end

  def normalized(value)
    value.to_s.downcase.gsub(/[^a-z0-9]+/, ' ').strip
  end

  def truthy?(value)
    value == true || value.to_s.casecmp('true').zero?
  end

  def safe_csv_cell(value, separator: ';')
    text = value.is_a?(Array) ? value.join(separator) : value.to_s
    return "'#{text}" if text.match?(/\A(?:[=+\-@]|\t|\r)/)

    text
  end

  def safe_markdown_cell(value)
    text = value.is_a?(Array) ? value.join('; ') : value.to_s
    CGI.escapeHTML(text.gsub(/[\r\n]+/, ' ').gsub(/\s+/, ' ').strip)
       .gsub('\\') { '\\\\' }
       .gsub('|') { '\\|' }
       .gsub('`') { '\\`' }
  end

  def configure_http_client(http, timeout:)
    writers = %i[open_timeout= read_timeout= write_timeout= max_retries=]
    unless writers.all? { |writer| http.respond_to?(writer) }
      raise ArgumentError, 'HTTP client does not support required timeout and retry controls'
    end

    http.open_timeout = timeout
    http.read_timeout = timeout
    http.write_timeout = timeout
    http.max_retries = 0
    http
  end

  def secure_output_path(path, repo_root:)
    root = File.expand_path(repo_root)
    output_root = File.join(root, 'tmp')
    raise ArgumentError, 'Secure output root must not be a symbolic link' if File.symlink?(output_root)

    FileUtils.mkdir_p(output_root, mode: 0o700)
    raise ArgumentError, 'Secure output root is not a directory' unless File.directory?(output_root)

    candidate = File.expand_path(path.to_s, root)
    basename = File.basename(candidate)
    unless File.dirname(candidate) == output_root && basename.match?(/\A[a-zA-Z0-9][a-zA-Z0-9._-]*\z/)
      raise ArgumentError, 'Listing freshness outputs must be direct files inside the repository tmp directory'
    end
    raise ArgumentError, "Secure output must not be a symbolic link: #{basename}" if File.symlink?(candidate)
    if File.exist?(candidate) && !File.file?(candidate)
      raise ArgumentError, "Secure output must be a regular file: #{basename}"
    end

    candidate
  end

  def secure_output_paths(paths, repo_root:, forbidden_paths: [])
    secure_paths = paths.map { |path| secure_output_path(path, repo_root: repo_root) }
    raise ArgumentError, 'Listing freshness output paths must be unique' unless secure_paths.uniq.length == secure_paths.length

    forbidden = forbidden_paths.map { |path| File.expand_path(path.to_s, repo_root) }
    if (secure_paths & forbidden).any?
      raise ArgumentError, 'Listing freshness output paths must not replace an input file'
    end

    secure_paths
  end

  def write_secure_output(path, repo_root:)
    safe_path = secure_output_path(path, repo_root: repo_root)
    directory = File.dirname(safe_path)
    Tempfile.create([".#{File.basename(safe_path)}-", '.tmp'], directory) do |file|
      yield file
      file.flush
      file.fsync
      file.close
      File.rename(file.path, safe_path)
      File.chmod(0o600, safe_path)
    end
    safe_path
  end

  def repo_relative_path(path, repo_root:)
    root = File.expand_path(repo_root)
    candidate = File.expand_path(path.to_s, root)
    prefix = "#{root}#{File::SEPARATOR}"
    unless candidate.start_with?(prefix) && candidate.length > prefix.length
      raise ArgumentError, 'Listing freshness input must remain inside the repository'
    end

    candidate.delete_prefix(prefix)
  end

  def file_sha256(path)
    Digest::SHA256.file(path).hexdigest
  end

  def validate_comparison_manifest!(manifest:, comparison_path:, profile_path:, external_sources_path:, shows_path:,
                                    repo_root:, expected_as_of:, rows:, now: Time.now.utc)
    expected_keys = %w[
      schema_version run_id started_at completed_at as_of profile_path input_sha256 comparison_sha256
      comparison_row_count source_path_count request_count dry_run
    ]
    unless manifest.is_a?(Hash) && manifest.keys.sort == expected_keys.sort
      raise ArgumentError, 'Comparison manifest fields are incomplete or unexpected'
    end
    unless manifest.fetch('schema_version') == COMPARISON_MANIFEST_SCHEMA_VERSION
      raise ArgumentError, 'Comparison manifest schema version is unsupported'
    end

    run_id = manifest.fetch('run_id').to_s
    unless run_id.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i)
      raise ArgumentError, 'Comparison manifest run ID is invalid'
    end

    started_at = parse_manifest_time(manifest.fetch('started_at'), 'start')
    completed_at = parse_manifest_time(manifest.fetch('completed_at'), 'completion')
    duration = completed_at - started_at
    unless duration.between?(0, COMPARISON_MAX_DURATION_SECONDS)
      raise ArgumentError, 'Comparison manifest duration is invalid'
    end
    if completed_at > now + COMPARISON_CLOCK_SKEW_SECONDS
      raise ArgumentError, 'Comparison manifest completion time is in the future'
    end
    if now - completed_at > COMPARISON_MAX_AGE_SECONDS
      raise ArgumentError, 'Comparison manifest is stale'
    end
    unless manifest.fetch('as_of') == expected_as_of.iso8601
      raise ArgumentError, 'Comparison manifest classification date does not match the report'
    end

    expected_profile_path = repo_relative_path(profile_path, repo_root: repo_root)
    unless manifest.fetch('profile_path') == expected_profile_path
      raise ArgumentError, 'Comparison manifest profile path does not match the report'
    end

    input_digests = manifest.fetch('input_sha256')
    unless input_digests.is_a?(Hash) && input_digests.keys.sort == %w[external_sources profile shows]
      raise ArgumentError, 'Comparison manifest input digests are incomplete or unexpected'
    end
    expected_digests = {
      'external_sources' => file_sha256(external_sources_path),
      'profile' => file_sha256(profile_path),
      'shows' => file_sha256(shows_path)
    }
    unless input_digests == expected_digests
      raise ArgumentError, 'Comparison manifest input digests do not match current inputs'
    end
    unless manifest.fetch('comparison_sha256') == file_sha256(comparison_path)
      raise ArgumentError, 'Comparison CSV does not match its manifest digest'
    end
    unless manifest.fetch('comparison_row_count') == rows.length
      raise ArgumentError, 'Comparison manifest row count does not match the CSV'
    end

    row_run_ids = rows.map { |row| row.fetch('comparison_run_id') }.uniq
    unless row_run_ids == [run_id]
      raise ArgumentError, 'Comparison CSV contains rows from another run'
    end
    rows.each do |row|
      fetched_at = parse_manifest_time(row.fetch('fetched_at'), 'row fetch')
      unless fetched_at.between?(started_at, completed_at)
        raise ArgumentError, 'Comparison CSV contains a fetch time outside its run window'
      end
    end

    source_path_count = rows.map { |row| [row.fetch('source_key'), row.fetch('request_url')] }.uniq.length
    unless manifest.fetch('source_path_count') == source_path_count
      raise ArgumentError, 'Comparison manifest source-path count does not match the CSV'
    end
    dry_run = manifest.fetch('dry_run')
    unless dry_run == true || dry_run == false
      raise ArgumentError, 'Comparison manifest dry-run flag is invalid'
    end
    expected_request_count = dry_run ? 0 : source_path_count
    unless manifest.fetch('request_count') == expected_request_count
      raise ArgumentError, 'Comparison manifest request count is inconsistent'
    end
    dry_run_rows = rows.select { |row| row.fetch('fetch_status') == 'dry_run' }
    if (dry_run && dry_run_rows.length != rows.length) || (!dry_run && !dry_run_rows.empty?)
      raise ArgumentError, 'Comparison manifest dry-run state does not match the CSV'
    end

    {
      run_id: run_id,
      started_at: started_at,
      completed_at: completed_at,
      live: !dry_run,
      classification_current: expected_as_of == completed_at.utc.to_date
    }
  end

  def parse_manifest_time(value, label)
    parsed = Time.iso8601(value.to_s)
    raise ArgumentError, "Comparison manifest #{label} time must use UTC" unless parsed.utc_offset.zero?

    parsed
  rescue ArgumentError
    raise ArgumentError, "Comparison manifest #{label} time is invalid"
  end

  def validate_unique_comparison_rows!(rows)
    duplicate = rows.group_by { |row| [row.fetch('source_key'), row.fetch('show_id')] }
                    .find { |_key, grouped_rows| grouped_rows.length > 1 }
    return true unless duplicate

    raise ArgumentError, "Comparison input contains a duplicate source/show row: #{duplicate.first.join('/')}"
  end

  def validate_comparison_snapshot!(row:, show:)
    show_id = row.fetch('show_id')
    raise ArgumentError, "Comparison input references a missing canonical listing: #{show_id}" unless show

    unless row.fetch('show_name') == show.fetch('name')
      raise ArgumentError, "Comparison input has a stale or altered show name: #{show_id}"
    end
    unless row.fetch('current_next_date') == show.fetch('next_date', '').to_s
      raise ArgumentError, "Comparison input has a stale or altered current date: #{show_id}"
    end

    true
  end

  def source_tier(source_type, source_url)
    normalized_type = source_type.to_s.downcase.tr('_', '-')
    return 'none' if source_url.to_s.empty?
    return 'controlled_fixture' if normalized_type == 'controlled-fixture'
    return 'lead_only' if normalized_type.include?('third-party')
    return 'tier_1_direct' if normalized_type == 'direct-promoter-submission'
    return 'tier_1_primary' if normalized_type.match?(/organizer|promoter|official-show/)
    return 'tier_2_official_organization' if normalized_type.match?(/club|association/)
    return 'tier_2_official_venue' if normalized_type.include?('venue')

    'tier_3_approved_unclassified'
  end

  def event_context(show, as_of:)
    upcoming_dates = Array(show['upcoming_dates']).map { |value| parse_iso_date(value) }.compact.sort
    current_or_future = upcoming_dates.select { |date| date >= as_of }

    unless current_or_future.empty?
      event_date = current_or_future.first
      return {
        date_status: 'scheduled',
        event_date: event_date,
        days_until_event: (event_date - as_of).to_i
      }
    end

    date_text = show.fetch('next_date', '').to_s.strip
    return { date_status: 'tbd', event_date: nil, days_until_event: nil } if date_text.empty? || date_text == 'TBD'
    return { date_status: 'partial', event_date: nil, days_until_event: nil } if ShowDateParser.partial_date?(date_text)

    date_range = ShowDateParser.date_range(date_text)
    return { date_status: 'invalid', event_date: nil, days_until_event: nil } unless date_range

    start_date, finish_date = date_range
    if finish_date < as_of
      {
        date_status: 'past',
        event_date: finish_date,
        days_until_event: (finish_date - as_of).to_i
      }
    else
      event_date = [start_date, as_of].max
      {
        date_status: 'scheduled',
        event_date: event_date,
        days_until_event: (event_date - as_of).to_i
      }
    end
  end

  def baseline_policy(event)
    days_until = event.fetch(:days_until_event)

    if event.fetch(:date_status) == 'scheduled'
      return ['every_2_to_3_days', 2] if days_until <= 2
      return ['every_2_to_3_days', 3] if days_until <= 30
      return ['weekly', 7] if days_until <= 90

      return ['monthly', 30]
    end

    return ['weekly_stale_queue', 7] if event.fetch(:date_status) == 'past'

    ['monthly_unconfirmed_queue', 30]
  end

  def due_on(as_of:, last_verified:, event:, interval_days:, conflict_reasons:)
    return as_of if last_verified.nil? || !conflict_reasons.empty?

    candidates = [last_verified + interval_days]
    if event.fetch(:date_status) == 'scheduled'
      event_date = event.fetch(:event_date)
      [21, 7, 2].each do |days_before|
        milestone = event_date - days_before
        candidates << milestone if milestone > last_verified
      end
    end

    candidates.min
  end

  def risk_level(event:, source_url:, conflict_reasons:)
    days_until = event.fetch(:days_until_event)
    date_status = event.fetch(:date_status)

    return 'urgent' if !conflict_reasons.empty? && days_until&.between?(0, 30)
    return 'urgent' if date_status == 'scheduled' && days_until <= 2
    return 'high' unless conflict_reasons.empty?
    return 'high' if %w[past invalid].include?(date_status)
    return 'high' if date_status == 'scheduled' && days_until <= 30
    return 'high' if source_url.to_s.empty? && days_until&.between?(0, 90)
    return 'medium' if date_status == 'scheduled' && days_until <= 90
    return 'medium' if %w[tbd partial].include?(date_status) || source_url.to_s.empty?

    'routine'
  end

  def reason_codes(event:, last_verified:, due_date:, as_of:, source_url:, conflict_reasons:)
    reasons = []
    date_status = event.fetch(:date_status)
    days_until = event.fetch(:days_until_event)

    if date_status == 'scheduled'
      reasons << if days_until <= 2
                   'event_within_2_days'
                 elsif days_until <= 7
                   'event_within_7_days'
                 elsif days_until <= 21
                   'event_within_21_days'
                 elsif days_until <= 30
                   'event_within_30_days'
                 elsif days_until <= 90
                   'event_31_to_90_days'
                 else
                   'event_over_90_days'
                 end
    else
      reasons << "date_#{date_status}"
    end

    reasons << 'verification_missing' if last_verified.nil?
    reasons << 'verification_due_by_policy' if due_date <= as_of
    reasons << 'approved_source_missing' if source_url.to_s.empty?
    reasons.concat(conflict_reasons)
    reasons.uniq
  end

  def classify(show:, as_of:, source_url:, source_type:, conflict_reasons: [])
    event = event_context(show, as_of: as_of)
    last_verified = parse_iso_date(show['last_verified'])
    last_verified = nil if last_verified && last_verified > as_of
    baseline_cadence, interval_days = baseline_policy(event)
    due_date = due_on(
      as_of: as_of,
      last_verified: last_verified,
      event: event,
      interval_days: interval_days,
      conflict_reasons: conflict_reasons
    )
    due_status = if due_date <= as_of
                   'due_now'
                 elsif due_date <= as_of + 7
                   'due_within_7_days'
                 else
                   'scheduled_later'
                 end

    {
      show_id: show.fetch('id'),
      show_name: show.fetch('name'),
      city: show.fetch('city'),
      state: show.fetch('state'),
      current_next_date: show.fetch('next_date', '').to_s,
      date_status: event.fetch(:date_status),
      event_date: event.fetch(:event_date)&.iso8601.to_s,
      days_until_event: event.fetch(:days_until_event),
      last_verified: last_verified&.iso8601.to_s,
      verification_age_days: last_verified ? (as_of - last_verified).to_i : nil,
      source_url: source_url.to_s,
      source_type: source_type.to_s.empty? ? 'unclassified' : source_type.to_s,
      source_tier: source_tier(source_type, source_url),
      source_conflict: !conflict_reasons.empty?,
      risk_level: risk_level(event: event, source_url: source_url, conflict_reasons: conflict_reasons),
      baseline_cadence: baseline_cadence,
      review_cadence: conflict_reasons.empty? ? baseline_cadence : 'immediate_conflict_review',
      review_due_on: due_date.iso8601,
      due_status: due_status,
      reason_codes: reason_codes(
        event: event,
        last_verified: last_verified,
        due_date: due_date,
        as_of: as_of,
        source_url: source_url,
        conflict_reasons: conflict_reasons
      ),
      human_action: 'review_evidence_before_any_listing_change',
      automatic_action: 'none'
    }
  end

  def successful_fetch?(status)
    status.to_s.match?(/\A2\d\d\z/)
  end

  def external_outcome(row)
    return 'source_unavailable' unless successful_fetch?(row['fetch_status'])
    if truthy?(row['cancellation_evidence']) &&
       truthy?(row['name_found']) &&
       !row['cancellation_evidence_detail'].to_s.strip.empty?
      return 'cancellation_evidence'
    end
    return 'current_match' if truthy?(row['name_found']) && truthy?(row['current_date_found'])
    candidate_values = row['candidate_dates'].to_s.split(';').map(&:strip).reject(&:empty?)
    current_value = row['current_next_date'].to_s
    different_candidate = candidate_values.any? { |candidate| normalized(candidate) != normalized(current_value) }
    if truthy?(row['name_found']) && CANDIDATE_MATCH_BASES.include?(row['candidate_match_basis'].to_s) && different_candidate
      return 'candidate_change'
    end

    'review_conflict'
  end

  def build_source_fact(row:, show:, source_type:, source_url:, fetched_at:, pilot:, expectation: nil, controlled: false,
                        request_url: nil)
    outcome = external_outcome(row)
    candidates = row['candidate_dates'].to_s
    candidate_values = candidates.split(';').map(&:strip).reject(&:empty?)
    current_value = row['current_next_date'].to_s
    evidence_url = request_url.to_s.empty? ? source_url : request_url
    transport_secure = secure_transport?(evidence_url)

    field, proposed_value, status, confidence, conflict_reason, human_action = case outcome
                                                                            when 'current_match'
                                                                              if transport_secure
                                                                                ['next_date', current_value, 'no_change_observed', 'high', '', 'none_for_current_value']
                                                                              else
                                                                                reason = 'The current value was observed over plaintext HTTP and cannot support readiness.'
                                                                                ['next_date', current_value, 'no_change_observed', 'low', reason, 'recheck_over_approved_https_or_review_manually']
                                                                              end
                                                                            when 'candidate_change'
                                                                              confidence = pilot && candidate_values.length == 1 && transport_secure ? 'medium' : 'low'
                                                                              reason = if transport_secure
                                                                                         'Approved source has event-associated date candidates, but the current date was not associated reliably.'
                                                                                       else
                                                                                         'Date candidates observed over plaintext HTTP cannot support an exact proposal.'
                                                                                       end
                                                                              exact_candidate = candidate_values.length == 1 && transport_secure ? candidate_values.first : ''
                                                                              ['next_date', exact_candidate, 'candidate_difference', confidence, reason, 'compare_source_and_current_dates']
                                                                            when 'cancellation_evidence'
                                                                              reason = row['cancellation_evidence_detail'].to_s.strip
                                                                              ['listing_status', 'cancellation_review_required', 'cancellation_evidence', 'medium', reason, 'verify_authoritative_cancellation_before_any_listing_change']
                                                                            when 'source_unavailable'
                                                                              reason = "Source fetch returned #{row['fetch_status']} #{row['fetch_detail']}; this is not cancellation evidence."
                                                                              ['source_availability', '', 'source_availability_review', 'none', reason, 'check_source_manually_without_removing_listing']
                                                                            else
                                                                              reason = 'Show identity or date could not be associated reliably; wording or parser review is required.'
                                                                              ['listing_identity', '', 'insufficient_evidence', 'low', reason, 'inspect_source_and_parser_match']
                                                                            end

    expectation_matches = expectation.nil? ? nil : expectation == outcome
    false_positive = !expectation.nil? &&
                     %w[candidate_change cancellation_evidence].include?(outcome) &&
                     expectation != outcome
    false_negative = !expectation.nil? &&
                     %w[current_match candidate_change cancellation_evidence].include?(expectation) &&
                     expectation != outcome
    source_key = row['source_key'].to_s
    show_id = row['show_id'].to_s

    fact = {
      proposal_id: "#{source_key}:#{show_id}:#{field}",
      source_key: source_key,
      show_id: show_id,
      show_name: show ? show.fetch('name') : row['show_name'].to_s,
      field: field,
      current_value: current_value,
      proposed_value: proposed_value,
      source_candidate_values: candidate_values,
      proposal_status: status,
      risk_level: %w[candidate_change cancellation_evidence].include?(outcome) ? 'high' : 'medium',
      source_tier: source_tier(source_type, source_url),
      source_type: source_type.to_s,
      source_url: source_url.to_s,
      request_url: evidence_url.to_s,
      fetched_at: fetched_at.to_s,
      fetch_status: row['fetch_status'].to_s,
      fetch_detail: row['fetch_detail'].to_s,
      redirect_target: row['redirect_target'].to_s,
      name_found: truthy?(row['name_found']),
      current_date_found: truthy?(row['current_date_found']),
      candidate_match_basis: row['candidate_match_basis'].to_s,
      candidate_count: candidate_values.length,
      cancellation_evidence: truthy?(row['cancellation_evidence']),
      cancellation_evidence_detail: row['cancellation_evidence_detail'].to_s,
      confidence: confidence,
      conflict_reason: conflict_reason,
      pilot_source: pilot,
      manual_expectation: expectation.to_s,
      actual_outcome: outcome,
      expectation_matches: expectation_matches,
      false_positive: false_positive,
      false_negative: false_negative,
      controlled_case: controlled,
      transport_secure: transport_secure,
      eligible_for_change_proposal: !controlled && pilot && expectation == 'candidate_change' &&
                                    outcome == 'candidate_change' && candidate_values.length == 1 && transport_secure,
      human_action: controlled ? 'controlled_case_only_no_listing_change' : human_action,
      automatic_action: 'none'
    }

    fact[:cause_code] = source_fact_cause(fact)
    fact
  end

  def source_fact_cause(fact)
    case fact.fetch(:proposal_status)
    when 'no_change_observed'
      fact.fetch(:transport_secure, false) ? 'current_value_observed_on_source' : 'current_value_observed_over_plaintext_http'
    when 'candidate_difference'
      candidate_difference_cause(fact)
    when 'source_availability_review'
      source_availability_cause(fact.fetch(:fetch_status))
    when 'cancellation_evidence'
      'explicit_authoritative_cancellation_evidence'
    when 'insufficient_evidence'
      if fact.fetch(:candidate_count).positive?
        'show_name_not_associated_with_page_dates'
      else
        'show_name_not_associated_no_dates_extracted'
      end
    else
      'unclassified_source_fact'
    end
  end

  def candidate_difference_cause(fact)
    current_value = fact.fetch(:current_value).to_s
    candidates = Array(fact.fetch(:source_candidate_values, fact.fetch(:proposed_value, '')))
                 .flat_map { |value| value.to_s.split(';') }
                 .map(&:strip)
                 .reject(&:empty?)

    return 'current_tbd_with_candidates' if current_value.casecmp('TBD').zero?
    if candidates.any? { |candidate| normalized(candidate) == normalized(current_value) }
      return 'current_value_present_but_not_associated'
    end
    return 'multiple_page_dates_need_event_association' if candidates.length > 1

    'single_different_candidate'
  end

  def source_availability_cause(status)
    value = status.to_s
    return 'redirect_response_not_followed' if value.match?(/\A3\d\d\z/)
    return 'access_blocked' if %w[401 403].include?(value)
    return 'source_rate_limited' if value == '429'
    return 'source_path_not_found' if %w[404 410].include?(value)
    return 'source_server_error' if value.match?(/\A5\d\d\z/)
    return 'network_or_transport_error' if value == 'error'
    return 'network_disabled_dry_run' if value == 'dry_run'
    return 'unsupported_request_scheme' if value == 'skip'

    'other_source_availability_failure'
  end

  def secure_transport?(url)
    uri = URI.parse(url.to_s)
    uri.scheme == 'https' && !uri.host.to_s.empty?
  rescue URI::InvalidURIError
    false
  end

  def phase_two_ready?(source_count:, live_baseline_source_count:, live_quality:, controlled_quality:,
                       automatic_actions:, unresolved_facts:, comparison_evidence:, secure_transport:)
    live_baseline_source_count == source_count &&
      live_quality.all? { |row| row.fetch(:expectation_matches) } &&
      controlled_quality.all? { |row| row.fetch(:expectation_matches) } &&
      automatic_actions.zero? && unresolved_facts.empty? &&
      comparison_evidence.fetch(:live) && comparison_evidence.fetch(:classification_current) && secure_transport
  end

  def duplicate_candidates(shows)
    shows_by_id = shows.to_h { |show| [show.fetch('id'), show] }

    ShowDataTrustAudit.duplicate_candidates(shows).map do |candidate|
      left_id, right_id = candidate.listing_ids
      left = shows_by_id.fetch(left_id)
      right = shows_by_id.fetch(right_id)

      {
        left_id: left_id,
        left_name: left.fetch('name'),
        left_url: "/shows/#{left_id}/",
        right_id: right_id,
        right_name: right.fetch('name'),
        right_url: "/shows/#{right_id}/",
        city: left.fetch('city'),
        state: left.fetch('state'),
        classification: candidate.classification,
        confidence: candidate.confidence,
        reason: candidate.reason,
        human_action: 'review_possible_duplicate_without_merging',
        automatic_action: 'none'
      }
    end
  end
end
