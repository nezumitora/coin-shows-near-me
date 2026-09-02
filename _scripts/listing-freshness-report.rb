#!/usr/bin/env ruby
# frozen_string_literal: true

# Build a deterministic, review-only listing freshness queue from canonical
# show data and the latest approved-source comparison artifact.

require 'csv'
require 'date'
require 'time'
require 'yaml'
require_relative 'listing_freshness'
require_relative 'show_source_policy'

REPO_ROOT = File.expand_path('..', __dir__)
SHOWS_PATH = ENV.fetch('SHOWS_PATH', '_data/shows.yml')
EXTERNAL_SOURCES_PATH = ENV.fetch('EXTERNAL_SOURCES_PATH', '_scrapers/external-sources.yml')
THIRD_PARTY_SOURCES_PATH = ENV.fetch('THIRD_PARTY_SOURCES_PATH', '_scrapers/third-party-discovery.yml')
PILOT_CONFIG_PATH = ENV.fetch('LISTING_FRESHNESS_PILOT_PATH', '_scrapers/listing-freshness-pilot.yml')
COMPARISON_PATH = ENV.fetch('EXTERNAL_COMPARISON_PATH', 'tmp/external-source-comparison.csv')
OUTPUT_PATHS = begin
  ListingFreshness.secure_output_paths(
    [
      ENV.fetch('LISTING_FRESHNESS_REPORT_PATH', 'tmp/listing-freshness-report.md'),
      ENV.fetch('LISTING_REVIEW_QUEUE_PATH', 'tmp/listing-review-queue.csv'),
      ENV.fetch('LISTING_PROPOSED_FACTS_PATH', 'tmp/listing-proposed-facts.csv'),
      ENV.fetch('LISTING_PILOT_QUALITY_PATH', 'tmp/listing-pilot-quality.csv'),
      ENV.fetch('LISTING_DUPLICATES_PATH', 'tmp/listing-duplicate-candidates.csv')
    ],
    repo_root: REPO_ROOT,
    forbidden_paths: [SHOWS_PATH, EXTERNAL_SOURCES_PATH, THIRD_PARTY_SOURCES_PATH, PILOT_CONFIG_PATH, COMPARISON_PATH]
  )
rescue ArgumentError => e
  abort e.message
end.freeze
REPORT_PATH, QUEUE_PATH, FACTS_PATH, PILOT_QUALITY_PATH, DUPLICATES_PATH = OUTPUT_PATHS

QUEUE_HEADERS = %w[
  show_id show_name city state current_next_date date_status event_date days_until_event
  last_verified verification_age_days source_url source_type source_tier source_conflict
  risk_level baseline_cadence review_cadence review_due_on due_status reason_codes
  human_action automatic_action
].freeze

FACT_HEADERS = %w[
  proposal_id source_key show_id show_name field current_value proposed_value proposal_status
  risk_level source_tier source_type source_url fetched_at fetch_status fetch_detail name_found
  current_date_found candidate_count cause_code confidence conflict_reason pilot_source
  manual_expectation actual_outcome expectation_matches false_positive false_negative controlled_case
  eligible_for_change_proposal human_action automatic_action
].freeze

PILOT_HEADERS = %w[
  case_kind case_id source_key show_id manual_expectation actual_outcome expectation_matches
  false_positive false_negative proposal_status cause_code current_value proposed_value confidence
  eligible_for_change_proposal human_action automatic_action source_url fetched_at
].freeze

DUPLICATE_HEADERS = %w[
  left_id left_name left_url right_id right_name right_url city state classification confidence
  reason human_action automatic_action
].freeze

CAUSE_ORDER = %w[
  single_different_candidate current_value_present_but_not_associated
  multiple_page_dates_need_event_association current_tbd_with_candidates
  redirect_response_not_followed access_blocked source_path_not_found source_server_error
  network_or_transport_error other_source_availability_failure
  show_name_not_associated_with_page_dates show_name_not_associated_no_dates_extracted
].freeze

CAUSE_DESCRIPTIONS = {
  'single_different_candidate' => 'One extracted date differs from the current value; a person must compare the source context.',
  'current_value_present_but_not_associated' => 'The current value appears in the extracted candidates, but the matcher did not bind it to this show.',
  'multiple_page_dates_need_event_association' => 'A shared or noisy page exposed multiple dates without reliable event-specific association.',
  'current_tbd_with_candidates' => 'The listing is TBD and the source has date candidates that still require confirmation.',
  'redirect_response_not_followed' => 'The approved URL returned a redirect; the report records source health and does not infer cancellation.',
  'access_blocked' => 'The source denied the automated request, so a manual source check is required.',
  'source_path_not_found' => 'The approved path returned not found; this is not cancellation or deletion evidence.',
  'source_server_error' => 'The source returned a server error; retry or inspect manually without changing the listing.',
  'network_or_transport_error' => 'The source could not be reached because of a network or transport error.',
  'other_source_availability_failure' => 'The source response was not usable and needs manual classification.',
  'show_name_not_associated_with_page_dates' => 'Dates were extracted, but the configured show name was not associated reliably.',
  'show_name_not_associated_no_dates_extracted' => 'Neither the configured show name nor usable dates were associated on the fetched page.'
}.freeze

def parse_as_of
  value = ENV.fetch('LISTING_FRESHNESS_AS_OF', Time.now.utc.to_date.iso8601)
  Date.iso8601(value)
rescue ArgumentError
  abort "LISTING_FRESHNESS_AS_OF must be an ISO date: #{value.inspect}"
end

def write_csv(path, headers, rows)
  ListingFreshness.write_secure_output(path, repo_root: REPO_ROOT) do |file|
    csv = CSV.new(file)
    csv << headers
    rows.each do |row|
      csv << headers.map do |header|
        value = row.fetch(header.to_sym, '')
        ListingFreshness.safe_csv_cell(value)
      end
    end
    csv.flush
  end
end

def markdown(value)
  value.to_s.gsub('|', '\\|').gsub(/\s+/, ' ').strip
end

def count_by(rows, key)
  rows.group_by { |row| row.fetch(key) }.transform_values(&:length)
end

def source_conflict_code(fact)
  case fact.fetch(:proposal_status)
  when 'candidate_difference'
    'source_date_candidate_conflict'
  when 'source_availability_review'
    'source_unavailable_not_cancellation'
  when 'insufficient_evidence'
    'source_identity_or_parser_gap'
  end
end

def cause_table(facts, proposal_status)
  counts = facts.select { |fact| fact.fetch(:proposal_status) == proposal_status }
                .group_by { |fact| fact.fetch(:cause_code) }
                .transform_values(&:length)
  rows = CAUSE_ORDER.select { |cause| counts.key?(cause) }.map do |cause|
    "| `#{cause}` | #{counts.fetch(cause)} | #{markdown(CAUSE_DESCRIPTIONS.fetch(cause))} |"
  end
  rows.empty? ? '| `none` | 0 | No rows in this category. |' : rows.join("\n")
end

as_of = parse_as_of
generated_at = ENV.fetch('LISTING_FRESHNESS_GENERATED_AT', Time.now.utc.iso8601)
fallback_fetched_at = ENV.fetch('EXTERNAL_COMPARISON_FETCHED_AT', '')

shows = YAML.load_file(SHOWS_PATH)
external_sources = YAML.load_file(EXTERNAL_SOURCES_PATH)
third_party_sources = YAML.load_file(THIRD_PARTY_SOURCES_PATH)
pilot_config = YAML.load_file(PILOT_CONFIG_PATH)
comparison_rows = File.exist?(COMPARISON_PATH) ? CSV.read(COMPARISON_PATH, headers: true).map(&:to_h) : []

begin
  ListingFreshness.validate_unique_comparison_rows!(comparison_rows)
rescue ArgumentError => e
  abort e.message
end

shows_by_id = shows.to_h { |show| [show.fetch('id'), show] }
sources_by_key = external_sources.to_h { |source| [source.fetch('key'), source] }
sources_by_show_id = Hash.new { |hash, key| hash[key] = [] }
external_sources.each do |source|
  source.fetch('expected_show_ids').each { |show_id| sources_by_show_id[show_id] << source }
end

pilot_sources = pilot_config.fetch('sources')
controlled_cases = pilot_config.fetch('controlled_cases')
pilot_source_keys = pilot_sources.map { |source| source.fetch('source_key') }
pilot_expectations = {}
pilot_sources.each do |source|
  source_key = source.fetch('source_key')
  registered_source = sources_by_key[source_key]
  abort "Pilot source is not in the approved registry: #{source_key}" unless registered_source

  source.fetch('expectations').each do |show_id, expectation|
    unless registered_source.fetch('expected_show_ids').include?(show_id)
      abort "Pilot show is not assigned to approved source #{source_key}: #{show_id}"
    end
    abort "Pilot show is missing from canonical data: #{show_id}" unless shows_by_id.key?(show_id)
    unless %w[current_match candidate_change review_conflict source_unavailable].include?(expectation)
      abort "Unsupported pilot expectation for #{source_key}/#{show_id}: #{expectation}"
    end

    pilot_expectations[[source_key, show_id]] = expectation
  end
end

required_controlled_outcomes = {
  'confirmed_date_change' => 'candidate_change',
  'source_failure' => 'source_unavailable'
}.freeze
controlled_scenarios = controlled_cases.group_by { |fixture| fixture.fetch('scenario') }
required_controlled_outcomes.each_key do |scenario|
  unless Array(controlled_scenarios[scenario]).length == 1
    abort "Controlled pilot must contain exactly one #{scenario} case"
  end
end

controlled_cases.each do |fixture|
  scenario = fixture.fetch('scenario')
  expected_outcome = fixture.fetch('expected_outcome')
  unless required_controlled_outcomes[scenario] == expected_outcome
    abort "Controlled case has an invalid expected outcome: #{fixture.fetch('case_id')}"
  end
  abort "Controlled case collides with canonical data: #{fixture.fetch('show_id')}" if shows_by_id.key?(fixture.fetch('show_id'))
  if sources_by_key.key?(fixture.fetch('source_key'))
    abort "Controlled case collides with the approved source registry: #{fixture.fetch('source_key')}"
  end
  unless fixture.fetch('source_url').match?(%r{\Ahttps://[a-z0-9.-]+\.invalid(?:/|\z)})
    abort "Controlled case must use a reserved .invalid URL: #{fixture.fetch('case_id')}"
  end
  begin
    Time.iso8601(fixture.fetch('fetched_at'))
  rescue ArgumentError
    abort "Controlled case has an invalid source timestamp: #{fixture.fetch('case_id')}"
  end
end

facts = comparison_rows.map do |row|
  source_key = row.fetch('source_key')
  source = sources_by_key[source_key]
  abort "Comparison row uses an unapproved source: #{source_key}" unless source
  show = shows_by_id[row.fetch('show_id')]
  begin
    ListingFreshness.validate_comparison_snapshot!(row: row, show: show)
  rescue ArgumentError => e
    abort e.message
  end

  source_type = source.fetch('source_type')
  source_url = source.fetch('url')
  unless row['source_type'].to_s.empty? || row['source_type'] == source_type
    abort "Comparison source type does not match the approved registry: #{source_key}"
  end
  unless row['source_url'].to_s.empty? || row['source_url'] == source_url
    abort "Comparison source URL does not match the approved registry: #{source_key}"
  end
  unless source.fetch('expected_show_ids').include?(row.fetch('show_id'))
    abort "Comparison show is not assigned to approved source #{source_key}: #{row.fetch('show_id')}"
  end

  fetched_at = row['fetched_at'].to_s
  fetched_at = fallback_fetched_at if fetched_at.empty?
  abort "Comparison row is missing a source timestamp: #{source_key}/#{row.fetch('show_id')}" if fetched_at.empty?
  begin
    Time.iso8601(fetched_at)
  rescue ArgumentError
    abort "Comparison row has an invalid source timestamp: #{source_key}/#{row.fetch('show_id')}"
  end
  key = [source_key, row.fetch('show_id')]

  ListingFreshness.build_source_fact(
    row: row,
    show: show,
    source_type: source_type,
    source_url: source_url,
    fetched_at: fetched_at,
    pilot: pilot_source_keys.include?(source_key),
    expectation: pilot_expectations[key]
  )
end

controlled_facts = controlled_cases.map do |fixture|
  row = {
    'source_key' => fixture.fetch('source_key'),
    'show_id' => fixture.fetch('show_id'),
    'show_name' => fixture.fetch('show_name'),
    'current_next_date' => fixture.fetch('current_next_date'),
    'fetch_status' => fixture.fetch('fetch_status'),
    'fetch_detail' => fixture.fetch('fetch_detail'),
    'name_found' => fixture.fetch('name_found'),
    'current_date_found' => fixture.fetch('current_date_found'),
    'candidate_dates' => fixture.fetch('candidate_dates')
  }
  synthetic_show = { 'id' => fixture.fetch('show_id'), 'name' => fixture.fetch('show_name') }
  fact = ListingFreshness.build_source_fact(
    row: row,
    show: synthetic_show,
    source_type: fixture.fetch('source_type'),
    source_url: fixture.fetch('source_url'),
    fetched_at: fixture.fetch('fetched_at'),
    pilot: true,
    expectation: fixture.fetch('expected_outcome'),
    controlled: true
  )
  unless fact.fetch(:actual_outcome) == fixture.fetch('expected_outcome')
    abort "Controlled case outcome mismatch: #{fixture.fetch('case_id')}"
  end

  fact.merge(
    case_id: fixture.fetch('case_id'),
    scenario: fixture.fetch('scenario'),
    confirmation_basis: fixture.fetch('confirmation_basis')
  )
end

facts_by_show_id = facts.group_by { |fact| fact.fetch(:show_id) }
queue = shows.map do |show|
  show_id = show.fetch('id')
  source_url = ShowSourcePolicy.source_url_for(show)
  source_config = sources_by_show_id[show_id].first
  source_type = show.fetch('source_type', '').to_s
  source_type = source_config&.fetch('source_type', '').to_s if source_type.empty?
  conflict_reasons = Array(facts_by_show_id[show_id]).map { |fact| source_conflict_code(fact) }.compact.uniq

  ListingFreshness.classify(
    show: show,
    as_of: as_of,
    source_url: source_url,
    source_type: source_type,
    conflict_reasons: conflict_reasons
  )
end

queue.sort_by! do |row|
  due_rank = { 'due_now' => 0, 'due_within_7_days' => 1, 'scheduled_later' => 2 }.fetch(row.fetch(:due_status))
  event_rank = row.fetch(:days_until_event) || 99_999
  [ListingFreshness::RISK_RANK.fetch(row.fetch(:risk_level)), due_rank, event_rank, row.fetch(:show_id)]
end

live_pilot_quality = pilot_expectations.map do |(source_key, show_id), expectation|
  fact = facts.find { |candidate| candidate.fetch(:source_key) == source_key && candidate.fetch(:show_id) == show_id }
  actual = fact ? fact.fetch(:actual_outcome) : 'missing_result'
  {
    case_kind: 'live_reviewed_source',
    case_id: "#{source_key}:#{show_id}",
    source_key: source_key,
    show_id: show_id,
    manual_expectation: expectation,
    actual_outcome: actual,
    expectation_matches: expectation == actual,
    false_positive: actual == 'candidate_change' && expectation != 'candidate_change',
    false_negative: expectation == 'candidate_change' && actual != 'candidate_change',
    proposal_status: fact&.fetch(:proposal_status, '').to_s,
    cause_code: fact&.fetch(:cause_code, '').to_s,
    current_value: fact&.fetch(:current_value, '').to_s,
    proposed_value: fact&.fetch(:proposed_value, '').to_s,
    confidence: fact&.fetch(:confidence, '').to_s,
    eligible_for_change_proposal: fact&.fetch(:eligible_for_change_proposal, false),
    human_action: fact&.fetch(:human_action, 'inspect_missing_result'),
    automatic_action: fact&.fetch(:automatic_action, 'none'),
    source_url: fact&.fetch(:source_url, '').to_s,
    fetched_at: fact&.fetch(:fetched_at, fallback_fetched_at).to_s
  }
end

controlled_quality = controlled_facts.map do |fact|
  {
    case_kind: 'controlled_fixture',
    case_id: fact.fetch(:case_id),
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
    proposed_value: fact.fetch(:proposed_value),
    confidence: fact.fetch(:confidence),
    eligible_for_change_proposal: fact.fetch(:eligible_for_change_proposal),
    human_action: fact.fetch(:human_action),
    automatic_action: fact.fetch(:automatic_action),
    source_url: fact.fetch(:source_url),
    fetched_at: fact.fetch(:fetched_at)
  }
end
pilot_quality = live_pilot_quality + controlled_quality

duplicates = ListingFreshness.duplicate_candidates(shows)

write_csv(QUEUE_PATH, QUEUE_HEADERS, queue)
write_csv(FACTS_PATH, FACT_HEADERS, facts)
write_csv(PILOT_QUALITY_PATH, PILOT_HEADERS, pilot_quality)
write_csv(DUPLICATES_PATH, DUPLICATE_HEADERS, duplicates)

risk_counts = count_by(queue, :risk_level)
due_counts = count_by(queue, :due_status)
date_counts = count_by(queue, :date_status)
fact_counts = count_by(facts, :proposal_status)
approved_source_count = queue.count { |row| row.fetch(:source_tier) != 'none' }
configured_show_count = external_sources.flat_map { |source| source.fetch('expected_show_ids') }.uniq.length
pilot_matches = pilot_quality.count { |row| row.fetch(:expectation_matches) }
pilot_false_positives = pilot_quality.count { |row| row.fetch(:false_positive) }
pilot_false_negatives = pilot_quality.count { |row| row.fetch(:false_negative) }
pilot_unreviewed_rows = facts.count do |fact|
  fact.fetch(:pilot_source) && fact.fetch(:manual_expectation).empty?
end
eligible_change_proposals = facts.count { |fact| fact.fetch(:eligible_for_change_proposal) }
missing_source_timestamps = facts.count { |fact| fact.fetch(:fetched_at).empty? }
automatic_listing_changes = (queue + facts + controlled_facts + duplicates).count do |row|
  row.fetch(:automatic_action) != 'none'
end
high_priority_queue = queue.select do |row|
  %w[urgent high].include?(row.fetch(:risk_level)) && row.fetch(:due_status) == 'due_now'
end.first(30)
review_facts = facts.reject { |fact| fact.fetch(:proposal_status) == 'no_change_observed' }.first(30)

report = <<~MD
  # Coin show listing freshness review

  Generated: #{generated_at}
  Classification date: #{as_of.iso8601}
  Approved-source comparison input: `#{File.basename(COMPARISON_PATH)}`

  Review-only. This report does not edit `_data/shows.yml`, change a schedule, merge listings, remove listings, publish pages, send messages, submit forms, or update CRM records. Every automatic action is `none`.

  ## Current collection coverage

  - Canonical listings classified: #{shows.length}
  - Listings with a registry-approved source URL: #{approved_source_count}
  - Listings represented in the approved comparison registry: #{configured_show_count}
  - Approved-source comparison rows consumed: #{comparison_rows.length}
  - Third-party state/source batches configured as lead-only: #{third_party_sources.length}
  - Source pages fetched by this classifier: 0
  - Structured source facts without an observed-at timestamp: #{missing_source_timestamps}
  - Potential duplicate pairs queued without merging: #{duplicates.length}

  The classifier consumes existing data and comparison artifacts. It performs no network requests and cannot modify a listing.

  ## Risk queue summary

  - Urgent: #{risk_counts.fetch('urgent', 0)}
  - High: #{risk_counts.fetch('high', 0)}
  - Medium: #{risk_counts.fetch('medium', 0)}
  - Routine: #{risk_counts.fetch('routine', 0)}
  - Due now: #{due_counts.fetch('due_now', 0)}
  - Due within 7 days: #{due_counts.fetch('due_within_7_days', 0)}
  - Scheduled later: #{due_counts.fetch('scheduled_later', 0)}
  - Scheduled dates: #{date_counts.fetch('scheduled', 0)}
  - Past dates: #{date_counts.fetch('past', 0)}
  - TBD dates: #{date_counts.fetch('tbd', 0)}
  - Partial dates: #{date_counts.fetch('partial', 0)}
  - Invalid dates: #{date_counts.fetch('invalid', 0)}

  ## Structured source facts

  - Current values observed on an approved source: #{fact_counts.fetch('no_change_observed', 0)}
  - Candidate date differences requiring comparison: #{fact_counts.fetch('candidate_difference', 0)}
  - Source availability reviews: #{fact_counts.fetch('source_availability_review', 0)}
  - Identity/parser conflicts with insufficient evidence: #{fact_counts.fetch('insufficient_evidence', 0)}
  - Candidate changes eligible for preparation: #{eligible_change_proposals}
  - Candidate changes eligible for unattended publication: 0
  - Automatic listing changes across all real and controlled rows: #{automatic_listing_changes}

  A source fetch failure or missing show name is never treated as cancellation or deletion evidence. Candidate date strings remain evidence for a person to compare; the report never chooses or publishes a date.

  ## Review-bucket cause summary

  ### Possible date differences: #{fact_counts.fetch('candidate_difference', 0)}

  | Cause | Rows | Interpretation |
  |---|---:|---|
  #{cause_table(facts, 'candidate_difference')}

  ### Source availability reviews: #{fact_counts.fetch('source_availability_review', 0)}

  | Cause | Rows | Interpretation |
  |---|---:|---|
  #{cause_table(facts, 'source_availability_review')}

  ### Identity/parser conflicts: #{fact_counts.fetch('insufficient_evidence', 0)}

  | Cause | Rows | Interpretation |
  |---|---:|---|
  #{cause_table(facts, 'insufficient_evidence')}

  These are diagnostic groups, not listing decisions. In particular, redirects, blocked requests, missing paths, unmatched names, and unrelated page dates do not prove cancellation.

  ## Live pilot and controlled hardening cases

  | Kind | Case | Expected | Actual | Report status | Automatic action | Agreement |
  |---|---|---|---|---|---|---:|
  #{pilot_quality.map { |row| "| #{markdown(row.fetch(:case_kind))} | `#{markdown(row.fetch(:case_id))}` | #{markdown(row.fetch(:manual_expectation))} | #{markdown(row.fetch(:actual_outcome))} | #{markdown(row.fetch(:proposal_status))} | #{markdown(row.fetch(:automatic_action))} | #{row.fetch(:expectation_matches)} |" }.join("\n")}

  - Live manually reviewed source rows: #{live_pilot_quality.length}
  - Controlled synthetic hardening rows: #{controlled_quality.length}
  - Total quality rows: #{pilot_quality.length}
  - Rows agreeing with the manual baseline: #{pilot_matches}
  - False positives: #{pilot_false_positives}
  - False negatives: #{pilot_false_negatives}
  - Pilot rows lacking a manual baseline: #{pilot_unreviewed_rows}
  - Automatic listing changes: #{automatic_listing_changes}

  The live pilot still covers one exact organizer date page and one exact promoter event page. The two controlled rows use reserved `.invalid` URLs and synthetic show IDs: one fixed date-change outcome and one fixed 503 source-failure outcome. They are never mixed into the canonical queue and cannot authorize a listing edit. One successful run is not enough evidence to add more parsers or permit automatic edits.

  ## Highest-priority human review queue

  | Show | Risk | Due | Current date | Source tier | Reasons |
  |---|---|---|---|---|---|
  #{high_priority_queue.map { |row| "| `#{markdown(row.fetch(:show_id))}` | #{row.fetch(:risk_level)} | #{row.fetch(:review_due_on)} | #{markdown(row.fetch(:current_next_date))} | #{row.fetch(:source_tier)} | #{markdown(row.fetch(:reason_codes).join(', '))} |" }.join("\n")}

  ## Proposed-versus-current facts needing review

  | Source | Show | Field | Current | Candidate/source fact | Status | Confidence |
  |---|---|---|---|---|---|---|
  #{review_facts.map { |fact| "| #{markdown(fact.fetch(:source_key))} | `#{markdown(fact.fetch(:show_id))}` | #{markdown(fact.fetch(:field))} | #{markdown(fact.fetch(:current_value))} | #{markdown(fact.fetch(:proposed_value))} | #{markdown(fact.fetch(:proposal_status))} | #{markdown(fact.fetch(:confidence))} |" }.join("\n")}

  ## Proposed cadence — not applied

  - Events within 30 days: check approved authoritative sources every 2-3 days, including 21-day, 7-day, and 2-day pre-event milestones.
  - Events 31-90 days away: check weekly.
  - Events more than 90 days away: check monthly and move them to weekly at 90 days.
  - TBD or partial dates: check monthly; move to every two weeks during a documented normal season only after season metadata exists.
  - Third-party discovery: no more than weekly per source/state batch while honoring robots.txt, terms, delays, and stop conditions.
  - Stale cleanup: create a weekly review queue and never auto-delete.
  - Full state-by-state reconciliation: quarterly.
  - Publication: owner-reviewed urgent corrections may be prepared daily; ordinary approved changes may be batched weekly. No unattended merge or publication.

  The three existing workflow schedules remain unchanged in this phase. Approval is required before changing any cron expression or selecting sources by this cadence.

  ## Known gaps and stop conditions

  - Canonical data has no durable `last_changed` field, so “recently changed” cannot yet be classified independently from `last_verified`.
  - Canonical data has no documented season field, so the fortnightly in-season rule is not activated.
  - Generic source matching still produces identity/parser gaps; those rows stay low-confidence and manual.
  - Missing pages, blocked requests, and third-party absence are not cancellation evidence.
  - Duplicate candidates require human review; this phase never merges IDs or writes aliases.
  - A new source, parser, field change, cancellation, merge, redirect, deletion, or publication remains blocked pending human approval.

  ## Artifacts

  - Human-readable report: `#{File.basename(REPORT_PATH)}`
  - Full risk queue: `#{File.basename(QUEUE_PATH)}`
  - Proposed-versus-current facts: `#{File.basename(FACTS_PATH)}`
  - Pilot quality measurements: `#{File.basename(PILOT_QUALITY_PATH)}`
  - Duplicate candidates: `#{File.basename(DUPLICATES_PATH)}`
MD
ListingFreshness.write_secure_output(REPORT_PATH, repo_root: REPO_ROOT) { |file| file.write(report) }

puts "Wrote tmp/#{File.basename(REPORT_PATH)}"
puts "Wrote tmp/#{File.basename(QUEUE_PATH)}"
puts "Wrote tmp/#{File.basename(FACTS_PATH)}"
puts "Wrote tmp/#{File.basename(PILOT_QUALITY_PATH)}"
puts "Wrote tmp/#{File.basename(DUPLICATES_PATH)}"
puts "Review-only freshness summary: listings=#{shows.length} due_now=#{due_counts.fetch('due_now', 0)} urgent=#{risk_counts.fetch('urgent', 0)} high=#{risk_counts.fetch('high', 0)} facts=#{facts.length} pilot_matches=#{pilot_matches}/#{pilot_quality.length} automatic_changes=#{automatic_listing_changes} duplicates=#{duplicates.length}"
