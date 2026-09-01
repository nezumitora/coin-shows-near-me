# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require 'tmpdir'
require 'yaml'
require_relative 'listing_freshness'

class ListingFreshnessTest < Minitest::Test
  AS_OF = Date.new(2026, 8, 30)
  TEST_TEMP_ROOT = File.expand_path('../tmp/listing-freshness-security-tests', __dir__)

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

  def with_test_repo
    FileUtils.mkdir_p(TEST_TEMP_ROOT)
    Dir.mktmpdir('repo-', TEST_TEMP_ROOT) { |repo_root| yield repo_root }
  end

  def test_secure_output_paths_allow_only_unique_direct_tmp_files
    with_test_repo do |repo_root|
      paths = ListingFreshness.secure_output_paths(
        ['tmp/report.md', 'tmp/facts.csv'],
        repo_root: repo_root
      )

      assert_equal File.join(repo_root, 'tmp', 'report.md'), paths.first
      assert_raises(ArgumentError) do
        ListingFreshness.secure_output_paths(['tmp/report.md', 'tmp/report.md'], repo_root: repo_root)
      end
      assert_raises(ArgumentError) do
        ListingFreshness.secure_output_paths(['tmp/nested/report.md'], repo_root: repo_root)
      end
      assert_raises(ArgumentError) do
        ListingFreshness.secure_output_paths(['../shows.yml'], repo_root: repo_root)
      end
    end
  end

  def test_secure_output_paths_reject_inputs_and_symbolic_links
    with_test_repo do |repo_root|
      protected_path = File.join(repo_root, 'protected.yml')
      File.write(protected_path, 'protected')
      output_path = File.join(repo_root, 'tmp', 'report.md')
      FileUtils.mkdir_p(File.dirname(output_path))
      File.symlink(protected_path, output_path)

      assert_raises(ArgumentError) do
        ListingFreshness.secure_output_paths([output_path], repo_root: repo_root)
      end
      File.unlink(output_path)
      assert_raises(ArgumentError) do
        ListingFreshness.secure_output_paths(['tmp/report.md'], repo_root: repo_root, forbidden_paths: ['tmp/report.md'])
      end
    end
  end

  def test_secure_output_write_is_private_and_preserves_old_file_on_failure
    with_test_repo do |repo_root|
      output_path = File.join(repo_root, 'tmp', 'report.md')
      ListingFreshness.write_secure_output(output_path, repo_root: repo_root) { |file| file.write('old') }

      assert_equal 'old', File.read(output_path)
      assert_equal 0, File.stat(output_path).mode & 0o077
      assert_raises(RuntimeError) do
        ListingFreshness.write_secure_output(output_path, repo_root: repo_root) do |file|
          file.write('partial')
          raise 'controlled write failure'
        end
      end
      assert_equal 'old', File.read(output_path)
    end
  end

  def test_private_report_directory_is_excluded_from_site_builds
    config = YAML.load_file(File.expand_path('../_config.yml', __dir__))

    assert_includes config.fetch('exclude'), 'tmp/'
  end

  def test_comparison_snapshot_must_match_canonical_show
    canonical_show = show

    assert ListingFreshness.validate_comparison_snapshot!(row: comparison_row, show: canonical_show)
    assert_raises(ArgumentError) do
      ListingFreshness.validate_comparison_snapshot!(
        row: comparison_row('current_next_date' => 'November 1, 2026'),
        show: canonical_show
      )
    end
    assert_raises(ArgumentError) do
      ListingFreshness.validate_comparison_snapshot!(
        row: comparison_row('show_name' => 'Altered Show'),
        show: canonical_show
      )
    end
    assert_raises(ArgumentError) do
      ListingFreshness.validate_comparison_snapshot!(row: comparison_row, show: nil)
    end
  end

  def test_comparison_snapshot_rejects_duplicate_source_show_rows
    rows = [comparison_row, comparison_row]

    assert_raises(ArgumentError) { ListingFreshness.validate_unique_comparison_rows!(rows) }
    assert ListingFreshness.validate_unique_comparison_rows!([comparison_row])
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
end
