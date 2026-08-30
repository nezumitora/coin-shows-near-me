# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'listing_freshness'

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
    assert fact.fetch(:eligible_for_change_proposal)
    assert_equal 'none', fact.fetch(:automatic_action)
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
end
