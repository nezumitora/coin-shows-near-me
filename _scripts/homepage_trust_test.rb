# frozen_string_literal: true

require 'minitest/autorun'
require 'date'
require 'yaml'

class HomepageTrustTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)
  HOMEPAGE = File.read(File.join(ROOT, '_layouts/homepage.html'))
  SHOW_LAYOUT = File.read(File.join(ROOT, '_layouts/show.html'))
  SUBMIT_SHOW = File.read(File.join(ROOT, 'submit-show.md'))
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
    spot_position = HOMEPAGE.index('<!-- Secondary market reference -->')
    show_cards_position = HOMEPAGE.index('<!-- Show Cards -->')

    refute_nil filter_position
    refute_nil show_cards_position
    refute_nil spot_position
    assert_operator filter_position, :<, show_cards_position
    assert_operator show_cards_position, :<, spot_position
    assert_includes HOMEPAGE, 'id="spot-ticker"'
    refute_includes HOMEPAGE, 'sponsor-preview-section'
    refute_includes HOMEPAGE, 'dealer-section'
    refute_includes HOMEPAGE, 'dealer-reg-form'
  end

  def test_homepage_reminder_is_data_minimal
    assert_includes HOMEPAGE, 'id="notify-form"'
    assert_includes HOMEPAGE, 'name="preferredState"'
    refute_includes HOMEPAGE, 'name="name"'
    assert_equal 1, HOMEPAGE.scan(/<input[^>]+name="showReminderOptIn"/).length
  end

  def test_show_pages_expose_verification_context
    assert_includes SHOW_LAYOUT, 'Listing Status'
    assert_includes SHOW_LAYOUT, 'Last Checked'
    assert_includes SHOW_LAYOUT, 'Verification Source'
    assert_includes SHOW_LAYOUT, 'View the source used to check this listing'
  end

  def test_organizer_workflows_require_manual_review
    assert_includes SHOW_LAYOUT, 'id="organizer-verification-form"'
    assert_includes SHOW_LAYOUT, 'does not automatically verify or change the listing'
    assert_includes SUBMIT_SHOW, 'id="show-submission-form"'
    assert_includes SUBMIT_SHOW, 'Every submission is reviewed manually.'
    assert_includes SUBMIT_SHOW, 'does not automatically create or verify a public listing'
  end

  def test_visible_version_is_current
    assert_includes HOMEPAGE, '<div class="footer-version">v0.11.0</div>'
    assert_includes File.read(File.join(ROOT, '_includes/nav_footer_custom.html')), 'v0.11.0'
  end
end
