# frozen_string_literal: true

require 'date'
require_relative 'show_date_parser'

module ShowDateStatus
  SCHEDULED = :scheduled
  DATE_NOT_CONFIRMED = :date_not_confirmed
  PAST_DATE_UNCONFIRMED = :past_date_unconfirmed
  PAST_SHOW = :past_show

  LABELS = {
    SCHEDULED => 'Scheduled',
    DATE_NOT_CONFIRMED => 'Date not confirmed',
    PAST_DATE_UNCONFIRMED => 'Past date — next date unconfirmed',
    PAST_SHOW => 'Past show'
  }.freeze

  module_function

  def confirmed_dates(show)
    Array(show['upcoming_dates']).map do |value|
      Date.iso8601(value.to_s)
    rescue Date::Error
      nil
    end.compact.sort.uniq
  end

  def ranges(show)
    confirmed_dates(show).each_with_object([]) do |date, grouped|
      if grouped.empty? || date > grouped.last.last + 1
        grouped << [date, date]
      else
        grouped.last[1] = date
      end
    end
  end

  def active_range(show, as_of:)
    ranges(show).find { |_start_date, end_date| end_date >= as_of }
  end

  def classification(show, as_of:)
    return SCHEDULED if active_range(show, as_of: as_of)
    return show['series_ended'] == true ? PAST_SHOW : PAST_DATE_UNCONFIRMED if confirmed_dates(show).any?

    DATE_NOT_CONFIRMED
  end

  def display_date(show, as_of:)
    range = active_range(show, as_of: as_of)
    range ? format_range(*range) : nil
  end

  def last_confirmed_date(show)
    range = ranges(show).last
    range ? format_range(*range) : nil
  end

  def format_range(start_date, end_date)
    return start_date.strftime('%B %-d, %Y') if start_date == end_date
    return "#{start_date.strftime('%B %-d')}-#{end_date.strftime('%-d, %Y')}" if start_date.year == end_date.year && start_date.month == end_date.month
    return "#{start_date.strftime('%B %-d')}-#{end_date.strftime('%B %-d, %Y')}" if start_date.year == end_date.year

    "#{start_date.strftime('%B %-d, %Y')}-#{end_date.strftime('%B %-d, %Y')}"
  end

  def weekend_window(as_of)
    saturday_offset = as_of.sunday? ? -1 : 6 - as_of.wday
    saturday = as_of + saturday_offset
    [saturday, saturday + 1]
  end

  def overlaps?(show, start_date, end_date)
    ranges(show).any? do |range_start, range_end|
      range_start <= end_date && range_end >= start_date
    end
  end
end
