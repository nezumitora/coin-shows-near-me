# frozen_string_literal: true

require 'date'

module SourceDateMatcher
  MONTH = '[A-Za-z.]+'
  RANGE_SEPARATOR = '(?:\s*[-–—]\s*|\s+(?:and|to|through)\s+)'

  module_function

  def found?(source_text, current_date_text, calendar_year = nil)
    !match_positions(source_text, current_date_text, calendar_year).empty?
  end

  def match_positions(source_text, current_date_text, calendar_year = nil)
    components = date_components(current_date_text)
    return [] unless components

    allow_missing_year = calendar_year.to_i == components[4]
    pattern = source_pattern(components, allow_missing_year)
    source_text.to_s.enum_for(:scan, pattern).map { Regexp.last_match.begin(0) }
  end

  def date_components(date_text)
    text = date_text.to_s.strip

    if (match = text.match(/\A(#{MONTH})\s+(\d{1,2})\s*[-–—]\s*(#{MONTH})\s+(\d{1,2}),\s*(\d{4})\z/i))
      start_month = month_number(match[1])
      finish_month = month_number(match[3])
      return nil unless start_month && finish_month

      return [start_month, match[2].to_i, finish_month, match[4].to_i, match[5].to_i]
    end

    if (match = text.match(/\A(#{MONTH})\s+(\d{1,2})\s*[-–—]\s*(\d{1,2}),\s*(\d{4})\z/i))
      month = month_number(match[1])
      return nil unless month

      return [month, match[2].to_i, month, match[3].to_i, match[4].to_i]
    end

    date = Date.parse(text)
    [date.month, date.day, nil, nil, date.year]
  rescue ArgumentError
    nil
  end

  def month_number(month_name)
    cleaned = month_name.to_s.downcase.delete('.').sub(/\Asept\z/, 'sep')
    Date::MONTHNAMES.each_with_index do |name, index|
      next unless name

      return index if name.downcase == cleaned || Date::ABBR_MONTHNAMES[index].downcase == cleaned
    end
    nil
  end

  def source_pattern(components, allow_missing_year)
    start_month, start_day, finish_month, finish_day, year = components
    start_expression = "#{month_expression(start_month)}\\s+#{day_expression(start_day)}"
    if finish_month && finish_month != start_month
      start_year = start_month > finish_month ? year - 1 : year
      start_expression = "#{start_expression}(?:,?\\s+#{start_year})?"
    end
    date_expression = if finish_month
                        finish_expression = finish_month == start_month ? '' : "#{month_expression(finish_month)}\\s+"
                        "#{start_expression}#{RANGE_SEPARATOR}#{finish_expression}#{day_expression(finish_day)}"
                      else
                        start_expression
                      end

    year_expression = allow_missing_year ? "(?:,?\\s+#{year})?" : ",?\\s+#{year}"
    /\b#{date_expression}#{year_expression}\b/i
  end

  def month_expression(month)
    full = Regexp.escape(Date::MONTHNAMES.fetch(month))
    abbreviated = Regexp.escape(Date::ABBR_MONTHNAMES.fetch(month))
    alternatives = [full, "#{abbreviated}\\.?"]
    alternatives << 'Sept\.?' if month == 9
    "(?:#{alternatives.join('|')})"
  end

  def day_expression(day)
    "0?#{day}(?:st|nd|rd|th)?"
  end
end
