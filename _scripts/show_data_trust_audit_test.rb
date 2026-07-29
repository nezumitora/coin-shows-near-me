#!/usr/bin/env ruby

require 'date'
require 'minitest/autorun'
require 'tmpdir'
require_relative 'show-data-trust-audit'

class ShowDataTrustAuditTest < Minitest::Test
  def test_supported_specific_date
    state = ShowDataTrustAudit.date_text_classification('September 25, 2026')
    assert_equal :specific, state[:precision]
    assert_equal Date.new(2026, 9, 25), state[:start_date]
    assert_equal Date.new(2026, 9, 25), state[:end_date]
  end

  def test_supported_ordinal_date
    state = ShowDataTrustAudit.date_text_classification('Apr 18th, 2026')
    assert_equal :specific, state[:precision]
    assert_equal Date.new(2026, 4, 18), state[:start_date]
  end

  def test_supported_date_range
    state = ShowDataTrustAudit.date_text_classification('July 9-11, 2026')
    assert_equal :specific, state[:precision]
    assert_equal Date.new(2026, 7, 9), state[:start_date]
    assert_equal Date.new(2026, 7, 11), state[:end_date]
  end

  def test_supported_ordinal_date_range
    state = ShowDataTrustAudit.date_text_classification('Apr 17th - 18th, 2026')
    assert_equal :specific, state[:precision]
    assert_equal Date.new(2026, 4, 17), state[:start_date]
    assert_equal Date.new(2026, 4, 18), state[:end_date]
  end

  def test_partial_month_is_ambiguous_not_expired
    state = ShowDataTrustAudit.date_text_classification('July 2026')
    assert_equal :partial_month, state[:precision]

    issues = ShowDataTrustAudit.build_issues([base_show('partial', next_date: 'July 2026')], as_of: Date.new(2026, 7, 29))
    assert_includes issues.map(&:issue_type), 'ambiguous_partial_date'
    refute_includes issues.map(&:issue_type), 'expired_specific_date'
  end

  def test_tbd_value
    state = ShowDataTrustAudit.date_text_classification('TBD')
    assert_equal :tbd, state[:precision]
  end

  def test_unparseable_date
    state = ShowDataTrustAudit.date_text_classification('Soon-ish 2026')
    assert_equal :unparseable, state[:precision]
  end

  def test_expired_specific_date
    issues = ShowDataTrustAudit.build_issues([base_show('expired', next_date: 'December 14, 2025')], as_of: Date.new(2026, 7, 29))
    assert_includes issues.map(&:issue_type), 'expired_specific_date'
  end

  def test_duplicate_candidates_are_classified_without_merging
    shows = [
      base_show('san-fernando-coin-collectible-expo', name: 'San Fernando Coin & Collectible Expo', city: 'San Fernando', state: 'CA'),
      base_show('san-fernando-coin-collectibles-expo', name: 'San Fernando Coin & Collectibles Expo', city: 'San Fernando', state: 'CA'),
      base_show('orland-park-coin-show', name: 'Orland Park Coin Show', city: 'Orland Park', state: 'IL'),
      base_show('orland-park-coin-stamp-show', name: 'Orland Park Coin Stamp Show', city: 'Orland Park', state: 'IL')
    ]

    candidates = ShowDataTrustAudit.duplicate_candidates(shows)
    assert candidates.any? { |candidate| candidate.classification == 'high-confidence' && candidate.listing_ids.include?('san-fernando-coin-collectible-expo') }
    assert candidates.any? { |candidate| candidate.classification == 'low-confidence' && candidate.listing_ids.include?('orland-park-coin-show') }
  end

  def test_tbd_date_contradiction
    issues = ShowDataTrustAudit.build_issues([base_show('dated-title', name: 'Coin Show May 3rd, 2026', next_date: 'TBD')], as_of: Date.new(2026, 7, 29))
    assert_includes issues.map(&:issue_type), 'tbd_date_contradiction'
  end

  def test_schema_diagnostics_for_partial_range_and_unparseable_dates
    partial = ShowDataTrustAudit.date_text_classification('July 2026')
    range = ShowDataTrustAudit.date_text_classification('July 9-11, 2026')
    unparseable = ShowDataTrustAudit.date_text_classification('Soon-ish 2026')

    expired = ShowDataTrustAudit.date_text_classification('December 14, 2025')

    assert ShowDataTrustAudit.visible_schema_mismatch?(partial, Date.new(2026, 7, 29))
    assert ShowDataTrustAudit.visible_schema_mismatch?(range, Date.new(2026, 7, 29))
    assert ShowDataTrustAudit.visible_schema_mismatch?(unparseable, Date.new(2026, 7, 29))
    assert ShowDataTrustAudit.visible_schema_mismatch?(expired, Date.new(2026, 7, 29))
  end

  def test_report_writes_only_to_requested_temp_directory
    Dir.mktmpdir do |dir|
      shows = [base_show('partial', next_date: 'July 2026')]
      issues = ShowDataTrustAudit.build_issues(shows, as_of: Date.new(2026, 7, 29))
      result = ShowDataTrustAudit.write_reports(issues, [], shows, output_dir: dir, as_of: Date.new(2026, 7, 29), inventory_commit: 'abc123', inventory_branch: 'main')

      assert File.exist?(result[:csv_path])
      assert File.exist?(result[:md_path])
      assert result[:csv_path].start_with?(dir)
      assert result[:md_path].start_with?(dir)
    end
  end

  private

  def base_show(id, overrides = {})
    {
      'id' => id,
      'name' => 'Test Coin Show',
      'state' => 'CA',
      'state_name' => 'California',
      'city' => 'Tustin',
      'venue' => 'Test Hall',
      'frequency' => 'Annual',
      'next_date' => 'TBD',
      'website' => 'https://example.com',
      'organizer' => 'Test Organizer',
      'notes' => ''
    }.merge(overrides.transform_keys(&:to_s))
  end
end
