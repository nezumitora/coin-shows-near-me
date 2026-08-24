# frozen_string_literal: true

require 'json'
require 'minitest/autorun'
require 'yaml'
require_relative 'show_feed'

class ShowFeedTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)

  def test_builds_a_fixed_public_schema_and_ignores_aliases
    shows = [
      {
        'id' => 'example-show',
        'name' => 'Example Show',
        'city' => 'Example City',
        'state' => 'CA',
        'state_name' => 'California',
        'venue' => 'Example Hall, Example City, CA 90210',
        'frequency' => 'Annual',
        'next_date' => 'TBD',
        'upcoming_dates' => ['2026-10-10'],
        'series_ended' => true,
        'website' => 'https://example.com/show',
        'aliases' => ['old-example-show'],
        'verification_notes' => 'Internal note'
      }
    ]

    feed = ShowFeed.build(shows)

    assert_equal 1, feed.length
    assert_equal ShowFeed::PUBLIC_FIELDS, feed.first.keys
    assert_equal ['2026-10-10'], feed.first.fetch('upcoming_dates')
    assert_equal true, feed.first.fetch('series_ended')
    assert_equal '90210', feed.first.fetch('postal_code')
    refute feed.first.key?('aliases')
    refute feed.first.key?('verification_notes')
  end

  def test_sorts_deterministically_and_blanks_unsafe_websites
    shows = [
      { 'id' => 'z-show', 'name' => 'Zulu', 'city' => 'Beta', 'state' => 'WI', 'website' => 'javascript:alert(1)' },
      { 'id' => 'a-show', 'name' => 'Alpha', 'city' => 'Alpha', 'state' => 'AZ' }
    ]

    feed = ShowFeed.build(shows)

    assert_equal %w[a-show z-show], feed.map { |show| show.fetch('id') }
    assert_equal '', feed.last.fetch('website')
    assert_equal '', feed.first.fetch('venue')
  end

  def test_checked_in_feed_matches_canonical_yaml
    shows = YAML.load_file(File.join(ROOT, '_data/shows.yml'))
    checked_in_feed = JSON.parse(File.read(File.join(ROOT, 'shows.json')))

    assert_equal ShowFeed.build(shows), checked_in_feed
    assert_equal shows.map { |show| show.fetch('id') }.sort, checked_in_feed.map { |show| show.fetch('id') }.sort
  end
end
