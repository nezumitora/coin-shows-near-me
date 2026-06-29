#!/usr/bin/env ruby
# Discover possible missing/different shows from approved third-party pages.
# Report-only: does not edit data, publish pages, email, text, or submit forms.

require 'csv'
require 'fileutils'
require 'net/http'
require 'time'
require 'uri'
require 'yaml'

CONFIG_PATH = '_scrapers/third-party-discovery.yml'
SHOWS_PATH = '_data/shows.yml'
REPORT_PATH = 'tmp/third-party-discovery-report.md'
CSV_PATH = 'tmp/third-party-discovery-report.csv'
REQUEST_TIMEOUT = 12
REQUEST_DELAY_SECONDS = Float(ENV.fetch('REQUEST_DELAY_SECONDS', '1.0'))

DATE_PATTERNS = [
  /\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Sept|Oct|Nov|Dec)[a-z.]*\s+\d{1,2}(?:\s*[-–]\s*\d{1,2})?,?\s+\d{4}\b/i,
  /\b\d{1,2}\/\d{1,2}\/\d{2,4}\b/,
  /\b\d{4}-\d{2}-\d{2}\b/
].freeze

def normalized(value)
  value.to_s.downcase.gsub(/[^a-z0-9]+/, ' ').strip
end

def fetch_html(url, limit = 4)
  return ['error', 'too many redirects', ''] if limit <= 0

  uri = URI.parse(url)
  return ['skip', 'not http/https', ''] unless %w[http https].include?(uri.scheme)

  response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: REQUEST_TIMEOUT, read_timeout: REQUEST_TIMEOUT) do |http|
    request = Net::HTTP::Get.new(uri)
    request['User-Agent'] = 'CoinShowsNearMeBot/0.1 (+https://coinshownearme.com/contact/) report-only third-party discovery'
    http.request(request)
  end

  if response.is_a?(Net::HTTPRedirection) && response['location']
    redirect_url = URI.join(uri, response['location']).to_s
    return fetch_html(redirect_url, limit - 1)
  end

  [response.code, response.message, response.body.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: ' ')]
rescue StandardError => e
  ['error', e.class.to_s, '']
end

def text_from_html(html)
  html.gsub(/<script\b[^>]*>.*?<\/script>/mi, ' ')
      .gsub(/<style\b[^>]*>.*?<\/style>/mi, ' ')
      .gsub(/<[^>]+>/, ' ')
      .gsub(/&nbsp;|&#160;/, ' ')
      .gsub(/&amp;/, '&')
      .gsub(/\s+/, ' ')
      .strip
end

def date_candidates(text)
  DATE_PATTERNS.flat_map { |pattern| text.scan(pattern) }.map { |date| date.is_a?(Array) ? date.first : date }.uniq.first(40)
end

def candidate_links(html)
  html.scan(/<a\b[^>]*href=["']([^"']+)["'][^>]*>(.*?)<\/a>/mi).map do |href, label_html|
    label = text_from_html(label_html)
    next if label.length < 8
    next unless normalized(label).include?('coin') || normalized(href).include?('coin')

    [label, href]
  end.compact.uniq.first(40)
end

sources = YAML.load_file(CONFIG_PATH)
shows = YAML.load_file(SHOWS_PATH)
shows_by_state = shows.group_by { |show| show.fetch('state') }
generated_at = Time.now.utc.iso8601
rows = []
summaries = []

sources.each do |source|
  status, detail, html = fetch_html(source.fetch('url'))
  text = text_from_html(html)
  source_text = normalized(text)
  local_shows = shows_by_state.fetch(source.fetch('state'), [])
  local_matches = local_shows.select { |show| source_text.include?(normalized(show.fetch('name'))) }
  candidate_dates = date_candidates(text)
  links = candidate_links(html)

  rows << [
    source.fetch('key'),
    source.fetch('provider'),
    source.fetch('state'),
    source.fetch('url'),
    status,
    detail,
    local_shows.length,
    local_matches.length,
    (local_shows.length - local_matches.length),
    candidate_dates.join('; '),
    links.map { |label, href| "#{label} => #{href}" }.join(' || ')
  ]

  summaries << {
    key: source.fetch('key'),
    provider: source.fetch('provider'),
    state: source.fetch('state'),
    url: source.fetch('url'),
    status: status,
    detail: detail,
    local_count: local_shows.length,
    matched_count: local_matches.length,
    candidate_dates: candidate_dates,
    links: links
  }

  sleep REQUEST_DELAY_SECONDS if REQUEST_DELAY_SECONDS.positive?
end

FileUtils.mkdir_p(File.dirname(REPORT_PATH))

CSV.open(CSV_PATH, 'w') do |csv|
  csv << %w[source_key provider state url fetch_status fetch_detail local_state_show_count local_name_matches local_unmatched_count candidate_dates candidate_links]
  rows.each { |row| csv << row }
end

File.write(REPORT_PATH, <<~MD)
  # Third-party discovery report

  Generated: #{generated_at}

  Report-only. Third-party directories are leads, not source-of-truth. Confirm against official organizer/club sources before updating `_data/shows.yml`.

  ## Sources checked

  | Source | State | Status | Local shows | Local name matches | URL |
  |---|---:|---:|---:|---:|---|
  #{summaries.map { |source| "| #{source[:provider]} | #{source[:state]} | #{source[:status]} #{source[:detail]} | #{source[:local_count]} | #{source[:matched_count]} | #{source[:url]} |" }.join("\n")}

  ## Candidate dates seen

  #{summaries.map { |source| "### #{source[:provider]} #{source[:state]}\n#{source[:candidate_dates].map { |date| "- #{date}" }.join("\n")}" }.join("\n\n")}

  ## Candidate coin-show links seen

  #{summaries.map { |source| "### #{source[:provider]} #{source[:state]}\n#{source[:links].map { |label, href| "- #{label}: #{href}" }.join("\n")}" }.join("\n\n")}

  ## Next actions

  - Treat unmatched names and new links as leads only.
  - Confirm date/venue on official organizer or club pages before editing.
  - Promote reliable third-party pages into source-specific parsers only after report quality is reviewed.
MD

puts "Wrote #{REPORT_PATH}"
puts "Wrote #{CSV_PATH}"
puts "Report-only third-party sources=#{sources.length}"
