require 'minitest/autorun'
require_relative 'source_date_matcher'

class SourceDateMatcherTest < Minitest::Test
  def test_matches_abbreviated_source_month
    assert SourceDateMatcher.found?('The show is Aug. 30, 2026 at the fairgrounds.', 'August 30, 2026')
  end

  def test_matches_ordinal_and_range_wording
    assert SourceDateMatcher.found?('October 10th and 11th 2026', 'October 10-11, 2026')
  end

  def test_matches_yearless_entry_only_with_explicit_calendar_year
    refute SourceDateMatcher.found?('Aug. 30 Decorah Area Coin Club Show', 'August 30, 2026')
    refute SourceDateMatcher.found?('Aug. 30 Decorah Area Coin Club Show', 'August 30, 2026', 2025)
    assert SourceDateMatcher.found?('Aug. 30 Decorah Area Coin Club Show', 'August 30, 2026', 2026)
  end

  def test_matches_cross_month_range
    assert SourceDateMatcher.found?('Dec. 31, 2026 through Jan. 2, 2027', 'December 31-January 2, 2027')
  end

  def test_matches_exact_range_written_as_two_dated_endpoints
    source = 'The dates are Thursday September 3, 2026 thru Saturday September 5, 2026.'

    assert SourceDateMatcher.found?(source, 'September 3-5, 2026')
    refute SourceDateMatcher.found?(source, 'September 3-6, 2026')
  end

  def test_rejects_wrong_day_or_year
    refute SourceDateMatcher.found?('Aug. 29, 2026', 'August 30, 2026')
    refute SourceDateMatcher.found?('Aug. 30, 2025', 'August 30, 2026')
  end

  def test_rejects_tbd_and_partial_dates
    refute SourceDateMatcher.found?('November 2026', 'TBD')
    refute SourceDateMatcher.found?('November 2026', 'November 2026')
  end

  def test_candidate_year_must_stay_inside_the_review_window
    assert SourceDateMatcher.year_within?('October 3, 2026', min_year: 2025, max_year: 2031)
    assert SourceDateMatcher.year_within?('April 14-16, 2029', min_year: 2025, max_year: 2031)
    refute SourceDateMatcher.year_within?('January 30-31, 3037', min_year: 2025, max_year: 2031)
    refute SourceDateMatcher.year_within?('October 3, 2022', min_year: 2025, max_year: 2031)
    refute SourceDateMatcher.year_within?('February 30-31, 2027', min_year: 2025, max_year: 2031)
    refute SourceDateMatcher.year_within?('October 8-3, 2026', min_year: 2025, max_year: 2031)
  end
end
