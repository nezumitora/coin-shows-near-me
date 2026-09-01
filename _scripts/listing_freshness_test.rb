# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'listing_freshness'
require_relative 'listing_freshness_profile'

class ListingFreshnessTest < Minitest::Test
  AS_OF = Date.new(2026, 8, 30)

  def show(overrides = {})
    {
      'id' => 'sample-show',
      'name' => 'Sample Coin Show',
      'city' => 'Sample City',
      'state' => 'CA',
      'next_date' => 'October 15, 2026',
      'last_verified' => '2026-08-29'
    }.merge(overrides)
  end

  def comparison_row(overrides = {})
    {
      'source_key' => 'sample-source',
      'show_id' => 'sample-show',
      'show_name' => 'Sample Coin Show',
      'current_next_date' => 'October 15, 2026',
      'name_found' => 'true',
      'current_date_found' => 'true',
      'candidate_dates' => 'October 15, 2026',
      'fetch_status' => '200',
      'fetch_detail' => 'OK'
    }.merge(overrides)
  end

  def test_applies_distance_based_cadence
    within_30 = ListingFreshness.classify(
      show: show('next_date' => 'September 15, 2026'),
      as_of: AS_OF,
      source_url: 'https://example.test/show',
      source_type: 'promoter'
    )
    within_90 = ListingFreshness.classify(
      show: show('next_date' => 'November 15, 2026'),
      as_of: AS_OF,
      source_url: 'https://example.test/show',
      source_type: 'promoter'
    )
    beyond_90 = ListingFreshness.classify(
      show: show('next_date' => 'January 15, 2027'),
      as_of: AS_OF,
      source_url: 'https://example.test/show',
      source_type: 'promoter'
    )

    assert_equal 'every_2_to_3_days', within_30.fetch(:baseline_cadence)
    assert_equal 'weekly', within_90.fetch(:baseline_cadence)
    assert_equal 'monthly', beyond_90.fetch(:baseline_cadence)
  end

  def test_includes_21_7_and_2_day_milestones
    event = {
      date_status: 'scheduled',
      event_date: Date.new(2026, 10, 1),
      days_until_event: 32
    }

    due_date = ListingFreshness.due_on(
      as_of: AS_OF,
      last_verified: Date.new(2026, 8, 29),
      event: event,
      interval_days: 40,
      conflict_reasons: []
    )

    assert_equal Date.new(2026, 9, 10), due_date
  end

  def test_tbd_and_past_dates_enter_review_queues
    tbd = ListingFreshness.classify(
      show: show('next_date' => 'TBD'),
      as_of: AS_OF,
      source_url: '',
      source_type: ''
    )
    past = ListingFreshness.classify(
      show: show('next_date' => 'August 1, 2026'),
      as_of: AS_OF,
      source_url: '',
      source_type: ''
    )

    assert_equal 'monthly_unconfirmed_queue', tbd.fetch(:baseline_cadence)
    assert_equal 'weekly_stale_queue', past.fetch(:baseline_cadence)
    assert_equal 'none', tbd.fetch(:automatic_action)
    assert_equal 'none', past.fetch(:automatic_action)
  end

  def test_conflict_is_due_now_without_selecting_a_change
    result = ListingFreshness.classify(
      show: show,
      as_of: AS_OF,
      source_url: 'https://example.test/show',
      source_type: 'organizer',
      conflict_reasons: ['source_date_candidate_conflict']
    )

    assert_equal 'due_now', result.fetch(:due_status)
    assert_equal 'immediate_conflict_review', result.fetch(:review_cadence)
    assert_includes result.fetch(:reason_codes), 'source_date_candidate_conflict'
    assert_equal 'none', result.fetch(:automatic_action)
  end

  def test_source_failure_never_becomes_cancellation_evidence
    fact = ListingFreshness.build_source_fact(
      row: comparison_row('fetch_status' => '404', 'fetch_detail' => 'Not Found'),
      show: show,
      source_type: 'promoter',
      source_url: 'https://example.test/show',
      fetched_at: '2026-08-30T12:00:00Z',
      pilot: false
    )

    assert_equal 'source_availability', fact.fetch(:field)
    assert_equal 'source_availability_review', fact.fetch(:proposal_status)
    assert_equal 'source_path_not_found', fact.fetch(:cause_code)
    assert_includes fact.fetch(:conflict_reason), 'not cancellation evidence'
    assert_equal 'none', fact.fetch(:automatic_action)
  end

  def test_candidate_change_requires_matching_pilot_baseline_for_eligibility
    fact = ListingFreshness.build_source_fact(
      row: comparison_row(
        'current_date_found' => 'false',
        'candidate_dates' => 'November 1, 2026'
      ),
      show: show,
      source_type: 'organizer',
      source_url: 'https://example.test/show',
      fetched_at: '2026-08-30T12:00:00Z',
      pilot: true,
      expectation: 'candidate_change'
    )

    assert_equal 'candidate_difference', fact.fetch(:proposal_status)
    assert_equal 'single_different_candidate', fact.fetch(:cause_code)
    assert fact.fetch(:eligible_for_change_proposal)
    assert_equal 'none', fact.fetch(:automatic_action)
  end

  def test_multiple_candidate_dates_are_preserved_without_an_exact_proposal
    fact = ListingFreshness.build_source_fact(
      row: comparison_row(
        'current_date_found' => 'false',
        'candidate_dates' => 'November 1, 2026; December 1, 2026'
      ),
      show: show,
      source_type: 'organizer',
      source_url: 'https://example.test/show',
      fetched_at: '2026-08-30T12:00:00Z',
      pilot: true,
      expectation: 'candidate_change'
    )

    assert_empty fact.fetch(:proposed_value)
    assert_equal ['November 1, 2026', 'December 1, 2026'], fact.fetch(:source_candidate_values)
    assert_equal 'multiple_page_dates_need_event_association', fact.fetch(:cause_code)
    assert_equal 'none', fact.fetch(:automatic_action)
  end

  def test_explicit_authoritative_cancellation_evidence_is_review_only
    fact = ListingFreshness.build_source_fact(
      row: comparison_row(
        'current_date_found' => 'false',
        'candidate_dates' => '',
        'cancellation_evidence' => 'true',
        'cancellation_evidence_detail' => 'Controlled organizer cancellation statement.'
      ),
      show: show,
      source_type: 'controlled-fixture',
      source_url: 'https://listing-freshness.invalid/cancellation-evidence',
      fetched_at: '2026-08-30T15:02:00Z',
      pilot: true,
      expectation: 'cancellation_evidence',
      controlled: true
    )

    assert_equal 'cancellation_evidence', fact.fetch(:actual_outcome)
    assert_equal 'cancellation_evidence', fact.fetch(:proposal_status)
    assert_equal 'explicit_authoritative_cancellation_evidence', fact.fetch(:cause_code)
    assert_equal 'cancellation_review_required', fact.fetch(:proposed_value)
    refute fact.fetch(:eligible_for_change_proposal)
    assert_equal 'none', fact.fetch(:automatic_action)
  end

  def test_cancellation_flag_without_explicit_detail_fails_closed
    fact = ListingFreshness.build_source_fact(
      row: comparison_row(
        'current_date_found' => 'false',
        'candidate_dates' => '',
        'cancellation_evidence' => 'true',
        'cancellation_evidence_detail' => ''
      ),
      show: show,
      source_type: 'organizer',
      source_url: 'https://example.test/show',
      fetched_at: '2026-08-30T12:00:00Z',
      pilot: false
    )

    assert_equal 'review_conflict', fact.fetch(:actual_outcome)
    assert_equal 'insufficient_evidence', fact.fetch(:proposal_status)
    assert_equal 'none', fact.fetch(:automatic_action)
  end

  def test_expected_live_match_reports_a_parser_false_negative
    fact = ListingFreshness.build_source_fact(
      row: comparison_row(
        'name_found' => 'false',
        'current_date_found' => 'false',
        'candidate_dates' => 'October 15, 2026'
      ),
      show: show,
      source_type: 'association-calendar',
      source_url: 'https://example.test/show',
      fetched_at: '2026-08-30T12:00:00Z',
      pilot: true,
      expectation: 'current_match'
    )

    assert_equal 'review_conflict', fact.fetch(:actual_outcome)
    refute fact.fetch(:false_positive)
    assert fact.fetch(:false_negative)
    assert_equal 'none', fact.fetch(:automatic_action)
  end

  def test_controlled_confirmed_date_change_is_reported_without_listing_change
    fact = ListingFreshness.build_source_fact(
      row: comparison_row(
        'current_date_found' => 'false',
        'candidate_dates' => 'November 1, 2026'
      ),
      show: show,
      source_type: 'controlled-fixture',
      source_url: 'https://listing-freshness.invalid/confirmed-date-change',
      fetched_at: '2026-08-30T15:00:00Z',
      pilot: true,
      expectation: 'candidate_change',
      controlled: true
    )

    assert_equal 'candidate_change', fact.fetch(:actual_outcome)
    assert_equal 'candidate_difference', fact.fetch(:proposal_status)
    assert_equal 'single_different_candidate', fact.fetch(:cause_code)
    assert_equal 'controlled_fixture', fact.fetch(:source_tier)
    refute fact.fetch(:eligible_for_change_proposal)
    assert_equal 'controlled_case_only_no_listing_change', fact.fetch(:human_action)
    assert_equal 'none', fact.fetch(:automatic_action)
  end

  def test_controlled_source_failure_is_review_only_and_not_cancellation
    fact = ListingFreshness.build_source_fact(
      row: comparison_row(
        'fetch_status' => '503',
        'fetch_detail' => 'Controlled service unavailable response',
        'name_found' => 'false',
        'current_date_found' => 'false',
        'candidate_dates' => ''
      ),
      show: show,
      source_type: 'controlled-fixture',
      source_url: 'https://listing-freshness.invalid/source-failure',
      fetched_at: '2026-08-30T15:01:00Z',
      pilot: true,
      expectation: 'source_unavailable',
      controlled: true
    )

    assert_equal 'source_unavailable', fact.fetch(:actual_outcome)
    assert_equal 'source_availability_review', fact.fetch(:proposal_status)
    assert_equal 'source_server_error', fact.fetch(:cause_code)
    assert_includes fact.fetch(:conflict_reason), 'not cancellation evidence'
    refute fact.fetch(:eligible_for_change_proposal)
    assert_equal 'controlled_case_only_no_listing_change', fact.fetch(:human_action)
    assert_equal 'none', fact.fetch(:automatic_action)
  end

  def test_date_difference_causes_distinguish_association_failures
    assert_equal 'single_different_candidate', ListingFreshness.candidate_difference_cause(
      current_value: 'October 15, 2026', proposed_value: 'November 1, 2026'
    )
    assert_equal 'current_value_present_but_not_associated', ListingFreshness.candidate_difference_cause(
      current_value: 'October 15, 2026', proposed_value: 'October 15, 2026; November 1, 2026'
    )
    assert_equal 'multiple_page_dates_need_event_association', ListingFreshness.candidate_difference_cause(
      current_value: 'October 15, 2026', proposed_value: 'November 1, 2026; December 1, 2026'
    )
    assert_equal 'current_tbd_with_candidates', ListingFreshness.candidate_difference_cause(
      current_value: 'TBD', proposed_value: 'November 1, 2026'
    )
  end

  def test_availability_causes_distinguish_response_classes
    assert_equal 'redirect_response_not_followed', ListingFreshness.source_availability_cause('301')
    assert_equal 'access_blocked', ListingFreshness.source_availability_cause('403')
    assert_equal 'source_rate_limited', ListingFreshness.source_availability_cause('429')
    assert_equal 'source_path_not_found', ListingFreshness.source_availability_cause('404')
    assert_equal 'source_server_error', ListingFreshness.source_availability_cause('503')
    assert_equal 'network_or_transport_error', ListingFreshness.source_availability_cause('error')
  end

  def test_third_party_source_is_lead_only
    assert_equal 'lead_only', ListingFreshness.source_tier('third-party-directory', 'https://example.test/show')
    assert_equal 'none', ListingFreshness.source_tier('organizer', '')
  end

  def test_duplicate_candidates_are_flagged_without_merging
    left = show('id' => 'sample-left', 'venue' => 'Sample Hall', 'organizer' => 'Sample Club')
    right = show('id' => 'sample-right', 'venue' => 'Sample Hall', 'organizer' => 'Sample Club')

    candidates = ListingFreshness.duplicate_candidates([left, right])

    assert_equal 1, candidates.length
    assert_equal 'review_possible_duplicate_without_merging', candidates.first.fetch(:human_action)
    assert_equal 'none', candidates.first.fetch(:automatic_action)
  end

  def test_phase_two_profile_is_bounded_to_approved_sources
    external_sources = YAML.load_file(File.expand_path('../_scrapers/external-sources.yml', __dir__))
    profile = ListingFreshnessProfile.load(
      path: File.expand_path('../_scrapers/listing-freshness-phase-2.yml', __dir__),
      external_sources: external_sources
    )

    assert_equal 12, profile.fetch(:source_count)
    assert_equal profile.fetch(:source_keys).uniq, profile.fetch(:source_keys)
    profile.fetch(:sources).each do |source|
      assert_equal(
        source.fetch(:profile).fetch('covered_show_ids').sort,
        source.fetch(:registry).fetch('expected_show_ids').sort
      )
      fail_closed_policy = source.fetch(:profile).fetch('fail_closed_policy')
      assert_equal(
        'none',
        profile.fetch(:config).fetch('policies').fetch('fail_closed').fetch(fail_closed_policy).fetch('automatic_action')
      )
    end
  end

  def test_phase_two_schedule_is_explicitly_inactive
    schedule = ListingFreshnessProfile.load_schedule(
      path: File.expand_path('../_scrapers/listing-freshness-phase-2-schedule.yml', __dir__),
      expected_profile: '_scrapers/listing-freshness-phase-2.yml'
    )

    refute schedule.fetch('enabled')
    refute schedule.fetch('manual_dispatch')
    assert_nil schedule.fetch('cron')
    assert_nil schedule.fetch('workflow_file')
    assert schedule.fetch('requires_owner_approval_to_enable')
    assert schedule.fetch('publication').values.none?
  end

  def test_phase_two_profile_limits_review_overrides_to_exact_same_host_paths
    external_sources = YAML.load_file(File.expand_path('../_scrapers/external-sources.yml', __dir__))
    profile = ListingFreshnessProfile.load(
      path: File.expand_path('../_scrapers/listing-freshness-phase-2.yml', __dir__),
      external_sources: external_sources
    )
    request_pairs = profile.fetch(:sources).flat_map do |source|
      source.fetch(:profile).fetch('covered_show_ids').map do |show_id|
        [source.fetch(:registry).fetch('key'), ListingFreshnessProfile.request_url_for(source: source, show_id: show_id)]
      end
    end

    assert_equal 13, request_pairs.uniq.length
    assert_includes request_pairs, ['vna-calendar', 'https://vnaonline.org/2026-calendar/']
    assert_includes request_pairs, ['ck-shows', 'https://ckshows.com/schedule.htm']
    assert_includes request_pairs, ['buxmont-coin-shows', 'https://www.buxmontcoinshows.com/about-trevose/']
  end

  def test_phase_two_profile_rejects_a_cross_host_request_override
    external_sources = YAML.load_file(File.expand_path('../_scrapers/external-sources.yml', __dir__))
    config = YAML.load_file(File.expand_path('../_scrapers/listing-freshness-phase-2.yml', __dir__))
    config.fetch('sources').first['request_url'] = 'https://unapproved.example/path'

    error = assert_raises(ArgumentError) do
      ListingFreshnessProfile.validate(config: config, external_sources: external_sources)
    end

    assert_includes error.message, 'same-host'

    config = YAML.load_file(File.expand_path('../_scrapers/listing-freshness-phase-2.yml', __dir__))
    config.fetch('sources').first['request_url'] = 'https://pacificexposllc.com:8443/path'
    assert_raises(ArgumentError) do
      ListingFreshnessProfile.validate(config: config, external_sources: external_sources)
    end
  end

  def test_phase_two_profile_rejects_a_recurring_rule_without_an_exact_listing_path
    external_sources = YAML.load_file(File.expand_path('../_scrapers/external-sources.yml', __dir__))
    config = YAML.load_file(File.expand_path('../_scrapers/listing-freshness-phase-2.yml', __dir__))
    buxmont = config.fetch('sources').find { |source| source.fetch('source_key') == 'buxmont-coin-shows' }
    trevose_rule = buxmont.fetch('listing_rules').fetch('trevose-coin-show-every-4th-sunday-of-the-month')
    trevose_rule.delete('request_url')

    error = assert_raises(ArgumentError) do
      ListingFreshnessProfile.validate(config: config, external_sources: external_sources)
    end

    assert_includes error.message, 'exact per-listing request URL'
  end

  def test_phase_two_profile_rejects_unbounded_whole_page_and_distance_rules
    external_sources = YAML.load_file(File.expand_path('../_scrapers/external-sources.yml', __dir__))
    config = YAML.load_file(File.expand_path('../_scrapers/listing-freshness-phase-2.yml', __dir__))
    long_beach = config.fetch('sources').find { |source| source.fetch('source_key') == 'long-beach-expo' }
    long_beach.fetch('listing_rules').fetch('long-beach-expo').delete('request_url')

    page_error = assert_raises(ArgumentError) do
      ListingFreshnessProfile.validate(config: config, external_sources: external_sources)
    end
    assert_includes page_error.message, 'exact single-event request path'

    config = YAML.load_file(File.expand_path('../_scrapers/listing-freshness-phase-2.yml', __dir__))
    antique = config.fetch('sources').find { |source| source.fetch('source_key') == 'antique-coins-mn' }
    antique.fetch('listing_rules').fetch('north-metro-coin-show')['max_name_date_distance'] = 321

    distance_error = assert_raises(ArgumentError) do
      ListingFreshnessProfile.validate(config: config, external_sources: external_sources)
    end
    assert_includes distance_error.message, 'integer from 1 to 320'
  end

  def test_phase_two_profile_rejects_an_unbounded_source_batch
    external_sources = YAML.load_file(File.expand_path('../_scrapers/external-sources.yml', __dir__))
    config = YAML.load_file(File.expand_path('../_scrapers/listing-freshness-phase-2.yml', __dir__))
    config['sources'] = config.fetch('sources').first(9)

    error = assert_raises(ArgumentError) do
      ListingFreshnessProfile.validate(config: config, external_sources: external_sources)
    end

    assert_includes error.message, '10-20 sources'
  end
end
