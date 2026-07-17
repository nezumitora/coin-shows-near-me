# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'show_date_parser'

class ShowDateParserTest < Minitest::Test
  def test_parses_single_date
    assert_equal Date.new(2026, 7, 19), ShowDateParser.end_date('July 19, 2026')
  end

  def test_parses_same_month_range_using_end_date
    assert_equal Date.new(2026, 10, 3), ShowDateParser.end_date('October 1-3, 2026')
  end

  def test_parses_cross_month_range_using_end_date
    assert_equal Date.new(2026, 10, 3), ShowDateParser.end_date('September 30-October 3, 2026')
  end

  def test_parses_cross_year_range_using_end_date
    assert_equal Date.new(2027, 1, 2), ShowDateParser.end_date('December 30-January 2, 2027')
  end

  def test_parses_unicode_range_separator
    assert_equal Date.new(2027, 1, 10), ShowDateParser.end_date('January 7–10, 2027')
  end

  def test_returns_nil_for_invalid_date
    assert_nil ShowDateParser.end_date('not a date')
  end

  def test_returns_nil_for_invalid_range_start
    assert_nil ShowDateParser.end_date('February 30-March 1, 2027')
  end

  def test_returns_nil_for_reversed_same_month_range
    assert_nil ShowDateParser.end_date('October 3-1, 2026')
  end

  def test_returns_nil_for_implausibly_long_cross_month_range
    assert_nil ShowDateParser.end_date('October 30-September 1, 2026')
  end
end
