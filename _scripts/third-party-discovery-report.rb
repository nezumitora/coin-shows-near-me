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
  return { status: 'error', detail: 'too many redirects', body: '', final_url: url, redirects: [] } if limit <= 0

  uri = URI.parse(url)
  return { status: 'skip', detail: 'not http/https', body: '', final_url: url, redirects: [] } unless %w[http https].include?(uri.scheme)

  response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: REQUEST_TIMEOUT, read_timeout: REQUEST_TIMEOUT) do |http|
    request = Net::HTTP::Get.new(uri)
    request['User-Agent'] = 'CoinShowsNearMeBot/0.1 (+https://coinshownearme.com/contact/) report-only third-party discovery'
    http.request(request)
  end

  if response.is_a?(Net::HTTPRedirection) && response['location']
    redirect_url = URI.join(uri, response['location']).to_s
    result = fetch_html(redirect_url, limit - 1)
    result[:redirects].unshift(redirect_url)
    return result
  end

  {
    status: response.code,
    detail: response.message,
    body: response.body.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: ' '),
    final_url: uri.to_s,
    redirects: []
  }
rescue StandardError => e
  { status: 'error', detail: e.class.to_s, body: '', final_url: url, redirects: [] }
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
    next unless href.include?('/Listing/Details/')

    href.sub(%r{(/Listing/Details/\d+).*}, '\1')
  end.compact.uniq.first(40)
end

def source_status(fetch_result, candidate_dates, links)
  final_url = fetch_result.fetch(:final_url).to_s
  final_path = URI.parse(final_url).path.downcase rescue final_url.downcase
  text = normalized(text_from_html(fetch_result.fetch(:body)))
  coinzip_not_found_path = ['', 'home', 'notfound'].join('/')

  return ['not_found', 'Redirected to provider NotFound page'] if final_path.include?(coinzip_not_found_path)
  return ['not_found', 'Redirected to provider 404 page'] if final_path.end_with?('/404.php')
  return ['not_found', 'HTTP 404 from source'] if fetch_result.fetch(:status).to_s == '404'
  return ['fetch_error', fetch_result.fetch(:detail)] if fetch_result.fetch(:status).to_s == 'error'
  return ['skip', fetch_result.fetch(:detail)] if fetch_result.fetch(:status).to_s == 'skip'

  if candidate_dates.empty? && links.empty?
    return ['needs_parser', 'No dates or coin-show links found']
  end

  return ['needs_parser', 'Coin-show text found, but no dates found'] if candidate_dates.empty? && text.include?('coin show')

  ['review_leads', 'Possible dates or links found; manual review needed']
end

sources = YAML.load_file(CONFIG_PATH)
shows = YAML.load_file(SHOWS_PATH)
shows_by_state = shows.group_by { |show| show.fetch('state') }
generated_at = Time.now.utc.iso8601
rows = []
summaries = []

sources.each do |source|
  fetch_result = fetch_html(source.fetch('url'))
  html = fetch_result.fetch(:body)
  text = text_from_html(html)
  source_text = normalized(text)
  local_shows = shows_by_state.fetch(source.fetch('state'), [])
  local_matches = local_shows.select { |show| source_text.include?(normalized(show.fetch('name'))) }
  candidate_dates = date_candidates(text)
  links = candidate_links(html)
  review_status, review_detail = source_status(fetch_result, candidate_dates, links)
  final_url = fetch_result.fetch(:final_url)
  redirect_chain = fetch_result.fetch(:redirects).join(' -> ')

  rows << [
    source.fetch('key'),
    source.fetch('provider'),
    source.fetch('state'),
    source.fetch('url'),
    final_url,
    fetch_result.fetch(:status),
    fetch_result.fetch(:detail),
    review_status,
    review_detail,
    redirect_chain,
    local_shows.length,
    local_matches.length,
    (local_shows.length - local_matches.length),
    candidate_dates.join('; '),
    links.join(' || ')
  ]

  summaries << {
    key: source.fetch('key'),
    provider: source.fetch('provider'),
    state: source.fetch('state'),
    url: source.fetch('url'),
    final_url: final_url,
    fetch_status: fetch_result.fetch(:status),
    fetch_detail: fetch_result.fetch(:detail),
    review_status: review_status,
    review_detail: review_detail,
    redirect_chain: redirect_chain,
    local_count: local_shows.length,
    matched_count: local_matches.length,
    candidate_dates: candidate_dates,
    links: links
  }

  sleep REQUEST_DELAY_SECONDS if REQUEST_DELAY_SECONDS.positive?
end

FileUtils.mkdir_p(File.dirname(REPORT_PATH))

CSV.open(CSV_PATH, 'w') do |csv|
  csv << %w[source_key provider state original_url final_url fetch_status fetch_detail review_status review_detail redirect_chain local_state_show_count local_name_matches local_unmatched_count candidate_dates candidate_links]
  rows.each { |row| csv << row }
end

File.write(REPORT_PATH, <<~MD)
  # Third-party discovery report

  Generated: #{generated_at}

  Report-only. Third-party directories are leads, not source-of-truth. Confirm against official organizer/club sources before updating `_data/shows.yml`.

  ## Sources checked

  | Source | State | Review status | Fetch | Local shows | Local name matches | Original URL | Final URL |
  |---|---:|---|---|---:|---:|---|---|
  #{summaries.map { |source| "| #{source[:provider]} | #{source[:state]} | #{source[:review_status]} — #{source[:review_detail]} | #{source[:fetch_status]} #{source[:fetch_detail]} | #{source[:local_count]} | #{source[:matched_count]} | #{source[:url]} | #{source[:final_url]} |" }.join("\n")}

  ## What Milo should check

  #{summaries.map { |source| "- **#{source[:provider]} #{source[:state]}**: #{source[:review_status]} — #{source[:review_detail]}. Action: #{source[:review_status] == 'not_found' ? 'find a current working source URL before checking shows' : 'review only if dates or specific show links appear'}.#{source[:redirect_chain].empty? ? '' : " Redirected through: #{source[:redirect_chain]}."}" }.join("\n")}

  ## Candidate dates seen

  #{summaries.map { |source| "### #{source[:provider]} #{source[:state]}\n#{source[:candidate_dates].map { |date| "- #{date}" }.join("\n")}" }.join("\n\n")}

  ## Candidate coin-show links seen

  #{summaries.map { |source| "### #{source[:provider]} #{source[:state]}\n#{source[:links].map { |href| "- Lead detail URL: #{href}" }.join("\n")}" }.join("\n\n")}

  ## Next actions

  - Fix or replace sources marked `not_found` before reviewing show leads.
  - Treat unmatched names and new links as leads only.
  - Confirm date/venue on official organizer or club pages before editing.
  - Promote reliable third-party pages into source-specific parsers only after report quality is reviewed.
MD

puts "Wrote #{REPORT_PATH}"
puts "Wrote #{CSV_PATH}"
puts "Report-only third-party sources=#{sources.length}"
