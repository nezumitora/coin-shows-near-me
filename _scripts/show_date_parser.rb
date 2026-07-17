# frozen_string_literal: true

require 'date'

module ShowDateParser
  MONTH = '[A-Za-z]+'
  RANGE_SEPARATOR = '[-–—]'

  module_function

  def end_date(date_text)
    text = date_text.to_s.strip

    if (match = text.match(/\A(#{MONTH})\s+\d{1,2}\s*#{RANGE_SEPARATOR}\s*(#{MONTH})\s+(\d{1,2}),\s*(\d{4})\z/i))
      return Date.parse("#{match[2]} #{match[3]}, #{match[4]}")
    end

    if (match = text.match(/\A(#{MONTH})\s+\d{1,2}\s*#{RANGE_SEPARATOR}\s*(\d{1,2}),\s*(\d{4})\z/i))
      return Date.parse("#{match[1]} #{match[2]}, #{match[3]}")
    end

    Date.parse(text)
  rescue ArgumentError
    nil
  end
end
