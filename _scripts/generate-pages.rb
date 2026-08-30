#!/usr/bin/env ruby
# Generate state, city, and show pages from _data YAML files.
# Run from repo root: ruby _scripts/generate-pages.rb

require 'cgi'
require 'fileutils'
require 'json'
require 'yaml'
require_relative 'show_feed'

states = YAML.load_file('_data/states.yml')
shows = YAML.load_file('_data/shows.yml')
city_redirects = YAML.load_file('_data/city_redirects.yml')

abort '_data/city_redirects.yml must contain an array' unless city_redirects.is_a?(Array)

SITE_TITLE_SUFFIX = ' | Coin Shows Near Me'
MAX_RENDERED_TITLE_LENGTH = 60

def checked_page_title(title)
  rendered_title = title + SITE_TITLE_SUFFIX
  abort "Generated SEO title is too long (#{rendered_title.length}): #{rendered_title}" if rendered_title.length > MAX_RENDERED_TITLE_LENGTH

  title
end

# --- State pages ---
FileUtils.mkdir_p('states')

# State index page
File.write('states/index.md', <<~MD)
---
layout: default
title: "Coin Shows by State"
heading: "Coin Shows by State — Complete US Directory"
description: "Browse coin shows in all 50 US states, with upcoming dates, venues, and verification details for local and national events."
permalink: /states/
nav_order: 2
breadcrumb_current: "States"
---

# Coin Shows by State

Find coin shows in every US state. Click a state below to see all upcoming shows, venues, and schedules.

{% assign shows = site.data.shows %}

<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:0.5rem;margin:1.5rem 0;">
{% for state in site.data.states %}
  {% assign state_count = shows | where: "state", state.abbrev | size %}
  <a href="{{ site.baseurl }}/states/{{ state.slug }}/" style="display:block;padding:0.6rem 0.8rem;border:1px solid #e5e7eb;border-radius:0.5rem;text-decoration:none;color:#111827;background:#f9fafb;">
    <strong>{{ state.name }}</strong>
    <span style="color:#6b7280;font-size:0.85rem;"> ({{ state_count }})</span>
  </a>
{% endfor %}
</div>
MD

# Individual state pages
states.each do |state|
  slug = state['slug']
  name = state['name']
  abbrev = state['abbrev']
  state_shows = shows.select { |s| s['state'] == abbrev }
  page_title = checked_page_title("#{name} Coin Shows")
  heading = "Coin Shows in #{name} — #{Time.now.year}-#{Time.now.year + 1} Schedule"
  description = "Browse #{state_shows.size} coin shows in #{name} with dates, venues, and verification details. Check each listing before you travel."

  content = <<~MD
    ---
    layout: state
    title: "#{page_title}"
    heading: "#{heading}"
    description: "#{description}"
    permalink: /states/#{slug}/
    state_abbrev: "#{abbrev}"
    state_name: "#{name}"
    state_slug: "#{slug}"
    breadcrumb_parent: "States"
    breadcrumb_parent_url: "/states/"
    breadcrumb_current: "#{name}"
    nav_exclude: true
    ---
  MD

  File.write("states/#{slug}.md", content.gsub(/^    /, ''))
end

# --- City pages ---
FileUtils.mkdir_p('cities')

cities = shows.group_by { |s| s['city_slug'] }

cities.each do |city_slug, city_shows|
  first = city_shows.first
  city_name = first['city']
  state_name = first['state_name']
  state_abbrev = first['state']
  state_data = states.find { |s| s['abbrev'] == state_abbrev }
  state_slug = state_data ? state_data['slug'] : state_abbrev.downcase
  page_title = checked_page_title("#{city_name}, #{state_abbrev} Coin Shows")
  heading = "Coin Shows in #{city_name}, #{state_name} — #{Time.now.year}-#{Time.now.year + 1}"
  show_noun = city_shows.size == 1 ? 'show' : 'shows'
  description = "Find #{city_shows.size} coin #{show_noun} in #{city_name}, #{state_name}. Compare dates, venues, and verification details before you travel."

  content = <<~MD
    ---
    layout: city
    title: "#{page_title}"
    heading: "#{heading}"
    description: "#{description}"
    permalink: /cities/#{city_slug}/
    city_slug: "#{city_slug}"
    city_name: "#{city_name}"
    state_name: "#{state_name}"
    state_slug: "#{state_slug}"
    breadcrumb_parent: "#{state_name}"
    breadcrumb_parent_url: "/states/#{state_slug}/"
    breadcrumb_current: "#{city_name}"
    nav_exclude: true
    ---
  MD

  File.write("cities/#{city_slug}.md", content.gsub(/^    /, ''))
end

# Preserve exact old city URLs after a listing moves or a malformed slug is fixed.
canonical_city_slugs = cities.keys
legacy_city_slugs = city_redirects.map { |redirect| redirect.fetch('legacy_slug') }
duplicate_legacy_city_slugs = legacy_city_slugs.group_by(&:itself).select { |_slug, values| values.length > 1 }.keys
city_redirect_collisions = legacy_city_slugs & canonical_city_slugs
missing_city_destinations = city_redirects.map do |redirect|
  destination = redirect.fetch('canonical_slug')
  destination unless canonical_city_slugs.include?(destination)
end.compact
city_redirect_chains = city_redirects.map do |redirect|
  destination = redirect.fetch('canonical_slug')
  destination if legacy_city_slugs.include?(destination)
end.compact

abort "Duplicate legacy city slugs: #{duplicate_legacy_city_slugs.join(', ')}" unless duplicate_legacy_city_slugs.empty?
abort "City redirects collide with canonical slugs: #{city_redirect_collisions.join(', ')}" unless city_redirect_collisions.empty?
abort "Missing city redirect destinations: #{missing_city_destinations.join(', ')}" unless missing_city_destinations.empty?
abort "City redirect chains are not allowed: #{city_redirect_chains.join(', ')}" unless city_redirect_chains.empty?

city_redirects.each do |redirect|
  legacy_slug = redirect.fetch('legacy_slug')
  canonical_slug = redirect.fetch('canonical_slug')
  canonical_city = cities.fetch(canonical_slug).first.fetch('city')
  canonical_city_html = CGI.escapeHTML(canonical_city)
  canonical_path = "/cities/#{canonical_slug}/"
  content = <<~MD
    ---
    layout: null
    title: "Coin show city page moved"
    permalink: /cities/#{legacy_slug}/
    sitemap: false
    ---
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="robots" content="noindex,follow">
        <meta http-equiv="refresh" content="0; url={{ site.baseurl }}#{canonical_path}">
        <link rel="canonical" href="{{ site.url }}{{ site.baseurl }}#{canonical_path}">
        <title>Coin show city page moved</title>
      </head>
      <body>
        <p>This city listing moved to <a href="{{ site.baseurl }}#{canonical_path}">#{canonical_city_html} coin shows</a>.</p>
      </body>
    </html>
  MD

  File.write("cities/#{legacy_slug}.md", content.gsub(/^    /, ''))
end

# --- Show pages ---
FileUtils.mkdir_p('shows')

shows.each do |show|
  state_data = states.find { |s| s['abbrev'] == show['state'] }
  state_slug = state_data ? state_data['slug'] : show['state'].downcase
  page_title = checked_page_title(show['short_title'] || show['name'])
  heading = "#{show['name']} — #{show['city']}, #{show['state_name']} Coin Show"
  description = "#{show['name']} in #{show['city']}, #{show['state_name']}. View dates, venue details, and listing verification before you travel."

  content = <<~MD
    ---
    layout: show
    title: "#{page_title}"
    heading: "#{heading}"
    description: "#{description}"
    permalink: /shows/#{show['id']}/
    show_id: "#{show['id']}"
    breadcrumb_parent: "#{show['state_name']}"
    breadcrumb_parent_url: "/states/#{state_slug}/"
    breadcrumb_current: "#{show['name']}"
    nav_exclude: true
    ---
  MD

  File.write("shows/#{show['id']}.md", content.gsub(/^    /, ''))
end

# Preserve old listing URLs after duplicate records are merged into one canonical show.
show_ids = shows.map { |show| show.fetch('id') }
alias_pairs = shows.flat_map do |show|
  Array(show['aliases']).map { |alias_id| [alias_id, show] }
end
alias_ids = alias_pairs.map(&:first)
duplicate_aliases = alias_ids.group_by(&:itself).select { |_alias_id, values| values.length > 1 }.keys
alias_collisions = alias_ids & show_ids

abort "Duplicate show aliases: #{duplicate_aliases.join(', ')}" unless duplicate_aliases.empty?
abort "Show aliases collide with canonical IDs: #{alias_collisions.join(', ')}" unless alias_collisions.empty?

alias_pairs.each do |alias_id, show|
  canonical_path = "/shows/#{show.fetch('id')}/"
  show_name = CGI.escapeHTML(show.fetch('name'))
  content = <<~MD
    ---
    layout: null
    title: "#{show.fetch('name')} — Listing moved"
    permalink: /shows/#{alias_id}/
    sitemap: false
    ---
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="robots" content="noindex,follow">
        <meta http-equiv="refresh" content="0; url={{ site.baseurl }}#{canonical_path}">
        <link rel="canonical" href="{{ site.url }}{{ site.baseurl }}#{canonical_path}">
        <title>#{show_name} — Listing moved</title>
      </head>
      <body>
        <p>This listing was merged into <a href="{{ site.baseurl }}#{canonical_path}">#{show_name}</a>.</p>
      </body>
    </html>
  MD

  File.write("shows/#{alias_id}.md", content.gsub(/^    /, ''))
end

feed_json = JSON.pretty_generate(
  ShowFeed.build(shows),
  indent: '  ',
  space: ' ',
  array_nl: "\n",
  object_nl: "\n"
)
File.write('shows.json', feed_json + "\n")

puts "Generated:"
puts "  #{states.size} state pages + index"
puts "  #{cities.size} city pages"
puts "  #{city_redirects.size} city redirects"
puts "  #{shows.size} show pages"
puts "  #{alias_pairs.size} show redirects"
puts "  #{shows.size} show feed records"
puts "  Total: #{states.size + 1 + cities.size + city_redirects.size + shows.size + alias_pairs.size} pages"
