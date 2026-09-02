#!/usr/bin/env ruby
# Compare approved external source pages against current show data.
# Report-only: does not edit data, publish pages, email, text, or submit forms.
# Phase 2 profile network access is disabled unless
# SOURCE_COMPARISON_ALLOW_NETWORK=1. Set SOURCE_COMPARISON_DRY_RUN=1 and
# REQUEST_DELAY_SECONDS=0 to force any mode to avoid source-page requests.

require 'csv'
require 'cgi'
require 'date'
require 'net/http'
require 'time'
require 'uri'
require 'yaml'
require_relative 'listing_freshness'
require_relative 'show_source_policy'
require_relative 'source_entry_matcher'
require_relative 'listing_freshness_profile'

REPO_ROOT = File.expand_path('..', __dir__)
CONFIG_PATH = '_scrapers/external-sources.yml'
SHOWS_PATH = '_data/shows.yml'
PROFILE_PATH = ENV.fetch('LISTING_FRESHNESS_PROFILE_PATH', '').strip
OUTPUT_PATHS = begin
  ListingFreshness.secure_output_paths(
    [
      'tmp/external-source-comparison.md',
      'tmp/external-source-comparison.csv',
      'tmp/external-source-coverage-queue.csv'
    ],
    repo_root: REPO_ROOT,
    forbidden_paths: [CONFIG_PATH, SHOWS_PATH, PROFILE_PATH]
  )
rescue ArgumentError => e
  abort e.message
end.freeze
REPORT_PATH, CSV_PATH, QUEUE_CSV_PATH = OUTPUT_PATHS
REQUEST_TIMEOUT = 12
REQUEST_DELAY_SECONDS = begin
  delay = Float(ENV.fetch('REQUEST_DELAY_SECONDS', '1.0'))
  abort 'REQUEST_DELAY_SECONDS must be a finite non-negative number' unless delay.finite? && delay >= 0

  delay
rescue ArgumentError
  abort 'REQUEST_DELAY_SECONDS must be a finite non-negative number'
end
PROFILE_NETWORK_ALLOWED = ENV.fetch('SOURCE_COMPARISON_ALLOW_NETWORK', '0') == '1'
DRY_RUN = ENV.fetch('SOURCE_COMPARISON_DRY_RUN', '0') == '1' ||
          (!PROFILE_PATH.empty? && !PROFILE_NETWORK_ALLOWED)
COMPARISON_AS_OF = begin
  Date.iso8601(ENV.fetch('LISTING_FRESHNESS_AS_OF', Time.now.utc.to_date.iso8601))
rescue ArgumentError
  abort 'LISTING_FRESHNESS_AS_OF must be an ISO date'
end
CANDIDATE_YEAR_RANGE = ((COMPARISON_AS_OF.year - 1)..(COMPARISON_AS_OF.year + 5))
MAX_RESPONSE_BYTES = 2 * 1024 * 1024
ResponseTooLargeError = Class.new(StandardError)

DATE_PATTERNS = [
  /\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Sept|Oct|Nov|Dec)[a-z.]*\s+\d{1,2}(?:st|nd|rd|th)?(?:(?:\s*[-–—]\s*|\s+(?:and|to|through)\s+)\d{1,2}(?:st|nd|rd|th)?)?,?\s+\d{4}\b/i,
  /\b\d{1,2}\/\d{1,2}\/\d{2,4}\b/,
  /\b\d{4}-\d{2}-\d{2}\b/
].freeze
SOURCE_ROW_HEADERS = %w[
  source_key source_type source_url request_url fetched_at show_id show_name current_next_date
  fetch_status fetch_detail redirect_target review_status name_found current_date_found match_basis
  candidate_dates cancellation_evidence
].freeze

def bounded_response_body(response)
  body = String.new
  response.read_body do |chunk|
    if body.bytesize + chunk.bytesize > MAX_RESPONSE_BYTES
      raise ResponseTooLargeError, "response exceeded #{MAX_RESPONSE_BYTES} bytes"
    end

    body << chunk
  end
  body
end

def fetch_text(url)
  return ['dry_run', 'network disabled', '', ''] if DRY_RUN

  uri = URI.parse(url)
  return ['skip', 'not http/https', '', ''] unless %w[http https].include?(uri.scheme)

  response = nil
  body = nil
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: REQUEST_TIMEOUT, read_timeout: REQUEST_TIMEOUT) do |http|
    request = Net::HTTP::Get.new(uri)
    request['User-Agent'] = 'CoinShowsNearMeBot/0.1 (+https://coinshownearme.com/contact/) report-only show accuracy check'
    http.request(request) do |http_response|
      response = http_response
      body = bounded_response_body(http_response)
    end
  end

  text = body.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: ' ')
  4.times do
    decoded_text = CGI.unescapeHTML(text)
    break if decoded_text == text

    text = decoded_text
  end
  text = text.gsub(/<script\b[^>]*>.*?<\/script>/mi, ' ')
             .gsub(/<style\b[^>]*>.*?<\/style>/mi, ' ')
             .gsub(/<[^>]+>/, ' ')
             .gsub(/&nbsp;|&#160;/, ' ')
             .gsub(/&(?:ndash|mdash);/i, ' ')
             .gsub(/\s+/, ' ')
             .strip

  redirect_target = response['location'].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
  redirect_target = redirect_target.gsub(/[\r\n]/, '').strip[0, 500]

  [response.code, response.message, text, redirect_target]
rescue ResponseTooLargeError => e
  ['error', e.message, '', '']
rescue StandardError => e
  ['error', e.class.to_s, '', '']
end

def normalized(value)
  value.to_s.downcase.gsub(/[^a-z0-9]+/, ' ').strip
end

def date_candidates(text)
  DATE_PATTERNS.flat_map { |pattern| text.scan(pattern) }
               .map { |date| date.is_a?(Array) ? date.first : date }
               .uniq
               .select do |date|
                 SourceDateMatcher.year_within?(
                   date,
                   min_year: CANDIDATE_YEAR_RANGE.begin,
                   max_year: CANDIDATE_YEAR_RANGE.end
                 )
               end
               .first(25)
end

all_sources = YAML.load_file(CONFIG_PATH)
profile = if PROFILE_PATH.empty?
            nil
          else
            ListingFreshnessProfile.load(path: PROFILE_PATH, external_sources: all_sources)
          end
resolved_sources = if profile
                     profile.fetch(:sources)
                   else
                     all_sources.map { |source| { registry: source, profile: nil } }
                   end
sources = resolved_sources.map { |source| source.fetch(:registry) }
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

if profile
  constraints = profile.fetch(:config).fetch('policies').fetch('constraints')
  minimum_delay = profile.fetch(:sources).map do |source|
    policy_name = source.fetch(:profile).fetch('constraints_policy')
    constraints.fetch(policy_name).fetch('request_delay_seconds')
  end.max
  if !DRY_RUN && REQUEST_DELAY_SECONDS < minimum_delay
    abort "REQUEST_DELAY_SECONDS must be at least #{minimum_delay} for the selected Phase 2 profile"
  end
end

resolved_sources.each do |resolved_source|
  source = resolved_source.fetch(:registry)
  source_profile = resolved_source[:profile]
  unless ShowSourcePolicy.approved_source_url?(source.fetch('url'))
    abort "Comparison source is not approved: #{source.fetch('key')}"
  end

  request_groups = source.fetch('expected_show_ids').group_by do |show_id|
    if source_profile
      ListingFreshnessProfile.request_url_for(source: resolved_source, show_id: show_id)
    else
      source.fetch('url')
    end
  end

  request_groups.each do |request_url, show_ids|
    unless ShowSourcePolicy.approved_source_url?(request_url)
      abort "Comparison request URL is not approved: #{source.fetch('key')}"
    end

    status, detail, text, redirect_target = fetch_text(request_url)
    fetched_at = Time.now.utc.iso8601
    candidates = date_candidates(text)
    missing_configured_ids = []
    peer_shows = show_ids.map { |show_id| shows_by_id[show_id] }.compact
    peer_names = peer_shows.map { |show| show.fetch('name') }
    peer_aliases = peer_shows.to_h do |peer_show|
      aliases = if source_profile
                  ListingFreshnessProfile.aliases_for(source: resolved_source, show_id: peer_show.fetch('id'))
                else
                  []
                end
      [peer_show.fetch('name'), aliases]
    end

    show_ids.each do |show_id|
      show = shows_by_id[show_id]
      unless show
        missing_configured_ids << show_id
        rows << {
          'source_key' => source.fetch('key'),
          'source_type' => source.fetch('source_type'),
          'source_url' => source.fetch('url'),
          'request_url' => request_url,
          'fetched_at' => fetched_at,
          'show_id' => show_id,
          'show_name' => '',
          'current_next_date' => '',
          'fetch_status' => status,
          'fetch_detail' => detail,
          'redirect_target' => redirect_target,
          'review_status' => 'missing_local_listing',
          'name_found' => false,
          'current_date_found' => false,
          'match_basis' => '',
          'candidate_dates' => candidates.join('; '),
          'cancellation_evidence' => false
        }
        next
      end

      show_name = show.fetch('name')
      show_date = show.fetch('next_date', '').to_s
      listing_rule = source_profile ? ListingFreshnessProfile.listing_rule(source: resolved_source, show_id: show_id) : {}
      aliases = Array(listing_rule['aliases'])
      calendar_year = listing_rule.fetch('calendar_year', source['calendar_year'])
      name_found = SourceEntryMatcher.name_found?(text, [show_name] + aliases)
      exact_date_found = SourceEntryMatcher.date_associated?(
        text,
        show_name,
        peer_names,
        show_date,
        calendar_year,
        target_aliases: aliases,
        peer_aliases: peer_aliases,
        max_name_date_distance: listing_rule.fetch('max_name_date_distance', SourceEntryMatcher::MAX_NAME_DATE_DISTANCE)
      )
      if !exact_date_found && listing_rule['exact_date_anywhere_on_page'] && name_found
        exact_date_found = SourceDateMatcher.found?(text, show_date, calendar_year)
      end
      recurring_rule_found = if listing_rule['recurring_rule']
                               name_found && SourceEntryMatcher.current_date_matches_nth_weekday_rule?(
                                 text,
                                 show_date,
                                 listing_rule.fetch('recurring_rule')
                               )
                             else
                               false
                             end
      date_found = exact_date_found || recurring_rule_found
      match_basis = if exact_date_found
                      'exact_date'
                    elsif recurring_rule_found
                      'explicit_recurring_rule'
                    else
                      ''
                    end
      review_status = if status == 'dry_run'
                        'not_fetched_dry_run'
                      elsif !status.match?(/\A2\d\d\z/)
                        'source_availability_review'
                      elsif name_found && (show_date == 'TBD' || date_found)
                        'matches_or_needs_date_review'
                      elsif name_found
                        'date_diff_or_partial_match'
                      else
                        'show_name_not_found'
                      end

      rows << {
        'source_key' => source.fetch('key'),
        'source_type' => source.fetch('source_type'),
        'source_url' => source.fetch('url'),
        'request_url' => request_url,
        'fetched_at' => fetched_at,
        'show_id' => show_id,
        'show_name' => show_name,
        'current_next_date' => show_date,
        'fetch_status' => status,
        'fetch_detail' => detail,
        'redirect_target' => redirect_target,
        'review_status' => review_status,
        'name_found' => name_found,
        'current_date_found' => date_found,
        'match_basis' => match_basis,
        'candidate_dates' => candidates.join('; '),
        'cancellation_evidence' => false
      }
    end

    source_summaries << {
      key: source.fetch('key'),
      name: source.fetch('name'),
      url: source.fetch('url'),
      request_url: request_url,
      status: status,
      detail: detail,
      redirect_target: redirect_target,
      expected_count: show_ids.length,
      missing_configured_ids: missing_configured_ids,
      candidate_dates: candidates
    }

    sleep REQUEST_DELAY_SECONDS if !DRY_RUN && REQUEST_DELAY_SECONDS.positive?
  end
end

ListingFreshness.write_secure_output(CSV_PATH, repo_root: REPO_ROOT) do |file|
  csv = CSV.new(file)
  csv << SOURCE_ROW_HEADERS
  rows.each do |row|
    csv << SOURCE_ROW_HEADERS.map { |header| ListingFreshness.safe_csv_cell(row.fetch(header)) }
  end
  csv.flush
end

ListingFreshness.write_secure_output(QUEUE_CSV_PATH, repo_root: REPO_ROOT) do |file|
  csv = CSV.new(file)
  csv << %w[source_url show_ids show_names]
  coverage_queue_by_url.sort.each do |source_url, source_rows|
    values = [
      source_url,
      source_rows.map { |row| row.fetch(:show_id) }.sort.join(';'),
      source_rows.map { |row| row.fetch(:show_name) }.sort.join(';')
    ]
    csv << values.map { |value| ListingFreshness.safe_csv_cell(value) }
  end
  csv.flush
end

report = <<~MD
  # External source comparison report

  Generated: #{generated_at}
  Source profile: #{PROFILE_PATH.empty? ? 'full approved comparison registry' : "`#{File.basename(PROFILE_PATH)}`"}

  Report-only. This does not change `_data/shows.yml`, publish pages, submit forms, send emails, or send SMS.

  ## Coverage

  - Canonical listings: #{shows.length}
  - Listings in the explicit comparison registry: #{configured_show_ids.length}
  - Listings with an approved canonical source: #{approved_source_show_ids.length}
  - Approved-source listings waiting for a reviewed comparison batch: #{approved_but_unconfigured_ids.length}
  - Listings without an approved comparison source: #{uncovered_show_ids.length}
  - Explicit source-registry groups selected: #{sources.length}
  - Exact official source paths selected: #{source_summaries.length}
  - Source requests made: #{DRY_RUN ? 0 : source_summaries.length}
  - Maximum requests made per selected source/path: #{DRY_RUN ? 0 : 1}
  - Redirects followed: 0
  - Approved source URLs queued without fetching: #{coverage_queue_by_url.length}

  Only the hand-reviewed source registry and exact same-host request paths approved in the Phase 2 profile are fetched. Existing canonical `source_url` or `website` values accepted by `ShowSourcePolicy` are written to `tmp/#{File.basename(QUEUE_CSV_PATH)}` for small-batch review; they are not fetched automatically and do not create or verify listings.

  #{uncovered_show_ids.empty? ? '' : "Uncovered listing IDs: `#{uncovered_show_ids.sort.join('`, `')}`"}

  ## Sources checked

  | Source | Status | Redirect recorded | Listings checked | Registry URL | Requested URL |
  |---|---:|---|---:|---|---|
  #{source_summaries.map { |source| "| #{source[:name]} | #{source[:status]} #{source[:detail]} | #{source[:redirect_target]} | #{source[:expected_count]} | #{source[:url]} | #{source[:request_url]} |" }.join("\n")}

  ## Review rows

  | Source | Show | Current date | Status | Name found | Current date found | Match basis | Candidate dates on source |
  |---|---|---|---|---:|---:|---|---|
  #{rows.map { |row| "| #{row.fetch('source_key')} | #{row.fetch('show_name').empty? ? row.fetch('show_id') : row.fetch('show_name')} | #{row.fetch('current_next_date')} | #{row.fetch('review_status')} | #{row.fetch('name_found')} | #{row.fetch('current_date_found')} | #{row.fetch('match_basis')} | #{row.fetch('candidate_dates')} |" }.join("\n")}

  ## Next human-review actions

  - For `date_diff_or_partial_match`, open the source page and compare dates before editing.
  - For `show_name_not_found`, check whether the source page changed wording, removed the show, or blocks bot access.
  - Review `tmp/#{File.basename(QUEUE_CSV_PATH)}` and promote only a small, source-tested batch into `_scrapers/external-sources.yml` at a time.
  - For useful source pages that list multiple events, add source-specific parsing only after this report proves reliable.
MD
ListingFreshness.write_secure_output(REPORT_PATH, repo_root: REPO_ROOT) { |file| file.write(report) }

puts "Wrote tmp/#{File.basename(REPORT_PATH)}"
puts "Wrote tmp/#{File.basename(CSV_PATH)}"
puts "Wrote tmp/#{File.basename(QUEUE_CSV_PATH)}"
puts "Report-only comparison rows=#{rows.length} sources=#{sources.length} source_paths=#{source_summaries.length}"
