# frozen_string_literal: true

require 'minitest/autorun'
require 'date'
require 'yaml'

class HomepageTrustTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)
  HOMEPAGE = File.read(File.join(ROOT, '_layouts/homepage.html'))
  SHOW_LAYOUT = File.read(File.join(ROOT, '_layouts/show.html'))
  SHOWS = YAML.load_file(File.join(ROOT, '_data/shows.yml'))
  AS_OF = Date.new(2026, 7, 29)

  def date_status(show)
    date = show.fetch('next_date')
    return :tbd if date == 'TBD'
    latest_date = Array(show['upcoming_dates']).last
    return :expired if latest_date && Date.iso8601(latest_date) < AS_OF
    return :scheduled if date.include?(',')

    :partial
  end

  def test_every_show_receives_one_plain_language_date_status
    statuses = SHOWS.map { |show| date_status(show) }

    assert_equal 197, statuses.length
    assert_equal statuses.length, statuses.count { |status| %i[scheduled partial expired tbd].include?(status) }
    assert_includes statuses, :scheduled
    assert_includes statuses, :partial
    assert_includes statuses, :expired
    assert_includes statuses, :tbd
  end

  def test_month_only_dates_are_partial_not_scheduled
    partial_ids = SHOWS.select { |show| date_status(show) == :partial }.map { |show| show['id'] }

    assert_equal %w[cheyenne-coin-expo hawaii-state-numismatic-association-show], partial_ids.sort
  end

  def test_past_specific_dates_are_marked_expired
    expired_ids = SHOWS.select { |show| date_status(show) == :expired }.map { |show| show['id'] }

    assert_equal %w[
      apnscc-coin-show-sat-july-18th-9am-6pm-sun-july-19th-9am-4pm
      first-annual-lansing-coin-show
      wny-coin-show-meetings-4th-sunday-each-month
    ], expired_ids.sort
  end

  def test_homepage_keeps_directory_discovery_ahead_of_promotions
    filter_position = HOMEPAGE.index('<!-- Filter Bar -->')
    dealer_position = HOMEPAGE.index('<!-- Dealer Portal -->')

    refute_nil filter_position
    refute_nil dealer_position
    assert_operator filter_position, :<, dealer_position
    refute_includes HOMEPAGE, 'id="spot-ticker"'
    refute_includes HOMEPAGE, 'sponsor-preview-section'
    refute_includes HOMEPAGE, 'id="reminder-cta-grid"'
  end

  def test_show_pages_expose_verification_context
    assert_includes SHOW_LAYOUT, 'Listing Status'
    assert_includes SHOW_LAYOUT, 'Last Checked'
    assert_includes SHOW_LAYOUT, 'Verification Source'
    assert_includes SHOW_LAYOUT, 'View the source used to check this listing'
  end

  def test_visible_version_is_current
    assert_includes HOMEPAGE, '<div class="footer-version">v0.10.0</div>'
    assert_includes File.read(File.join(ROOT, '_includes/nav_footer_custom.html')), 'v0.10.0'
  end
end
