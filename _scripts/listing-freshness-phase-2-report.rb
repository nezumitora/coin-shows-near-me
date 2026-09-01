#!/usr/bin/env ruby
# frozen_string_literal: true

# Build a bounded Phase 2 review package from the selected official-source
# comparison. This script never fetches a page or edits canonical show data.

require 'csv'
require 'date'
require 'fileutils'
require 'time'
require 'yaml'
require_relative 'listing_freshness'
require_relative 'listing_freshness_profile'

PROFILE_PATH = ENV.fetch('LISTING_FRESHNESS_PROFILE_PATH', '_scrapers/listing-freshness-phase-2.yml')
SCHEDULE_PATH = ENV.fetch('LISTING_FRESHNESS_SCHEDULE_PATH', '_scrapers/listing-freshness-phase-2-schedule.yml')
EXTERNAL_SOURCES_PATH = ENV.fetch('EXTERNAL_SOURCES_PATH', '_scrapers/external-sources.yml')
SHOWS_PATH = ENV.fetch('SHOWS_PATH', '_data/shows.yml')
COMPARISON_PATH = ENV.fetch('EXTERNAL_COMPARISON_PATH', 'tmp/external-source-comparison.csv')
REPORT_PATH = ENV.fetch('LISTING_FRESHNESS_PHASE_2_REPORT_PATH', 'tmp/listing-freshness-phase-2-draft.md')
FACTS_PATH = ENV.fetch('LISTING_FRESHNESS_PHASE_2_FACTS_PATH', 'tmp/listing-freshness-phase-2-draft.csv')
QUALITY_PATH = ENV.fetch('LISTING_FRESHNESS_PHASE_2_QUALITY_PATH', 'tmp/listing-freshness-phase-2-quality.csv')
QUEUE_PATH = ENV.fetch('LISTING_FRESHNESS_PHASE_2_QUEUE_PATH', 'tmp/listing-freshness-phase-2-review-queue.csv')
DUPLICATES_PATH = ENV.fetch('LISTING_FRESHNESS_PHASE_2_DUPLICATES_PATH', 'tmp/listing-freshness-phase-2-duplicates.csv')

FACT_HEADERS = %w[
  evidence_kind scenario source_key show_id show_name field canonical_current_value
  source_observed_current_value proposed_value source_candidate_values proposal_status cause_code
  source_url request_url match_basis source_tier source_type check_method page_shape expected_cadence fetch_status fetch_detail
  redirect_target fetched_at cancellation_evidence confidence conflict_reason manual_expectation
  actual_outcome expectation_matches false_positive false_negative eligible_for_change_proposal
  human_action automatic_action
].freeze

QUALITY_HEADERS = %w[
  evidence_kind case_kind case_id scenario source_key show_id manual_expectation actual_outcome
  expectation_matches false_positive false_negative proposal_status cause_code current_value
  proposed_value source_candidate_values confidence redirect_target cancellation_evidence
  human_action automatic_action source_url fetched_at
].freeze

QUEUE_HEADERS = %w[
  source_key show_id show_name city state current_next_date date_status event_date days_until_event
  last_verified verification_age_days source_url source_type source_tier source_conflict risk_level
  baseline_cadence review_cadence review_due_on due_status reason_codes human_action automatic_action
].freeze

DUPLICATE_HEADERS = %w[
  evidence_kind left_id left_name left_url right_id right_name right_url city state classification
  confidence reason human_action automatic_action
].freeze

EXPECTED_CONTROLLED_SCENARIOS = {
  'confirmed_date_change' => 'candidate_change',
  'redirect' => 'source_unavailable',
  'duplicate' => 'duplicate_candidate',
  'partial_date' => 'partial_date_review',
  'cancellation_evidence' => 'cancellation_evidence',
  'source_failure' => 'source_unavailable'
}.freeze

def parse_as_of
  Date.iso8601(ENV.fetch('LISTING_FRESHNESS_AS_OF', Time.now.utc.to_date.iso8601))
rescue ArgumentError
  abort 'LISTING_FRESHNESS_AS_OF must be an ISO date'
end

def write_csv(path, headers, rows)
  FileUtils.mkdir_p(File.dirname(path))
  CSV.open(path, 'w') do |csv|
    csv << headers
    rows.each do |row|
      csv << headers.map do |header|
        value = row.fetch(header.to_sym, '')
        value.is_a?(Array) ? value.join('; ') : value
      end
    end
  end
end

def markdown(value)
  value = value.join('; ') if value.is_a?(Array)
  value.to_s.gsub('|', '\\|').gsub(/[\r\n]+/, ' ').gsub(/\s+/, ' ').strip
end

def source_conflict_code(fact)
  case fact.fetch(:proposal_status)
  when 'candidate_difference'
    'source_date_candidate_conflict'
  when 'source_availability_review'
    'source_unavailable_not_cancellation'
  when 'insufficient_evidence'
    'source_identity_or_parser_gap'
  when 'cancellation_evidence'
    'explicit_cancellation_evidence_needs_review'
  end
end

def change_outcome?(outcome)
  %w[candidate_change cancellation_evidence duplicate_candidate].include?(outcome)
end

def quality_flags(expected, actual)
  {
    expectation_matches: expected == actual,
    false_positive: change_outcome?(actual) && expected != actual,
    false_negative: %w[current_match candidate_change cancellation_evidence].include?(expected) && expected != actual
  }
end

def controlled_source_row(scenario)
  base = {
    'source_key' => "controlled-#{scenario.tr('_', '-')}",
    'show_id' => "controlled-#{scenario.tr('_', '-')}-show",
    'show_name' => 'Controlled Coin Show',
    'current_next_date' => 'October 15, 2026',
    'fetch_status' => '200',
    'fetch_detail' => 'Controlled successful response',
    'redirect_target' => '',
    'name_found' => 'true',
    'current_date_found' => 'false',
    'candidate_dates' => '',
    'cancellation_evidence' => 'false',
    'cancellation_evidence_detail' => ''
  }

  case scenario
  when 'confirmed_date_change'
    base['candidate_dates'] = 'November 1, 2026'
  when 'redirect'
    base['fetch_status'] = '301'
    base['fetch_detail'] = 'Controlled permanent redirect'
    base['redirect_target'] = 'https://listing-freshness.invalid/reapproved-target-required'
    base['name_found'] = 'false'
  when 'cancellation_evidence'
    base['cancellation_evidence'] = 'true'
    base['cancellation_evidence_detail'] = 'Controlled explicit organizer cancellation statement.'
  when 'source_failure'
    base['fetch_status'] = '503'
    base['fetch_detail'] = 'Controlled service unavailable response'
    base['name_found'] = 'false'
  else
    raise ArgumentError, "Unsupported controlled source scenario: #{scenario}"
  end

  base
end

def controlled_source_quality(case_config, generated_at)
  scenario = case_config.fetch('scenario')
  row = controlled_source_row(scenario)
  show = {
    'id' => row.fetch('show_id'),
    'name' => row.fetch('show_name'),
    'city' => 'Controlled City',
    'state' => 'CA',
    'next_date' => row.fetch('current_next_date'),
    'last_verified' => '2026-08-30'
  }
  expected = case_config.fetch('expected_outcome')
  fact = ListingFreshness.build_source_fact(
    row: row,
    show: show,
    source_type: 'controlled-fixture',
    source_url: "https://listing-freshness.invalid/#{scenario.tr('_', '-')}",
    fetched_at: generated_at,
    pilot: true,
    expectation: expected,
    controlled: true
  )
  flags = quality_flags(expected, fact.fetch(:actual_outcome))

  {
    evidence_kind: 'controlled_fixture',
    case_kind: 'source_fact',
    case_id: case_config.fetch('case_id'),
    scenario: scenario,
    source_key: fact.fetch(:source_key),
    show_id: fact.fetch(:show_id),
    manual_expectation: expected,
    actual_outcome: fact.fetch(:actual_outcome),
    proposal_status: fact.fetch(:proposal_status),
    cause_code: fact.fetch(:cause_code),
    current_value: fact.fetch(:current_value),
    proposed_value: fact.fetch(:proposed_value),
    source_candidate_values: fact.fetch(:source_candidate_values),
    confidence: fact.fetch(:confidence),
    redirect_target: fact.fetch(:redirect_target),
    cancellation_evidence: fact.fetch(:cancellation_evidence),
    human_action: fact.fetch(:human_action),
    automatic_action: fact.fetch(:automatic_action),
    source_url: fact.fetch(:source_url),
    fetched_at: fact.fetch(:fetched_at)
  }.merge(flags)
end

def controlled_partial_quality(case_config, as_of, generated_at)
  show = {
    'id' => 'controlled-partial-date-show',
    'name' => 'Controlled Partial Date Show',
    'city' => 'Controlled City',
    'state' => 'CA',
    'next_date' => 'September 2026',
    'last_verified' => '2026-08-30'
  }
  result = ListingFreshness.classify(
    show: show,
    as_of: as_of,
    source_url: 'https://listing-freshness.invalid/partial-date',
    source_type: 'controlled-fixture'
  )
  actual = result.fetch(:date_status) == 'partial' ? 'partial_date_review' : result.fetch(:date_status)
  expected = case_config.fetch('expected_outcome')

  {
    evidence_kind: 'controlled_fixture',
    case_kind: 'listing_classification',
    case_id: case_config.fetch('case_id'),
    scenario: case_config.fetch('scenario'),
    source_key: 'controlled-partial-date',
    show_id: show.fetch('id'),
    manual_expectation: expected,
    actual_outcome: actual,
    proposal_status: 'review_queue_only',
    cause_code: 'date_partial',
    current_value: show.fetch('next_date'),
    proposed_value: '',
    source_candidate_values: [],
    confidence: 'none',
    redirect_target: '',
    cancellation_evidence: false,
    human_action: result.fetch(:human_action),
    automatic_action: result.fetch(:automatic_action),
    source_url: 'https://listing-freshness.invalid/partial-date',
    fetched_at: generated_at
  }.merge(quality_flags(expected, actual))
end

def controlled_duplicate_quality(case_config, generated_at)
  base = {
    'name' => 'Controlled Duplicate Coin Show',
    'city' => 'Controlled City',
    'state' => 'CA',
    'venue' => 'Controlled Hall',
    'organizer' => 'Controlled Club',
    'next_date' => 'November 1, 2026'
  }
  left = base.merge('id' => 'controlled-duplicate-left')
  right = base.merge('id' => 'controlled-duplicate-right')
  candidates = ListingFreshness.duplicate_candidates([left, right])
  actual = candidates.length == 1 ? 'duplicate_candidate' : 'duplicate_not_detected'
  expected = case_config.fetch('expected_outcome')
  candidate = candidates.first || {}

  quality = {
    evidence_kind: 'controlled_fixture',
    case_kind: 'duplicate',
    case_id: case_config.fetch('case_id'),
    scenario: case_config.fetch('scenario'),
    source_key: '',
    show_id: [left.fetch('id'), right.fetch('id')].join('; '),
    manual_expectation: expected,
    actual_outcome: actual,
    proposal_status: 'duplicate_review_only',
    cause_code: candidate.fetch(:classification, 'none'),
    current_value: '',
    proposed_value: '',
    source_candidate_values: [],
    confidence: candidate.fetch(:confidence, 'none'),
    redirect_target: '',
    cancellation_evidence: false,
    human_action: candidate.fetch(:human_action, 'inspect_controlled_duplicate_failure'),
    automatic_action: candidate.fetch(:automatic_action, 'none'),
    source_url: '',
    fetched_at: generated_at
  }.merge(quality_flags(expected, actual))

  duplicate = candidate.merge(evidence_kind: 'controlled_fixture') unless candidate.empty?
  [quality, duplicate]
end

as_of = parse_as_of
generated_at = ENV.fetch('LISTING_FRESHNESS_GENERATED_AT', Time.now.utc.iso8601)
external_sources = YAML.load_file(EXTERNAL_SOURCES_PATH)
shows = YAML.load_file(SHOWS_PATH)
shows_by_id = shows.to_h { |show| [show.fetch('id'), show] }
profile = ListingFreshnessProfile.load(path: PROFILE_PATH, external_sources: external_sources)
schedule = ListingFreshnessProfile.load_schedule(path: SCHEDULE_PATH, expected_profile: PROFILE_PATH)
comparison_rows = CSV.read(COMPARISON_PATH, headers: true).map(&:to_h)

profile_by_key = profile.fetch(:sources).to_h do |source|
  [source.fetch(:registry).fetch('key'), source]
end
expected_pairs = profile.fetch(:sources).flat_map do |source|
  source_key = source.fetch(:registry).fetch('key')
  source.fetch(:profile).fetch('covered_show_ids').map { |show_id| [source_key, show_id] }
end.sort
observed_pairs = comparison_rows.map { |row| [row.fetch('source_key'), row.fetch('show_id')] }.sort
abort 'Phase 2 comparison rows do not exactly match selected source coverage' unless observed_pairs == expected_pairs

facts = comparison_rows.map do |row|
  source = profile_by_key[row.fetch('source_key')]
  abort "Comparison row is outside the Phase 2 profile: #{row.fetch('source_key')}" unless source

  registry = source.fetch(:registry)
  source_profile = source.fetch(:profile)
  show = shows_by_id[row.fetch('show_id')]
  abort "Comparison row references a missing canonical listing: #{row.fetch('show_id')}" unless show
  abort 'Comparison source URL drifted from the approved registry' unless row.fetch('source_url') == registry.fetch('url')
  expected_request_url = ListingFreshnessProfile.request_url_for(source: source, show_id: row.fetch('show_id'))
  abort 'Comparison request URL drifted from the approved Phase 2 profile' unless row.fetch('request_url') == expected_request_url
  abort 'Comparison source type drifted from the approved registry' unless row.fetch('source_type') == registry.fetch('source_type')
  abort 'Live comparison cannot assert cancellation evidence' if ListingFreshness.truthy?(row['cancellation_evidence'])

  match_basis = row.fetch('match_basis')
  abort 'Comparison row has an unsupported match basis' unless ['', 'exact_date', 'explicit_recurring_rule'].include?(match_basis)
  if !match_basis.empty? && !ListingFreshness.truthy?(row['current_date_found'])
    abort 'Comparison row cannot record a match basis without current-date evidence'
  end
  if match_basis == 'explicit_recurring_rule' && !ListingFreshnessProfile.listing_rule(source: source, show_id: row.fetch('show_id')).key?('recurring_rule')
    abort 'Comparison row asserted recurring evidence without an approved listing rule'
  end

  begin
    Time.iso8601(row.fetch('fetched_at'))
  rescue ArgumentError
    abort "Comparison row has an invalid fetch time: #{row.fetch('source_key')}/#{row.fetch('show_id')}"
  end

  expectation = source_profile.fetch('expectations', {})[row.fetch('show_id')]
  fact = ListingFreshness.build_source_fact(
    row: row,
    show: show,
    source_type: registry.fetch('source_type'),
    source_url: registry.fetch('url'),
    fetched_at: row.fetch('fetched_at'),
    pilot: !expectation.nil?,
    expectation: expectation
  )

  fact.merge(
    evidence_kind: 'live_official_source',
    scenario: 'official_source_comparison',
    check_method: source_profile.fetch('check_method'),
    page_shape: source_profile.fetch('page_shape'),
    expected_cadence: source_profile.fetch('expected_cadence'),
    request_url: row.fetch('request_url'),
    match_basis: match_basis
  )
end

fact_rows = facts.map do |fact|
  proposal_status = fact.fetch(:proposal_status)
  exact_proposed_value = if %w[candidate_difference cancellation_evidence].include?(proposal_status)
                           fact.fetch(:proposed_value)
                         else
                           ''
                         end
  {
    evidence_kind: fact.fetch(:evidence_kind),
    scenario: fact.fetch(:scenario),
    source_key: fact.fetch(:source_key),
    show_id: fact.fetch(:show_id),
    show_name: fact.fetch(:show_name),
    field: fact.fetch(:field),
    canonical_current_value: fact.fetch(:current_value),
    source_observed_current_value: fact.fetch(:current_date_found) ? fact.fetch(:current_value) : '',
    proposed_value: exact_proposed_value,
    source_candidate_values: fact.fetch(:source_candidate_values),
    proposal_status: fact.fetch(:proposal_status),
    cause_code: fact.fetch(:cause_code),
    source_url: fact.fetch(:source_url),
    request_url: fact.fetch(:request_url),
    match_basis: fact.fetch(:match_basis),
    source_tier: fact.fetch(:source_tier),
    source_type: fact.fetch(:source_type),
    check_method: fact.fetch(:check_method),
    page_shape: fact.fetch(:page_shape),
    expected_cadence: fact.fetch(:expected_cadence),
    fetch_status: fact.fetch(:fetch_status),
    fetch_detail: fact.fetch(:fetch_detail),
    redirect_target: fact.fetch(:redirect_target),
    fetched_at: fact.fetch(:fetched_at),
    cancellation_evidence: fact.fetch(:cancellation_evidence),
    confidence: fact.fetch(:confidence),
    conflict_reason: fact.fetch(:conflict_reason),
    manual_expectation: fact.fetch(:manual_expectation),
    actual_outcome: fact.fetch(:actual_outcome),
    expectation_matches: fact.fetch(:expectation_matches),
    false_positive: fact.fetch(:false_positive),
    false_negative: fact.fetch(:false_negative),
    eligible_for_change_proposal: fact.fetch(:eligible_for_change_proposal),
    human_action: fact.fetch(:human_action),
    automatic_action: fact.fetch(:automatic_action)
  }
end

live_quality = facts.each_with_object([]) do |fact, rows|
  next if fact.fetch(:manual_expectation).empty?

  proposal_status = fact.fetch(:proposal_status)
  exact_proposed_value = if %w[candidate_difference cancellation_evidence].include?(proposal_status)
                           fact.fetch(:proposed_value)
                         else
                           ''
                         end

  rows << {
    evidence_kind: 'live_official_source',
    case_kind: 'reviewed_source_baseline',
    case_id: "#{fact.fetch(:source_key)}:#{fact.fetch(:show_id)}",
    scenario: 'official_source_comparison',
    source_key: fact.fetch(:source_key),
    show_id: fact.fetch(:show_id),
    manual_expectation: fact.fetch(:manual_expectation),
    actual_outcome: fact.fetch(:actual_outcome),
    expectation_matches: fact.fetch(:expectation_matches),
    false_positive: fact.fetch(:false_positive),
    false_negative: fact.fetch(:false_negative),
    proposal_status: fact.fetch(:proposal_status),
    cause_code: fact.fetch(:cause_code),
    current_value: fact.fetch(:current_value),
    proposed_value: exact_proposed_value,
    source_candidate_values: fact.fetch(:source_candidate_values),
    confidence: fact.fetch(:confidence),
    redirect_target: fact.fetch(:redirect_target),
    cancellation_evidence: fact.fetch(:cancellation_evidence),
    human_action: fact.fetch(:human_action),
    automatic_action: fact.fetch(:automatic_action),
    source_url: fact.fetch(:source_url),
    fetched_at: fact.fetch(:fetched_at)
  }
end

controlled_configs = profile.fetch(:config).fetch('controlled_cases')
controlled_scenarios = controlled_configs.to_h { |fixture| [fixture.fetch('scenario'), fixture.fetch('expected_outcome')] }
abort 'Phase 2 controlled scenarios are incomplete or unexpected' unless controlled_scenarios == EXPECTED_CONTROLLED_SCENARIOS

controlled_quality = []
controlled_duplicate = nil
controlled_configs.each do |case_config|
  case case_config.fetch('case_kind')
  when 'source_fact'
    controlled_quality << controlled_source_quality(case_config, generated_at)
  when 'listing_classification'
    controlled_quality << controlled_partial_quality(case_config, as_of, generated_at)
  when 'duplicate'
    quality, controlled_duplicate = controlled_duplicate_quality(case_config, generated_at)
    controlled_quality << quality
  else
    abort "Unsupported controlled case kind: #{case_config.fetch('case_kind')}"
  end
end

quality = live_quality + controlled_quality
abort 'A controlled Phase 2 case failed its expected outcome' unless controlled_quality.all? { |row| row.fetch(:expectation_matches) }
abort 'A controlled Phase 2 case proposed an automatic action' unless controlled_quality.all? { |row| row.fetch(:automatic_action) == 'none' }

facts_by_show_id = facts.group_by { |fact| fact.fetch(:show_id) }
queue = expected_pairs.map(&:last).uniq.map do |show_id|
  source = profile.fetch(:sources).find { |candidate| candidate.fetch(:profile).fetch('covered_show_ids').include?(show_id) }
  registry = source.fetch(:registry)
  conflict_reasons = facts_by_show_id.fetch(show_id, []).map { |fact| source_conflict_code(fact) }.compact.uniq
  result = ListingFreshness.classify(
    show: shows_by_id.fetch(show_id),
    as_of: as_of,
    source_url: registry.fetch('url'),
    source_type: registry.fetch('source_type'),
    conflict_reasons: conflict_reasons
  )
  result.merge(source_key: registry.fetch('key'))
end
queue.sort_by! do |row|
  due_rank = { 'due_now' => 0, 'due_within_7_days' => 1, 'scheduled_later' => 2 }.fetch(row.fetch(:due_status))
  [ListingFreshness::RISK_RANK.fetch(row.fetch(:risk_level)), due_rank, row.fetch(:days_until_event) || 99_999, row.fetch(:show_id)]
end

live_duplicates = ListingFreshness.duplicate_candidates(expected_pairs.map(&:last).uniq.map { |show_id| shows_by_id.fetch(show_id) })
duplicate_rows = live_duplicates.map { |row| row.merge(evidence_kind: 'live_canonical_data') }
duplicate_rows << controlled_duplicate if controlled_duplicate

write_csv(FACTS_PATH, FACT_HEADERS, fact_rows)
write_csv(QUALITY_PATH, QUALITY_HEADERS, quality)
write_csv(QUEUE_PATH, QUEUE_HEADERS, queue)
write_csv(DUPLICATES_PATH, DUPLICATE_HEADERS, duplicate_rows)

source_count = profile.fetch(:source_count)
covered_show_count = expected_pairs.map(&:last).uniq.length
live_baseline_source_count = live_quality.map { |row| row.fetch(:source_key) }.uniq.length
missing_baseline_sources = profile.fetch(:source_keys) - live_quality.map { |row| row.fetch(:source_key) }.uniq
live_request_path_count = comparison_rows.map { |row| [row.fetch('source_key'), row.fetch('request_url')] }.uniq.length
live_matches = live_quality.count { |row| row.fetch(:expectation_matches) }
false_positives = live_quality.count { |row| row.fetch(:false_positive) }
false_negatives = live_quality.count { |row| row.fetch(:false_negative) }
unresolved_facts = fact_rows.reject { |row| row.fetch(:proposal_status) == 'no_change_observed' }
exact_date_candidates = fact_rows.count do |row|
  row.fetch(:proposal_status) == 'candidate_difference' && !row.fetch(:proposed_value).to_s.empty?
end
exact_date_matches = fact_rows.count { |row| row.fetch(:match_basis) == 'exact_date' }
recurring_rule_matches = fact_rows.count { |row| row.fetch(:match_basis) == 'explicit_recurring_rule' }
automatic_actions = (fact_rows + quality + queue + duplicate_rows).count do |row|
  row.fetch(:automatic_action, 'none') != 'none'
end
source_statuses = comparison_rows.group_by { |row| row.fetch('source_key') }.transform_values do |rows|
  rows.map { |row| row.fetch('fetch_status') }.uniq.join('; ')
end
ready_for_later_draft_update_review = live_baseline_source_count == source_count &&
                                      false_positives.zero? && false_negatives.zero? &&
                                      controlled_quality.all? { |row| row.fetch(:expectation_matches) } &&
                                      automatic_actions.zero? && unresolved_facts.empty?

FileUtils.mkdir_p(File.dirname(REPORT_PATH))
File.write(REPORT_PATH, <<~MD)
  # Coin listing automation Phase 2 review package

  Generated: #{generated_at}
  Classification date: #{as_of.iso8601}
  Stacked base: draft PR #84 Phase 1 code

  Review-only. This package did not edit `_data/shows.yml`, create or change a listing, follow a redirect, infer a cancellation, merge a duplicate, publish a page, contact a third party, or activate a schedule. Every automatic action is `none`.

  ## Bounded official-source profile

  - Selected official source groups: #{source_count}
  - Covered canonical listings: #{covered_show_count}
  - Live source groups represented: #{source_statuses.length}
  - Exact official source paths requested: #{live_request_path_count}
  - Live baseline source groups: #{live_baseline_source_count}
  - Source groups still lacking a manual quality baseline: #{missing_baseline_sources.length}
  - Inactive schedule enabled: #{schedule.fetch('enabled')}
  - Cron configured: #{!schedule.fetch('cron').nil?}

  | Source | Authority | Tier | Covered shows | Check method | Page shape | Fetch status |
  |---|---|---|---:|---|---|---|
  #{profile.fetch(:sources).map { |source| profile_source = source.fetch(:profile); registry = source.fetch(:registry); "| `#{markdown(registry.fetch('key'))}` | #{markdown(profile_source.fetch('authority_basis'))} | #{markdown(profile_source.fetch('source_tier'))} | #{profile_source.fetch('covered_show_ids').length} | #{markdown(profile_source.fetch('check_method'))} | #{markdown(profile_source.fetch('page_shape'))} | #{markdown(source_statuses.fetch(registry.fetch('key'), 'missing'))} |" }.join("\n")}

  Each source uses the recorded public-facts-only constraint, one request per exact source/path per run, at least a one-second delay, no credentials/forms/outreach, no redirect following, and fail-closed handling. Robots and terms require review before any schedule could be activated.

  ## Live current-versus-proposed facts

  - Live comparison rows: #{fact_rows.length}
  - Current values observed without a proposed change: #{fact_rows.count { |row| row.fetch(:proposal_status) == 'no_change_observed' }}
  - Exact date matches: #{exact_date_matches}
  - Explicit recurring-rule matches: #{recurring_rule_matches}
  - Rows requiring human review: #{unresolved_facts.length}
  - Rows with one exact candidate date: #{exact_date_candidates}
  - Live cancellation proposals: #{fact_rows.count { |row| row.fetch(:proposal_status) == 'cancellation_evidence' }}
  - Automatic listing changes: #{automatic_actions}

  | Source | Show | Field | Current | Exact proposed value | Source candidates | Status | Confidence | Human action |
  |---|---|---|---|---|---|---|---|---|
  #{unresolved_facts.map { |row| "| `#{markdown(row.fetch(:source_key))}` | `#{markdown(row.fetch(:show_id))}` | #{markdown(row.fetch(:field))} | #{markdown(row.fetch(:canonical_current_value))} | #{markdown(row.fetch(:proposed_value))} | #{markdown(row.fetch(:source_candidate_values))} | #{markdown(row.fetch(:proposal_status))} | #{markdown(row.fetch(:confidence))} | #{markdown(row.fetch(:human_action))} |" }.join("\n")}

  A blank exact proposed value means the source exposed no single unambiguous replacement. Candidate values remain evidence only and are never written to canonical data.

  ## Quality measurement

  - Live reviewed baseline rows: #{live_quality.length}
  - Live baseline rows matching manual expectations: #{live_matches}
  - Live false positives: #{false_positives}
  - Live false negatives: #{false_negatives}
  - Controlled simulations: #{controlled_quality.length}
  - Controlled simulations matching expected safety behavior: #{controlled_quality.count { |row| row.fetch(:expectation_matches) }}

  | Evidence | Case | Scenario | Expected | Actual | Automatic action | Agreement |
  |---|---|---|---|---|---|---:|
  #{quality.map { |row| "| #{markdown(row.fetch(:evidence_kind))} | `#{markdown(row.fetch(:case_id))}` | #{markdown(row.fetch(:scenario))} | #{markdown(row.fetch(:manual_expectation))} | #{markdown(row.fetch(:actual_outcome))} | #{markdown(row.fetch(:automatic_action))} | #{row.fetch(:expectation_matches)} |" }.join("\n")}

  The live rows are observations from the selected official sources. Date change, redirect, duplicate, partial date, explicit cancellation evidence, and source failure are controlled simulations using synthetic show IDs and reserved `.invalid` URLs.

  ## Prioritized review queue

  | Show | Source | Risk | Due | Current date | Reasons | Automatic action |
  |---|---|---|---|---|---|---|
  #{queue.map { |row| "| `#{markdown(row.fetch(:show_id))}` | `#{markdown(row.fetch(:source_key))}` | #{markdown(row.fetch(:risk_level))} | #{markdown(row.fetch(:review_due_on))} | #{markdown(row.fetch(:current_next_date))} | #{markdown(row.fetch(:reason_codes))} | #{markdown(row.fetch(:automatic_action))} |" }.join("\n")}

  ## Inactive cadence design

  - Within 30 days: every 2-3 days, including 21-day, 7-day, and 2-day milestones.
  - 31-90 days: weekly.
  - More than 90 days: monthly.
  - Past listings: weekly stale review queue.
  - TBD or partial dates: monthly unconfirmed review queue.
  - Workflow file: none.
  - Cron: none.
  - Manual dispatch: disabled.
  - Owner approval required before activation: #{schedule.fetch('requires_owner_approval_to_enable')}.

  ## Readiness gate

  Mechanically ready for a later approval-gated draft-update phase: #{ready_for_later_draft_update_review}

  This gate stays false while any selected source lacks a reviewed baseline, a quality mismatch exists, an automatic action appears, or a live source fact remains unresolved. Even a true gate would authorize only another owner decision; it would not authorize listing edits, merge, deployment, publication, or scheduling.

  Missing baseline source groups: #{missing_baseline_sources.empty? ? 'none' : missing_baseline_sources.map { |key| "`#{markdown(key)}`" }.join(', ')}

  ## Artifacts

  - Draft review report: `#{File.basename(REPORT_PATH)}`
  - Full current-versus-proposed facts: `#{File.basename(FACTS_PATH)}`
  - Live and controlled quality evidence: `#{File.basename(QUALITY_PATH)}`
  - Prioritized selected-listing queue: `#{File.basename(QUEUE_PATH)}`
  - Live and controlled duplicate evidence: `#{File.basename(DUPLICATES_PATH)}`
MD

puts "Wrote #{REPORT_PATH}"
puts "Wrote #{FACTS_PATH}"
puts "Wrote #{QUALITY_PATH}"
puts "Wrote #{QUEUE_PATH}"
puts "Wrote #{DUPLICATES_PATH}"
puts "Phase 2 review-only summary: sources=#{source_count} shows=#{covered_show_count} live_rows=#{fact_rows.length} baselines=#{live_baseline_source_count}/#{source_count} unresolved=#{unresolved_facts.length} false_positives=#{false_positives} false_negatives=#{false_negatives} controlled=#{controlled_quality.count { |row| row.fetch(:expectation_matches) }}/#{controlled_quality.length} automatic_changes=#{automatic_actions} ready=#{ready_for_later_draft_update_review}"
