#!/usr/bin/env ruby
# Generate a review-only freshness report for Coin Shows listings.
# Run from repo root: ruby _scripts/show-update-report.rb

require 'date'
require 'fileutils'
require 'net/http'
require 'time'
require 'uri'
require 'yaml'

REPORT_PATH = 'tmp/show-update-report.md'
REQUEST_TIMEOUT = 8
MAX_URL_CHECKS = Integer(ENV.fetch('MAX_URL_CHECKS', '80'))

shows = YAML.load_file('_data/shows.yml')
now = Time.now.utc

specific = []
partial = []
tbd = []
missing_url = []

shows.each do |show|
  date_text = show.fetch('next_date', '').to_s.strip
  if date_text.empty? || date_text == 'TBD'
    tbd << show
  elsif date_text.include?(',')
    specific << show
  else
    partial << show
  end

  website = show.fetch('website', '').to_s.strip
  missing_url << show if website.empty?
end

def check_url(url)
  uri = URI.parse(url)
  return ['skip', 'not http/https'] unless %w[http https].include?(uri.scheme)

  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: REQUEST_TIMEOUT, read_timeout: REQUEST_TIMEOUT) do |http|
    response = http.head(uri.request_uri.empty? ? '/' : uri.request_uri)
    return [response.code, response.message]
  end
rescue StandardError => e
  ['error', e.class.to_s]
end

url_results = []
shows.first(MAX_URL_CHECKS).each do |show|
  website = show.fetch('website', '').to_s.strip
  next if website.empty?

  status, detail = check_url(website)
  url_results << [show.fetch('id'), show.fetch('name'), website, status, detail]
  sleep 0.5
end

FileUtils.mkdir_p(File.dirname(REPORT_PATH))
File.write(REPORT_PATH, <<~MD)
  # Coin Shows weekly update report

  Generated: #{now.iso8601}

  This report is review-only. It does not change `_data/shows.yml`, publish pages, send emails, submit forms, or contact customers.

  ## Summary

  - Total listings: #{shows.length}
  - Specific dates eligible for Event schema: #{specific.length}
  - Partial dates needing human/source review: #{partial.length}
  - TBD/missing dates needing human/source review: #{tbd.length}
  - Listings missing organizer/source URL: #{missing_url.length}
  - Organizer/source URLs checked this run: #{url_results.length}

  ## Partial dates to review

  #{partial.map { |show| "- #{show.fetch('id')}: #{show.fetch('name')} — #{show.fetch('next_date')}" }.join("\n")}

  ## TBD or missing dates to review

  #{tbd.map { |show| "- #{show.fetch('id')}: #{show.fetch('name')}" }.join("\n")}

  ## Missing organizer/source URLs

  #{missing_url.map { |show| "- #{show.fetch('id')}: #{show.fetch('name')}" }.join("\n")}

  ## URL check sample

  | Listing | Status | Detail | URL |
  |---|---:|---|---|
  #{url_results.map { |id, _name, url, status, detail| "| `#{id}` | #{status} | #{detail} | #{url} |" }.join("\n")}
MD

puts "Wrote #{REPORT_PATH}"
puts "Review-only summary: total=#{shows.length} specific=#{specific.length} partial=#{partial.length} tbd=#{tbd.length} missing_url=#{missing_url.length}"
