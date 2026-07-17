# frozen_string_literal: true

require 'date'

module ShowDateParser
  MONTH = '[A-Za-z]+'
  RANGE_SEPARATOR = '[-–—]'
  MAX_RANGE_DAYS = 31

  module_function

  def end_date(date_text)
    text = date_text.to_s.strip

    if (match = text.match(/\A(#{MONTH})\s+(\d{1,2})\s*#{RANGE_SEPARATOR}\s*(#{MONTH})\s+(\d{1,2}),\s*(\d{4})\z/i))
      start_month = month_number(match[1])
      finish_month = month_number(match[3])
      return nil unless start_month && finish_month

      finish_year = match[5].to_i
      start_year = start_month > finish_month ? finish_year - 1 : finish_year
      start_date = Date.new(start_year, start_month, match[2].to_i)
      finish_date = Date.new(finish_year, finish_month, match[4].to_i)
      return valid_range?(start_date, finish_date) ? finish_date : nil
    end

    if (match = text.match(/\A(#{MONTH})\s+(\d{1,2})\s*#{RANGE_SEPARATOR}\s*(\d{1,2}),\s*(\d{4})\z/i))
      month = month_number(match[1])
      return nil unless month

      start_date = Date.new(match[4].to_i, month, match[2].to_i)
      finish_date = Date.new(match[4].to_i, month, match[3].to_i)
      return valid_range?(start_date, finish_date) ? finish_date : nil
    end

    Date.parse(text)
  rescue ArgumentError
    nil
  end

  def month_number(month_name)
    Date::MONTHNAMES.index { |name| name&.casecmp?(month_name) }
  end

  def valid_range?(start_date, finish_date)
    (finish_date - start_date).to_i.between?(0, MAX_RANGE_DAYS)
  end
end
