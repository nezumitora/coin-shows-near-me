#!/usr/bin/env ruby
# Report-only data-trust audit for Coin Shows listings.
#
# Run from repo root:
#   ruby _scripts/show-data-trust-audit.rb
#   ruby _scripts/show-data-trust-audit.rb --as-of 2026-07-29
#
# Reports are written outside the repo by default:
#   ${AIDEVOPS_TEMP_DIR:-~/.aidevops/.agent-workspace/tmp}/coin-shows-near-me/show-data-trust-audit/
#
# This script must not edit _data/shows.yml, generated pages, templates, schema,
# sitemap, or indexing settings. Data findings are advisory and do not fail CI;
# script/runtime errors should fail.

require 'csv'
require 'date'
require 'fileutils'
require 'optparse'
require 'set'
require 'time'
require 'uri'
require 'yaml'

module ShowDataTrustAudit
  MONTH_PATTERN = /(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:t|tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)/i.freeze
  DATED_TITLE_PATTERN = /\b(20\d{2}|Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Sept|Oct|Nov|Dec|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b/i.freeze
  ADDRESS_IN_CITY_PATTERN = /\d{2,}|\b(Hotel|Ave|Avenue|Street|St\.?|Road|Rd\.?|Drive|Dr\.?|Center|Centre|Hall)\b/i.freeze
  THIRD_PARTY_DOMAINS = %w[coinzip.com coinshows-usa.com numismaticnews.net coinworld.com eventbrite.com].freeze
  STOP_WORDS = %w[the and of annual monthly coin show coins currency collectibles collectible club stamp stamps money meets each month please note first second third fourth].to_set.freeze

  Issue = Struct.new(:listing_id, :issue_type, :reason, :current_value, :evidence_source_state, :confidence, :recommended_next_action, keyword_init: true)
  DuplicateCandidate = Struct.new(:classification, :listing_ids, :reason, :confidence, keyword_init: true)

  module_function

  def default_output_dir
    base = ENV.fetch('AIDEVOPS_TEMP_DIR', File.expand_path('~/.aidevops/.agent-workspace/tmp'))
    File.join(base, 'coin-shows-near-me', 'show-data-trust-audit')
  end

  def normalize_ordinal_date(value)
    value.to_s.strip.gsub(/(\d+)(st|nd|rd|th)\b/i, '\\1')
  end

  def date_text_classification(value)
    text = value.to_s.strip
    return { precision: :tbd, normalized: text } if text.empty? || text.casecmp('TBD').zero?

    normalized = normalize_ordinal_date(text)
    if normalized.match?(/\A#{MONTH_PATTERN}\s+\d{4}\z/)
      return { precision: :partial_month, normalized: normalized }
    end

    parsed = parse_specific_date(normalized)
    return { precision: :specific, normalized: normalized, start_date: parsed[:start_date], end_date: parsed[:end_date] } if parsed

    { precision: :unparseable, normalized: normalized }
  end

  def parse_specific_date(normalized)
    formats = ['%B %d, %Y', '%b %d, %Y', '%B %e, %Y', '%b %e, %Y']
    formats.each do |format|
      begin
        date = Date.strptime(normalized, format)
        return { start_date: date, end_date: date }
      rescue ArgumentError
        next
      end
    end

    range_match = normalized.match(/\A(#{MONTH_PATTERN})\s+(\d{1,2})\s*-\s*(\d{1,2}),\s*(20\d{2})\z/i)
    if range_match
      month = range_match[1]
      start_day = range_match[2]
      end_day = range_match[3]
      year = range_match[4]
      formats.each do |format|
        begin
          start_date = Date.strptime("#{month} #{start_day}, #{year}", format)
          end_date = Date.strptime("#{month} #{end_day}, #{year}", format)
          return { start_date: start_date, end_date: end_date }
        rescue ArgumentError
          next
        end
      end
    end

    nil
  end

  def source_state(show)
    source_type = show.fetch('source_type', '').to_s.strip
    source_url = show.fetch('source_url', '').to_s.strip
    website = show.fetch('website', '').to_s.strip
    public_url = source_url.empty? ? website : source_url
    domain = url_domain(public_url)

    confidence = if source_type.match?(/direct/i)
                   'direct_organizer_confirmation'
                 elsif source_type.match?(/official.*venue|venue/i)
                   'official_venue_source'
                 elsif source_type.match?(/official.*association|association/i)
                   'official_association_source'
                 elsif source_type.match?(/official.*social|facebook/i)
                   'clearly_official_social_source'
                 elsif source_type.match?(/official|organizer|show_page/i)
                   'official_organizer_source'
                 elsif THIRD_PARTY_DOMAINS.include?(domain)
                   'third_party_lead'
                 elsif public_url.empty?
                   'no_public_source_url'
                 else
                   'public_url_unclassified'
                 end

    {
      source_type: source_type,
      source_url: source_url,
      website: website,
      public_url: public_url,
      domain: domain,
      confidence: confidence
    }
  end

  def url_domain(url)
    return '' if url.to_s.strip.empty?

    URI.parse(url).host.to_s.downcase.sub(/^www\./, '')
  rescue URI::InvalidURIError
    'invalid-url'
  end

  def title_tokens(value)
    value.to_s.downcase.gsub(/20\d{2}|\d+(st|nd|rd|th)?|jan(uary)?|feb(ruary)?|mar(ch)?|apr(il)?|may|jun(e)?|jul(y)?|aug(ust)?|sep(t|tember)?|oct(ober)?|nov(ember)?|dec(ember)?|monday|tuesday|wednesday|thursday|friday|saturday|sunday|sat|sun|am|pm/i, ' ')
         .gsub(/[^a-z0-9]+/, ' ')
         .split
         .reject { |token| STOP_WORDS.include?(token) }
  end

  def duplicate_candidates(shows)
    candidates = []
    shows.combination(2) do |left, right|
      next unless left.fetch('state', '').to_s.downcase == right.fetch('state', '').to_s.downcase
      next unless left.fetch('city', '').to_s.downcase == right.fetch('city', '').to_s.downcase

      if left.fetch('name', '').to_s.downcase == right.fetch('name', '').to_s.downcase
        candidates << DuplicateCandidate.new(classification: 'exact', listing_ids: [left.fetch('id'), right.fetch('id')], reason: 'same normalized name, city, and state', confidence: 'high')
        next
      end

      left_tokens = title_tokens(left.fetch('name', ''))
      right_tokens = title_tokens(right.fetch('name', ''))
      next if left_tokens.empty? || right_tokens.empty?

      overlap = left_tokens & right_tokens
      similarity = overlap.size.to_f / (left_tokens | right_tokens).size.to_f
      next unless similarity >= 0.5 || overlap.size >= 2

      classification = if similarity >= 0.85 || overlap.size >= 3
                         'high-confidence'
                       else
                         'low-confidence'
                       end
      candidates << DuplicateCandidate.new(
        classification: classification,
        listing_ids: [left.fetch('id'), right.fetch('id')],
        reason: "same city/state with title token overlap #{overlap.join('+')} (similarity #{similarity.round(2)})",
        confidence: classification == 'high-confidence' ? 'medium' : 'low'
      )
    end
    candidates
  end

  def build_issues(shows, as_of: Date.today)
    issues = []
    shows.each do |show|
      id = show.fetch('id')
      state = source_state(show)
      date_state = date_text_classification(show.fetch('next_date', ''))
      next_date = show.fetch('next_date', '').to_s
      name = show.fetch('name', '').to_s
      notes = show.fetch('notes', '').to_s
      venue = show.fetch('venue', '').to_s
      city = show.fetch('city', '').to_s

      if date_state[:precision] == :specific && date_state[:end_date] < as_of
        issues << Issue.new(listing_id: id, issue_type: 'expired_specific_date', reason: 'specific date or date range ended before audit date', current_value: next_date, evidence_source_state: state[:confidence], confidence: 'high', recommended_next_action: 'review official/direct source for next date; do not change indexing until expert feedback')
      elsif %i[partial_month].include?(date_state[:precision])
        issues << Issue.new(listing_id: id, issue_type: 'ambiguous_partial_date', reason: 'month/year date lacks exact day precision and must not be treated as automatically expired', current_value: next_date, evidence_source_state: state[:confidence], confidence: 'high', recommended_next_action: 'verify exact date or mark date pending after evidence review')
      elsif date_state[:precision] == :unparseable
        issues << Issue.new(listing_id: id, issue_type: 'unparseable_date', reason: 'date is neither TBD, supported partial month/year, nor supported specific date/range', current_value: next_date, evidence_source_state: state[:confidence], confidence: 'high', recommended_next_action: 'normalize after source verification')
      end

      if name.match?(DATED_TITLE_PATTERN)
        issues << Issue.new(listing_id: id, issue_type: 'obsolete_date_in_title', reason: 'listing title contains date/month/day wording that can become stale', current_value: name, evidence_source_state: state[:confidence], confidence: 'medium', recommended_next_action: 'verify whether this is one occurrence or recurring show before retitling')
      end

      if next_date.strip.casecmp('TBD').zero? && (name.match?(DATED_TITLE_PATTERN) || notes.match?(/\b(20\d{2}|Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Sept|Oct|Nov|Dec)\b/i))
        issues << Issue.new(listing_id: id, issue_type: 'tbd_date_contradiction', reason: 'next_date is TBD while title or notes contain date-like text', current_value: "name=#{name}; notes=#{notes}", evidence_source_state: state[:confidence], confidence: 'medium', recommended_next_action: 'verify current date and separate historical title text from current date fields')
      end

      if venue.strip.empty? || city.strip.empty? || show.fetch('state', '').to_s.strip.empty? || show.fetch('state_name', '').to_s.strip.empty? || city.match?(ADDRESS_IN_CITY_PATTERN)
        issues << Issue.new(listing_id: id, issue_type: 'missing_or_incomplete_venue', reason: 'venue/location fields are blank or city appears to contain address/venue fragments', current_value: "city=#{city}; venue=#{venue}", evidence_source_state: state[:confidence], confidence: 'high', recommended_next_action: 'verify venue name and address from official/direct source')
      end

      if show.fetch('last_verified', '').to_s.strip.empty?
        issues << Issue.new(listing_id: id, issue_type: 'missing_last_verified', reason: 'no last_verified value recorded; do not invent one', current_value: '', evidence_source_state: state[:confidence], confidence: 'high', recommended_next_action: 'add last_verified only after evidence review')
      end

      if state[:public_url].empty?
        issues << Issue.new(listing_id: id, issue_type: 'missing_public_source_url', reason: 'no public source_url or website is recorded', current_value: '', evidence_source_state: state[:confidence], confidence: 'high', recommended_next_action: 'find official organizer, venue, association, or clearly official social source')
      end

      if state[:confidence] == 'third_party_lead'
        issues << Issue.new(listing_id: id, issue_type: 'weak_third_party_only_evidence', reason: 'source appears to be a third-party lead and needs independent verification', current_value: state[:public_url], evidence_source_state: state[:confidence], confidence: 'medium', recommended_next_action: 'verify against official/direct source before changing listing')
      end

      if visible_schema_mismatch?(date_state, as_of)
        issues << Issue.new(listing_id: id, issue_type: 'visible_schema_mismatch', reason: schema_mismatch_reason(date_state, as_of), current_value: next_date, evidence_source_state: state[:confidence], confidence: 'medium', recommended_next_action: 'review schema behavior after status model is approved; indexing decisions remain on hold')
      end
    end

    duplicate_candidates(shows).each do |candidate|
      candidate.listing_ids.each do |listing_id|
        issues << Issue.new(listing_id: listing_id, issue_type: "duplicate_candidate_#{candidate.classification}", reason: candidate.reason, current_value: candidate.listing_ids.join(' | '), evidence_source_state: 'comparison_only', confidence: candidate.confidence, recommended_next_action: 'manual evidence review only; never auto-merge')
      end
    end

    issues
  end

  def visible_schema_mismatch?(date_state, as_of = Date.today)
    return true if date_state[:precision] == :partial_month
    return true if date_state[:precision] == :unparseable
    return true if date_state[:precision] == :specific && date_state[:normalized].include?('-')
    return true if date_state[:precision] == :specific && date_state[:end_date] && date_state[:end_date] < as_of

    false
  end

  def schema_mismatch_reason(date_state, as_of)
    case date_state[:precision]
    when :partial_month
      'visible partial date has no precise Event schema date'
    when :unparseable
      'visible date is not safely parseable for Event schema'
    when :specific
      if date_state[:end_date] && date_state[:end_date] < as_of
        'specific visible date is expired and should not remain scheduled Event schema'
      else
        'date range needs explicit schema start/end review'
      end
    else
      'date/schema relationship needs review'
    end
  end

  def write_reports(issues, duplicates, shows, output_dir:, as_of:, inventory_commit:, inventory_branch:)
    FileUtils.mkdir_p(output_dir)
    timestamp = Time.now.utc.strftime('%Y%m%dT%H%M%SZ')
    csv_path = File.join(output_dir, "show-data-trust-issues-#{timestamp}.csv")
    md_path = File.join(output_dir, "show-data-trust-summary-#{timestamp}.md")

    CSV.open(csv_path, 'w') do |csv|
      csv << %w[listing_id issue_type reason relevant_current_value evidence_source_state confidence recommended_next_action]
      issues.each do |issue|
        csv << [issue.listing_id, issue.issue_type, issue.reason, issue.current_value, issue.evidence_source_state, issue.confidence, issue.recommended_next_action]
      end
    end

    expected_issue_types = %w[
      expired_specific_date ambiguous_partial_date unparseable_date
      obsolete_date_in_title tbd_date_contradiction missing_or_incomplete_venue
      missing_last_verified missing_public_source_url weak_third_party_only_evidence
      visible_schema_mismatch duplicate_candidate_exact
      duplicate_candidate_high-confidence duplicate_candidate_low-confidence
    ]
    observed_counts = issues.group_by(&:issue_type).transform_values(&:size)
    counts = expected_issue_types.to_h { |type| [type, observed_counts.fetch(type, 0)] }
    duplicate_counts = duplicates.group_by(&:classification).transform_values(&:size)
    File.write(md_path, summary_markdown(counts, duplicate_counts, shows, as_of, inventory_commit, inventory_branch, csv_path))
    { csv_path: csv_path, md_path: md_path, counts: counts, duplicate_counts: duplicate_counts }
  end

  def summary_markdown(counts, duplicate_counts, shows, as_of, inventory_commit, inventory_branch, csv_path)
    <<~MD
      # Coin Shows data-trust audit summary

      Generated: #{Time.now.utc.iso8601}

      Report-only. This audit does not edit `_data/shows.yml`, generated pages, templates, schema, sitemap, indexing settings, CRM, or outreach systems.

      ## Inventory anchor

      - Inventory branch recorded before coding: `#{inventory_branch}`
      - Inventory commit recorded before coding: `#{inventory_commit}`
      - Audit date: #{as_of}
      - Listings loaded: #{shows.size}
      - Unique IDs loaded: #{shows.map { |show| show.fetch('id') }.uniq.size}
      - Complete issue CSV: `#{csv_path}`

      ## Issue counts

      | Issue type | Rows |
      |---|---:|
      #{counts.map { |type, count| "| #{type} | #{count} |" }.join("\n")}

      ## Duplicate candidate pair counts

      | Classification | Pairs |
      |---|---:|
      #{%w[exact high-confidence low-confidence].map { |type| "| #{type} | #{duplicate_counts.fetch(type, 0)} |" }.join("\n")}

      ## Interpretation

      - `expired_specific_date`: exact day or date range ended before the audit date. Do not delete, redirect, canonicalize, or noindex from this finding alone.
      - `ambiguous_partial_date`: month/year values such as `July 2026`; verify exact date or mark date pending later.
      - `unparseable_date`: value is not TBD, supported partial month/year, or supported specific date/range.
      - `duplicate_candidate_*`: comparison-only signal; never auto-merge without evidence.
      - `obsolete_date_in_title`: title contains date-like language that can become stale.
      - `tbd_date_contradiction`: `next_date` says TBD but title/notes mention date-like text.
      - `missing_or_incomplete_venue`: venue/location needs official/direct verification.
      - `missing_last_verified`: verification date is absent; never bulk-invent it.
      - `missing_public_source_url`: no public source URL is recorded; this is separate from evidence confidence.
      - `weak_third_party_only_evidence`: third-party lead needs official/direct corroboration.
      - `visible_schema_mismatch`: visible date and current schema behavior need review after status matrix approval.
    MD
  end

  def run(argv)
    options = { as_of: Date.today, output_dir: default_output_dir }
    parser = OptionParser.new do |opts|
      opts.banner = 'Usage: ruby _scripts/show-data-trust-audit.rb [options]'
      opts.on('--as-of DATE', 'Audit date, YYYY-MM-DD') { |value| options[:as_of] = Date.iso8601(value) }
      opts.on('--output-dir DIR', 'Override report directory') { |value| options[:output_dir] = value }
      opts.on('--inventory-commit SHA', 'Inventory commit recorded before coding') { |value| options[:inventory_commit] = value }
      opts.on('--inventory-branch BRANCH', 'Inventory branch recorded before coding') { |value| options[:inventory_branch] = value }
    end
    parser.parse!(argv)

    shows = YAML.load_file('_data/shows.yml')
    duplicates = duplicate_candidates(shows)
    issues = build_issues(shows, as_of: options[:as_of])
    result = write_reports(
      issues,
      duplicates,
      shows,
      output_dir: options[:output_dir],
      as_of: options[:as_of],
      inventory_commit: options[:inventory_commit] || `git rev-parse HEAD`.strip,
      inventory_branch: options[:inventory_branch] || `git rev-parse --abbrev-ref HEAD`.strip
    )

    puts "Report-only audit complete"
    puts "Listings: #{shows.size}"
    puts "Issue rows: #{issues.size}"
    result[:counts].each { |type, count| puts "#{type}: #{count}" }
    puts "Duplicate pairs: exact=#{result[:duplicate_counts].fetch('exact', 0)} high=#{result[:duplicate_counts].fetch('high-confidence', 0)} low=#{result[:duplicate_counts].fetch('low-confidence', 0)}"
    puts "Summary: #{result[:md_path]}"
    puts "CSV: #{result[:csv_path]}"
  end
end

if $PROGRAM_NAME == __FILE__
  ShowDataTrustAudit.run(ARGV)
end
