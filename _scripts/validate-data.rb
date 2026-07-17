#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'yaml'
require_relative 'show_date_parser'

SLUG_PATTERN = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/.freeze

def duplicate_values(values)
  values.group_by(&:itself).select { |_value, matches| matches.length > 1 }.keys
end

def page_slugs(directory)
  Dir.glob(File.join(directory, '*.md')).map { |path| File.basename(path, '.md') }.sort
end

def compare_pages(errors, label, expected, actual)
  missing = expected - actual
  stale = actual - expected
  errors << "Missing #{label} pages: #{missing.join(', ')}" unless missing.empty?
  errors << "Stale #{label} pages: #{stale.join(', ')}" unless stale.empty?
end

errors = []
states = YAML.load_file('_data/states.yml')
shows = YAML.load_file('_data/shows.yml')

errors << '_data/states.yml must contain an array' unless states.is_a?(Array)
errors << '_data/shows.yml must contain an array' unless shows.is_a?(Array)

if errors.empty?
  errors << "Expected 50 states, found #{states.length}" unless states.length == 50

  state_keys = %w[abbrev name slug]
  states.each_with_index do |state, index|
    state_keys.each do |key|
      errors << "State #{index + 1} has a blank #{key}" if state[key].to_s.strip.empty?
    end
    errors << "State #{state['abbrev']} has an invalid abbreviation" unless state['abbrev'].to_s.match?(/\A[A-Z]{2}\z/)
    errors << "State #{state['abbrev']} has an invalid slug" unless state['slug'].to_s.match?(SLUG_PATTERN)
  end

  %w[abbrev name slug].each do |key|
    duplicates = duplicate_values(states.map { |state| state[key] })
    errors << "Duplicate state #{key} values: #{duplicates.join(', ')}" unless duplicates.empty?
  end

  states_by_abbrev = states.each_with_object({}) { |state, result| result[state['abbrev']] = state }
  required_show_keys = %w[id name state state_name city city_slug frequency next_date]

  shows.each_with_index do |show, index|
    label = show['id'].to_s.empty? ? "show #{index + 1}" : show['id']
    required_show_keys.each do |key|
      errors << "#{label} has a blank #{key}" if show[key].to_s.strip.empty?
    end

    errors << "#{label} has an invalid ID" unless show['id'].to_s.match?(SLUG_PATTERN)
    errors << "#{label} has an invalid city_slug" unless show['city_slug'].to_s.match?(SLUG_PATTERN)

    state = states_by_abbrev[show['state']]
    if state.nil?
      errors << "#{label} references unknown state #{show['state']}"
    elsif show['state_name'] != state['name']
      errors << "#{label} state_name #{show['state_name']} does not match #{state['name']}"
    end

    next_date = show['next_date'].to_s
    if next_date != 'TBD' && ShowDateParser.end_date(next_date).nil?
      errors << "#{label} has an invalid next_date: #{next_date}"
    end

    if show.key?('upcoming_dates')
      dates = show['upcoming_dates']
      unless dates.is_a?(Array)
        errors << "#{label} upcoming_dates must be an array"
        dates = []
      end
      date_strings = dates.map(&:to_s)
      errors << "#{label} upcoming_dates must be unique and sorted" unless date_strings == date_strings.uniq.sort
      date_strings.each do |date_text|
        valid = date_text.match?(/\A\d{4}-\d{2}-\d{2}\z/) && (Date.iso8601(date_text) rescue nil)
        errors << "#{label} has an invalid upcoming date: #{date_text}" unless valid
      end
    end

    if show.key?('last_verified')
      verified = show['last_verified'].to_s
      valid = verified.match?(/\A\d{4}-\d{2}-\d{2}\z/) && (Date.iso8601(verified) rescue nil)
      errors << "#{label} has an invalid last_verified date: #{verified}" unless valid
    end

    next unless show.key?('aliases')

    aliases = show['aliases']
    unless aliases.is_a?(Array)
      errors << "#{label} aliases must be an array"
      next
    end
    aliases.each do |alias_id|
      errors << "#{label} has an invalid alias: #{alias_id}" unless alias_id.to_s.match?(SLUG_PATTERN)
    end
  end

  show_ids = shows.map { |show| show['id'] }
  aliases = shows.flat_map { |show| show['aliases'].is_a?(Array) ? show['aliases'] : [] }
  duplicate_ids = duplicate_values(show_ids)
  duplicate_aliases = duplicate_values(aliases)
  alias_collisions = aliases & show_ids
  errors << "Duplicate show IDs: #{duplicate_ids.join(', ')}" unless duplicate_ids.empty?
  errors << "Duplicate show aliases: #{duplicate_aliases.join(', ')}" unless duplicate_aliases.empty?
  errors << "Show aliases collide with canonical IDs: #{alias_collisions.join(', ')}" unless alias_collisions.empty?

  expected_states = (states.map { |state| state['slug'] } + ['index']).sort
  expected_cities = shows.map { |show| show['city_slug'] }.uniq.sort
  expected_shows = (show_ids + aliases).sort
  compare_pages(errors, 'state', expected_states, page_slugs('states'))
  compare_pages(errors, 'city', expected_cities, page_slugs('cities'))
  compare_pages(errors, 'show', expected_shows, page_slugs('shows'))
end

unless errors.empty?
  warn "Data validation failed with #{errors.length} error(s):"
  errors.each { |error| warn "- #{error}" }
  exit 1
end

puts "Data validation passed: #{states.length} states, #{shows.length} shows, #{shows.sum { |show| Array(show['aliases']).length }} aliases."
