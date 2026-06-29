#!/usr/bin/env ruby
# Generate a review-only freshness report for Coin Shows listings.
# Run from repo root: ruby _scripts/show-update-report.rb

require 'date'
require 'csv'
require 'fileutils'
require 'net/http'
require 'time'
require 'uri'
require 'yaml'

REPORT_PATH = 'tmp/show-update-report.md'
SOURCE_INVENTORY_PATH = 'tmp/show-source-inventory.csv'
URL_CHECK_PATH = 'tmp/show-url-checks.csv'
REQUEST_TIMEOUT = 8
MAX_URL_CHECKS = Integer(ENV.fetch('MAX_URL_CHECKS', '0'))
REQUEST_DELAY_SECONDS = Float(ENV.fetch('REQUEST_DELAY_SECONDS', '0.5'))

shows = YAML.load_file('_data/shows.yml')
now = Time.now.utc

specific = []
partial = []
tbd = []
missing_url = []
source_domains = Hash.new(0)
source_inventory = []

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
  if website.empty?
    missing_url << show
  else
    begin
      domain = URI.parse(website).host.to_s.downcase.sub(/^www\./, '')
    rescue URI::InvalidURIError
      domain = 'invalid-url'
    end
    source_domains[domain] += 1
    source_inventory << [show.fetch('id'), show.fetch('name'), show.fetch('city'), show.fetch('state'), show.fetch('next_date'), domain, website]
  end
end

def check_url(url)
  uri = URI.parse(url)
  return ['skip', 'not http/https'] unless %w[http https].include?(uri.scheme)

  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: REQUEST_TIMEOUT, read_timeout: REQUEST_TIMEOUT) do |http|
    response = http.head(uri.request_uri.empty? ? '/' : uri.request_uri)
    if %w[405 403].include?(response.code)
      response = http.get(uri.request_uri.empty? ? '/' : uri.request_uri)
    end
    return [response.code, response.message]
  end
rescue StandardError => e
  ['error', e.class.to_s]
end

url_results = []
source_shows = shows.reject { |show| show.fetch('website', '').to_s.strip.empty? }
source_shows = source_shows.first(MAX_URL_CHECKS) if MAX_URL_CHECKS.positive?
source_shows.each do |show|
  website = show.fetch('website', '').to_s.strip

  status, detail = check_url(website)
  url_results << [show.fetch('id'), show.fetch('name'), website, status, detail]
  sleep REQUEST_DELAY_SECONDS if REQUEST_DELAY_SECONDS.positive?
end

FileUtils.mkdir_p(File.dirname(REPORT_PATH))

CSV.open(SOURCE_INVENTORY_PATH, 'w') do |csv|
  csv << %w[id name city state next_date source_domain source_url]
  source_inventory.each { |row| csv << row }
end

CSV.open(URL_CHECK_PATH, 'w') do |csv|
  csv << %w[id name source_url status detail]
  url_results.each { |row| csv << row }
end

File.write(REPORT_PATH, <<~MD)
  # Coin Shows update report

  Generated: #{now.iso8601}

  This report is review-only. It does not change `_data/shows.yml`, publish pages, send emails, submit forms, or contact customers.

  ## Summary

  - Total listings: #{shows.length}
  - Specific dates eligible for Event schema: #{specific.length}
  - Partial dates needing human/source review: #{partial.length}
  - TBD/missing dates needing human/source review: #{tbd.length}
  - Listings missing organizer/source URL: #{missing_url.length}
  - Organizer/source URLs currently in `_data/shows.yml`: #{source_inventory.length}
  - Organizer/source URLs checked this run: #{url_results.length}
  - Source inventory CSV: `#{SOURCE_INVENTORY_PATH}`
  - URL check CSV: `#{URL_CHECK_PATH}`

  ## Current source domains

  These are the exact source domains currently stored in `_data/shows.yml`; this workflow does not use unapproved third-party directories yet.

  | Domain | Listings |
  |---|---:|
  #{source_domains.sort_by { |domain, count| [-count, domain] }.map { |domain, count| "| #{domain} | #{count} |" }.join("\n")}

  ## Partial dates to review

  #{partial.map { |show| "- #{show.fetch('id')}: #{show.fetch('name')} — #{show.fetch('next_date')}" }.join("\n")}

  ## TBD or missing dates to review

  #{tbd.map { |show| "- #{show.fetch('id')}: #{show.fetch('name')}" }.join("\n")}

  ## Missing organizer/source URLs

  #{missing_url.map { |show| "- #{show.fetch('id')}: #{show.fetch('name')}" }.join("\n")}

  ## URL checks

  | Listing | Status | Detail | URL |
  |---|---:|---|---|
  #{url_results.map { |id, _name, url, status, detail| "| `#{id}` | #{status} | #{detail} | #{url} |" }.join("\n")}
MD

puts "Wrote #{REPORT_PATH}"
puts "Wrote #{SOURCE_INVENTORY_PATH}"
puts "Wrote #{URL_CHECK_PATH}"
puts "Review-only summary: total=#{shows.length} specific=#{specific.length} partial=#{partial.length} tbd=#{tbd.length} missing_url=#{missing_url.length} source_urls=#{source_inventory.length} checked=#{url_results.length}"
