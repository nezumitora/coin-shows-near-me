# frozen_string_literal: true

require 'minitest/autorun'
require 'yaml'
require_relative 'show_date_status'

class ShowDateStatusTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)
  SHOWS = YAML.load_file(File.join(ROOT, '_data/shows.yml'))
  AS_OF = Date.new(2026, 8, 24)
  WEEKEND_AS_OF = Date.new(2026, 8, 23)

  def show(show_id)
    SHOWS.find { |record| record.fetch('id') == show_id }
  end

  def test_frozen_directory_classification_counts
    counts = SHOWS.group_by { |record| ShowDateStatus.classification(record, as_of: AS_OF) }.transform_values(&:length)

    assert_equal 197, SHOWS.length
    assert_equal 102, counts.fetch(:scheduled)
    assert_equal 84, counts.fetch(:date_not_confirmed)
    assert_equal 11, counts.fetch(:past_date_unconfirmed)
    assert_nil counts[:past_show]
  end

  def test_scheduled_records_display_their_first_nonexpired_complete_range
    scheduled = SHOWS.select { |record| ShowDateStatus.classification(record, as_of: AS_OF) == :scheduled }
    mismatches = scheduled.map do |record|
      expected = ShowDateStatus.display_date(record, as_of: AS_OF)
      [record.fetch('id'), record.fetch('next_date'), expected] unless record.fetch('next_date') == expected
    end.compact

    assert_empty mismatches
    assert_equal 'October 4, 2026', ShowDateStatus.display_date(show('north-county-monthly-coin-show'), as_of: AS_OF)
    assert_equal 'September 13, 2026', ShowDateStatus.display_date(show('melville-coin-stamp-collectibles-show'), as_of: AS_OF)
    assert_equal 'August 23, 2026', ShowDateStatus.display_date(show('melville-coin-stamp-collectibles-show'), as_of: WEEKEND_AS_OF)
  end

  def test_complete_display_dates_always_have_confirmed_iso_dates
    missing = SHOWS.select do |record|
      ShowDateParser.date_range(record.fetch('next_date')) && Array(record['upcoming_dates']).empty?
    end

    assert_empty missing
    assert_equal %w[2026-09-25 2026-09-26], show('waco-coin-show').fetch('upcoming_dates')
    assert_equal %w[2026-09-12 2026-09-13], show('buena-park-coin-show').fetch('upcoming_dates')
    assert_includes show('fun-convention').fetch('upcoming_dates'), '2027-01-10'
  end

  def test_frozen_weekend_uses_saturday_and_sunday_overlap_only
    saturday, sunday = ShowDateStatus.weekend_window(WEEKEND_AS_OF)
    ids = SHOWS.select { |record| ShowDateStatus.overlaps?(record, saturday, sunday) }.map { |record| record.fetch('id') }.sort

    assert_equal Date.new(2026, 8, 22), saturday
    assert_equal Date.new(2026, 8, 23), sunday
    assert_equal %w[
      boeing-employees-coin-club-show
      melville-coin-stamp-collectibles-show
      palm-beach-coin-show
      sacramento-coin-show
      salemroanoke-valley-coin-show
      santa-clara-coin-show
      tallahassee-coin-club-two-day-show
      trevose-coin-show-every-4th-sunday-of-the-month
    ], ids
  end

  def test_past_show_requires_an_explicit_ended_series_flag
    recurring = { 'upcoming_dates' => ['2026-08-09'] }
    ended = recurring.merge('series_ended' => true)

    assert_equal :past_date_unconfirmed, ShowDateStatus.classification(recurring, as_of: AS_OF)
    assert_equal :past_show, ShowDateStatus.classification(ended, as_of: AS_OF)
    assert_equal :date_not_confirmed, ShowDateStatus.classification({ 'frequency' => 'Every Sunday' }, as_of: AS_OF)
  end
end
