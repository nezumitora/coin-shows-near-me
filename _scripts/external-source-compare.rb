#!/usr/bin/env ruby
# Compare approved external source pages against current show data.
# Report-only: does not edit data, publish pages, email, text, or submit forms.
# Set SOURCE_COMPARISON_DRY_RUN=1 and REQUEST_DELAY_SECONDS=0 to validate
# report generation without making source-page requests.

require 'csv'
require 'cgi'
require 'fileutils'
require 'net/http'
require 'time'
require 'uri'
require 'yaml'
require_relative 'show_source_policy'
require_relative 'source_entry_matcher'

CONFIG_PATH = '_scrapers/external-sources.yml'
SHOWS_PATH = '_data/shows.yml'
REPORT_PATH = 'tmp/external-source-comparison.md'
CSV_PATH = 'tmp/external-source-comparison.csv'
QUEUE_CSV_PATH = 'tmp/external-source-coverage-queue.csv'
REQUEST_TIMEOUT = 12
REQUEST_DELAY_SECONDS = Float(ENV.fetch('REQUEST_DELAY_SECONDS', '1.0'))
DRY_RUN = ENV.fetch('SOURCE_COMPARISON_DRY_RUN', '0') == '1'

DATE_PATTERNS = [
  /\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Sept|Oct|Nov|Dec)[a-z.]*\s+\d{1,2}(?:st|nd|rd|th)?(?:(?:\s*[-–—]\s*|\s+(?:and|to|through)\s+)\d{1,2}(?:st|nd|rd|th)?)?,?\s+\d{4}\b/i,
  /\b\d{1,2}\/\d{1,2}\/\d{2,4}\b/,
  /\b\d{4}-\d{2}-\d{2}\b/
].freeze

def fetch_text(url)
  return ['dry_run', 'network disabled', ''] if DRY_RUN

  uri = URI.parse(url)
  return ['skip', 'not http/https', ''] unless %w[http https].include?(uri.scheme)

  response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: REQUEST_TIMEOUT, read_timeout: REQUEST_TIMEOUT) do |http|
    request = Net::HTTP::Get.new(uri)
    request['User-Agent'] = 'CoinShowsNearMeBot/0.1 (+https://coinshownearme.com/contact/) report-only show accuracy check'
    http.request(request)
  end

  text = response.body.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: ' ')
  2.times { text = CGI.unescapeHTML(text) }
  text = text.gsub(/<script\b[^>]*>.*?<\/script>/mi, ' ')
             .gsub(/<style\b[^>]*>.*?<\/style>/mi, ' ')
             .gsub(/<[^>]+>/, ' ')
             .gsub(/&nbsp;|&#160;/, ' ')
             .gsub(/\s+/, ' ')
             .strip

  [response.code, response.message, text]
rescue StandardError => e
  ['error', e.class.to_s, '']
end

def normalized(value)
  value.to_s.downcase.gsub(/[^a-z0-9]+/, ' ').strip
end

def date_candidates(text)
  DATE_PATTERNS.flat_map { |pattern| text.scan(pattern) }.map { |date| date.is_a?(Array) ? date.first : date }.uniq.first(25)
end

sources = YAML.load_file(CONFIG_PATH)
shows = YAML.load_file(SHOWS_PATH)
shows_by_id = shows.to_h { |show| [show.fetch('id'), show] }
configured_show_ids = sources.flat_map { |source| source.fetch('expected_show_ids') }.uniq
approved_source_rows = shows.each_with_object([]) do |show, rows_for_sources|
  source_url = ShowSourcePolicy.source_url_for(show)
  next if source_url.empty?

  rows_for_sources << {
    show_id: show.fetch('id'),
    show_name: show.fetch('name'),
    source_url: source_url
  }
end
approved_source_show_ids = approved_source_rows.map { |row| row.fetch(:show_id) }.uniq
approved_but_unconfigured_rows = approved_source_rows.reject do |row|
  configured_show_ids.include?(row.fetch(:show_id))
end
approved_but_unconfigured_ids = approved_but_unconfigured_rows.map { |row| row.fetch(:show_id) }.uniq
coverage_queue_by_url = approved_but_unconfigured_rows.group_by { |row| row.fetch(:source_url) }
uncovered_show_ids = shows_by_id.keys - approved_source_show_ids
generated_at = Time.now.utc.iso8601
rows = []
source_summaries = []

sources.each do |source|
  status, detail, text = fetch_text(source.fetch('url'))
  fetched_at = Time.now.utc.iso8601
  candidates = date_candidates(text)
  source_text = normalized(text)
  missing_configured_ids = []
  peer_names = source.fetch('expected_show_ids').map { |show_id| shows_by_id[show_id]&.fetch('name') }.compact

  source.fetch('expected_show_ids').each do |show_id|
    show = shows_by_id[show_id]
    unless show
      missing_configured_ids << show_id
      rows << [source.fetch('key'), source.fetch('source_type'), source.fetch('url'), fetched_at, show_id, '', '', status, detail, 'missing_local_listing', false, false, candidates.join('; ')]
      next
    end

    show_name = show.fetch('name')
    show_date = show.fetch('next_date', '').to_s
    name_found = source_text.include?(normalized(show_name))
    date_found = SourceEntryMatcher.date_associated?(text, show_name, peer_names, show_date, source['calendar_year'])
    review_status = if status == 'dry_run'
                      'not_fetched_dry_run'
                    elsif status == 'error'
                      'source_fetch_error'
                    elsif name_found && (show_date == 'TBD' || date_found)
                      'matches_or_needs_date_review'
                    elsif name_found
                      'date_diff_or_partial_match'
                    else
                      'show_name_not_found'
                    end

    rows << [source.fetch('key'), source.fetch('source_type'), source.fetch('url'), fetched_at, show_id, show_name, show_date, status, detail, review_status, name_found, date_found, candidates.join('; ')]
  end

  source_summaries << {
    key: source.fetch('key'),
    name: source.fetch('name'),
    url: source.fetch('url'),
    status: status,
    detail: detail,
    expected_count: source.fetch('expected_show_ids').length,
    missing_configured_ids: missing_configured_ids,
    candidate_dates: candidates
  }

  sleep REQUEST_DELAY_SECONDS if REQUEST_DELAY_SECONDS.positive?
end

FileUtils.mkdir_p(File.dirname(REPORT_PATH))

CSV.open(CSV_PATH, 'w') do |csv|
  csv << %w[source_key source_type source_url fetched_at show_id show_name current_next_date fetch_status fetch_detail review_status name_found current_date_found candidate_dates]
  rows.each { |row| csv << row }
end

CSV.open(QUEUE_CSV_PATH, 'w') do |csv|
  csv << %w[source_url show_ids show_names]
  coverage_queue_by_url.sort.each do |source_url, source_rows|
    csv << [
      source_url,
      source_rows.map { |row| row.fetch(:show_id) }.sort.join(';'),
      source_rows.map { |row| row.fetch(:show_name) }.sort.join(';')
    ]
  end
end

File.write(REPORT_PATH, <<~MD)
  # External source comparison report

  Generated: #{generated_at}

  Report-only. This does not change `_data/shows.yml`, publish pages, submit forms, send emails, or send SMS.

  ## Coverage

  - Canonical listings: #{shows.length}
  - Listings in the explicit comparison registry: #{configured_show_ids.length}
  - Listings with an approved canonical source: #{approved_source_show_ids.length}
  - Approved-source listings waiting for a reviewed comparison batch: #{approved_but_unconfigured_ids.length}
  - Listings without an approved comparison source: #{uncovered_show_ids.length}
  - Explicit source-registry groups fetched: #{sources.length}
  - Approved source URLs queued without fetching: #{coverage_queue_by_url.length}

  Only the hand-reviewed source registry is fetched. Existing canonical `source_url` or `website` values accepted by `ShowSourcePolicy` are written to `#{QUEUE_CSV_PATH}` for small-batch review; they are not fetched automatically and do not create or verify listings.

  #{uncovered_show_ids.empty? ? '' : "Uncovered listing IDs: `#{uncovered_show_ids.sort.join('`, `')}`"}

  ## Sources checked

  | Source | Status | Listings checked | URL |
  |---|---:|---:|---|
  #{source_summaries.map { |source| "| #{source[:name]} | #{source[:status]} #{source[:detail]} | #{source[:expected_count]} | #{source[:url]} |" }.join("\n")}

  ## Review rows

  | Source | Show | Current date | Status | Name found | Current date found | Candidate dates on source |
  |---|---|---|---|---:|---:|---|
  #{rows.map { |source_key, _source_type, _source_url, _fetched_at, show_id, show_name, show_date, _fetch_status, _fetch_detail, review_status, name_found, date_found, candidates| "| #{source_key} | #{show_name.empty? ? show_id : show_name} | #{show_date} | #{review_status} | #{name_found} | #{date_found} | #{candidates} |" }.join("\n")}

  ## Next human-review actions

  - For `date_diff_or_partial_match`, open the source page and compare dates before editing.
  - For `show_name_not_found`, check whether the source page changed wording, removed the show, or blocks bot access.
  - Review `#{QUEUE_CSV_PATH}` and promote only a small, source-tested batch into `_scrapers/external-sources.yml` at a time.
  - For useful source pages that list multiple events, add source-specific parsing only after this report proves reliable.
MD

puts "Wrote #{REPORT_PATH}"
puts "Wrote #{CSV_PATH}"
puts "Wrote #{QUEUE_CSV_PATH}"
puts "Report-only comparison rows=#{rows.length} sources=#{sources.length}"
