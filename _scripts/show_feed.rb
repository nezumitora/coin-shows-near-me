# frozen_string_literal: true

require 'uri'

module ShowFeed
  PUBLIC_FIELDS = %w[
    id
    name
    city
    state
    state_name
    venue
    frequency
    next_date
    upcoming_dates
    series_ended
    postal_code
    website
  ].freeze
  POSTAL_CODE_PATTERN = /\b\d{5}(?:-\d{4})?\b/.freeze

  def self.public_website(value)
    website = value.to_s.strip
    uri = URI.parse(website)
    return '' unless %w[http https].include?(uri.scheme) && !uri.host.to_s.empty?

    website
  rescue URI::InvalidURIError
    ''
  end

  def self.postal_code(show)
    explicit_postal_code = show.fetch('postal_code', '').to_s.strip
    return explicit_postal_code unless explicit_postal_code.empty?

    show.fetch('venue', '').to_s.scan(POSTAL_CODE_PATTERN).last.to_s
  end

  def self.build(shows)
    shows.map do |show|
      PUBLIC_FIELDS.each_with_object({}) do |field, record|
        record[field] = case field
                        when 'postal_code'
                          postal_code(show)
                        when 'upcoming_dates'
                          Array(show[field]).map(&:to_s)
                        when 'series_ended'
                          show[field] == true
                        when 'website'
                          public_website(show.fetch(field, ''))
                        else
                          show.fetch(field, '').to_s
                        end
      end
    end.sort_by do |show|
      [show.fetch('state'), show.fetch('city').downcase, show.fetch('name').downcase, show.fetch('id')]
    end
  end
end
