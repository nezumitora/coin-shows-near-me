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

  def test_parses_unicode_range_separator
    assert_equal Date.new(2027, 1, 10), ShowDateParser.end_date('January 7–10, 2027')
  end

  def test_returns_nil_for_invalid_date
    assert_nil ShowDateParser.end_date('not a date')
  end
end
