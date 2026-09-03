# frozen_string_literal: true

require 'date'

module SourceDateMatcher
  MONTH = '[A-Za-z.]+'
  RANGE_SEPARATOR = '(?:\s*[-–—]\s*|\s+(?:and|to|through|thru)\s+)'
  SOURCE_MONTH = '(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:t(?:ember)?)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)\.?'
  SOURCE_DAY = '\d{1,2}(?:st|nd|rd|th)?'
  MAX_RANGE_DAYS = 31
  SOURCE_CANDIDATE_PATTERN = /\b(?:
    #{SOURCE_MONTH}\s+#{SOURCE_DAY},?\s+\d{4}#{RANGE_SEPARATOR}#{SOURCE_MONTH}\s+#{SOURCE_DAY},?\s+\d{4}|
    #{SOURCE_MONTH}\s+#{SOURCE_DAY}#{RANGE_SEPARATOR}#{SOURCE_MONTH}\s+#{SOURCE_DAY},?\s+\d{4}|
    #{SOURCE_MONTH}\s+#{SOURCE_DAY}(?:#{RANGE_SEPARATOR}#{SOURCE_DAY})?,?\s+\d{4}|
    \d{1,2}\/\d{1,2}\/\d{4}|
    \d{4}-\d{2}-\d{2}
  )\b/ix.freeze

  module_function

  def found?(source_text, current_date_text, calendar_year = nil)
    !match_positions(source_text, current_date_text, calendar_year).empty?
  end

  def year_within?(date_text, min_year:, max_year:)
    range = candidate_date_range(date_text)
    return false unless range

    range.all? { |date| (min_year..max_year).cover?(date.year) }
  end

  def normalized_candidate(date_text, min_year:, max_year:)
    range = candidate_date_range(date_text)
    return nil unless range && range.all? { |date| (min_year..max_year).cover?(date.year) }

    canonical_range(range.first, range.last)
  end

  def extract_candidates(source_text, min_year:, max_year:, limit: 25)
    raise ArgumentError, 'Candidate limit must be between 1 and 25' unless limit.is_a?(Integer) && limit.between?(1, 25)

    candidates = []
    source_text.to_s.scan(SOURCE_CANDIDATE_PATTERN).each do |raw_value|
      normalized_value = normalized_candidate(raw_value, min_year: min_year, max_year: max_year)
      next unless normalized_value
      next if candidates.any? { |candidate| candidate.fetch(:value) == normalized_value }

      candidates << { raw: raw_value, value: normalized_value }
      break if candidates.length == limit
    end
    candidates
  end

  def match_positions(source_text, current_date_text, calendar_year = nil)
    components = date_components(current_date_text)
    return [] unless components

    allow_missing_year = calendar_year.to_i == components[4]
    pattern = source_pattern(components, allow_missing_year)
    positions = source_text.to_s.enum_for(:scan, pattern).map { Regexp.last_match.begin(0) }
    (positions + split_endpoint_range_positions(source_text, components)).uniq.sort
  end

  def date_components(date_text)
    range = candidate_date_range(date_text)
    return nil unless range

    start_date, finish_date = range
    if start_date == finish_date
      [start_date.month, start_date.day, nil, nil, start_date.year]
    else
      [start_date.month, start_date.day, finish_date.month, finish_date.day, finish_date.year]
    end
  end

  def candidate_date_range(date_text)
    text = date_text.to_s.strip

    if (match = text.match(/\A(#{MONTH})\s+(\d{1,2})(?:st|nd|rd|th)?,?\s+(\d{4})#{RANGE_SEPARATOR}(#{MONTH})\s+(\d{1,2})(?:st|nd|rd|th)?,?\s+(\d{4})\z/i))
      return build_range(match[1], match[2], match[3], match[4], match[5], match[6])
    end

    if (match = text.match(/\A(#{MONTH})\s+(\d{1,2})(?:st|nd|rd|th)?#{RANGE_SEPARATOR}(#{MONTH})\s+(\d{1,2})(?:st|nd|rd|th)?,?\s+(\d{4})\z/i))
      finish_month = month_number(match[3])
      start_month = month_number(match[1])
      return nil unless start_month && finish_month

      finish_year = match[5].to_i
      start_year = start_month > finish_month ? finish_year - 1 : finish_year
      return build_range(match[1], match[2], start_year, match[3], match[4], finish_year)
    end

    if (match = text.match(/\A(#{MONTH})\s+(\d{1,2})(?:st|nd|rd|th)?#{RANGE_SEPARATOR}(\d{1,2})(?:st|nd|rd|th)?,?\s+(\d{4})\z/i))
      return build_range(match[1], match[2], match[4], match[1], match[3], match[4])
    end

    if (match = text.match(/\A(#{MONTH})\s+(\d{1,2})(?:st|nd|rd|th)?,?\s+(\d{4})\z/i))
      month = month_number(match[1])
      return nil unless month

      date = Date.new(match[3].to_i, month, match[2].to_i)
      return [date, date]
    end

    if (match = text.match(/\A(\d{1,2})\/(\d{1,2})\/(\d{4})\z/))
      date = Date.new(match[3].to_i, match[1].to_i, match[2].to_i)
      return [date, date]
    end

    if text.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      date = Date.iso8601(text)
      return [date, date]
    end

    nil
  rescue ArgumentError
    nil
  end

  def build_range(start_month_name, start_day, start_year, finish_month_name, finish_day, finish_year)
    start_month = month_number(start_month_name)
    finish_month = month_number(finish_month_name)
    return nil unless start_month && finish_month

    start_date = Date.new(start_year.to_i, start_month, start_day.to_i)
    finish_date = Date.new(finish_year.to_i, finish_month, finish_day.to_i)
    return nil unless (finish_date - start_date).to_i.between?(0, MAX_RANGE_DAYS)

    [start_date, finish_date]
  rescue ArgumentError
    nil
  end

  def canonical_range(start_date, finish_date)
    start_value = "#{Date::MONTHNAMES.fetch(start_date.month)} #{start_date.day}"
    return "#{start_value}, #{start_date.year}" if start_date == finish_date

    finish_value = if start_date.month == finish_date.month && start_date.year == finish_date.year
                     finish_date.day.to_s
                   else
                     "#{Date::MONTHNAMES.fetch(finish_date.month)} #{finish_date.day}"
                   end
    "#{start_value}-#{finish_value}, #{finish_date.year}"
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

  def split_endpoint_range_positions(source_text, components)
    start_month, start_day, finish_month, finish_day, year = components
    return [] unless finish_month

    start_year = start_month > finish_month ? year - 1 : year
    weekday = '(?:(?:Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\s+)?'
    pattern = /\b#{month_expression(start_month)}\s+#{day_expression(start_day)},?\s+#{start_year}#{RANGE_SEPARATOR}#{weekday}#{month_expression(finish_month)}\s+#{day_expression(finish_day)},?\s+#{year}\b/i
    source_text.to_s.enum_for(:scan, pattern).map { Regexp.last_match.begin(0) }
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
