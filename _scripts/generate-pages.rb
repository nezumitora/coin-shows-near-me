#!/usr/bin/env ruby
# Generate state, city, and show pages from _data YAML files.
# Run from repo root: ruby _scripts/generate-pages.rb

require 'cgi'
require 'fileutils'
require 'yaml'

states = YAML.load_file('_data/states.yml')
shows = YAML.load_file('_data/shows.yml')

# --- State pages ---
FileUtils.mkdir_p('states')

# State index page
File.write('states/index.md', <<~MD)
---
layout: default
title: "Coin Shows by State — Complete US Directory"
seo_title: "Coin Shows by State — Find Coin Shows in Every US State | Coin Show Near Me"
seo_description: "Browse coin shows in all 50 US states. Find upcoming coin shows, expos, and numismatic conventions near you with dates, venues, and details."
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

  content = <<~MD
    ---
    layout: state
    title: "Coin Shows in #{name} — #{Time.now.year}-#{Time.now.year + 1} Schedule"
    seo_title: "Coin Shows in #{name} — #{Time.now.year}-#{Time.now.year + 1} Schedule & Directory | Coin Show Near Me"
    seo_description: "Find #{state_shows.size} coin shows in #{name}. Complete directory with dates, venues, and details for #{name} coin shows, expos, and numismatic events."
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

  content = <<~MD
    ---
    layout: city
    title: "Coin Shows in #{city_name}, #{state_name} — #{Time.now.year}-#{Time.now.year + 1}"
    seo_title: "Coin Shows in #{city_name}, #{state_name} — #{Time.now.year}-#{Time.now.year + 1} Schedule | Coin Show Near Me"
    seo_description: "Find #{city_shows.size} coin show#{city_shows.size > 1 ? 's' : ''} in #{city_name}, #{state_name}. Dates, venues, and details for upcoming coin shows and numismatic events in #{city_name}."
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

# --- Show pages ---
FileUtils.mkdir_p('shows')

shows.each do |show|
  state_data = states.find { |s| s['abbrev'] == show['state'] }
  state_slug = state_data ? state_data['slug'] : show['state'].downcase

  content = <<~MD
    ---
    layout: show
    title: "#{show['name']} — #{show['city']}, #{show['state_name']} Coin Show"
    seo_title: "#{show['name']} — #{show['city']}, #{show['state_name']} | Coin Show Near Me"
    seo_description: "#{show['name']} in #{show['city']}, #{show['state_name']}. #{show['frequency']} coin show at #{show['venue']}. Get dates, venue details, and more."
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

puts "Generated:"
puts "  #{states.size} state pages + index"
puts "  #{cities.size} city pages"
puts "  #{shows.size} show pages"
puts "  #{alias_pairs.size} show redirects"
puts "  Total: #{states.size + 1 + cities.size + shows.size + alias_pairs.size} pages"
