# frozen_string_literal: true

require 'minitest/autorun'
require 'date'
require 'yaml'

class HomepageTrustTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)
  HOMEPAGE = File.read(File.join(ROOT, '_layouts/homepage.html'))
  SHOW_LAYOUT = File.read(File.join(ROOT, '_layouts/show.html'))
  SUBMIT_SHOW = File.read(File.join(ROOT, 'submit-show.md'))
  CONTACT_PAGE = File.read(File.join(ROOT, 'contact/index.md'))
  DEALERS_PAGE = File.read(File.join(ROOT, 'dealers/index.md'))
  HEAD_CUSTOM = File.read(File.join(ROOT, '_includes/head_custom.html'))
  PORTAL_PAGE = File.read(File.join(ROOT, 'portal/index.md'))
  FORM_BRIDGE = File.read(File.join(ROOT, '_includes/form_capture_bridge.html'))
  LISTING_REVIEW_FORM = File.read(File.join(ROOT, '_includes/show-listing-review-form.html'))
  PRIVACY_POLICY = File.read(File.join(ROOT, 'legal/privacy-policy.md'))
  TERMS_OF_USE = File.read(File.join(ROOT, 'legal/terms-of-use.md'))
  REVIEW_TEST_PAGE = File.read(File.join(ROOT, 'review-test-show.md'))
  REVIEW_SHOW = YAML.load_file(File.join(ROOT, '_data/review_show.yml'))
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

  def test_homepage_keeps_search_first_and_requested_utilities_near_the_top
    filter_position = HOMEPAGE.index('<!-- Filter Bar -->')
    spot_position = HOMEPAGE.index('<!-- Compact market reference stays inside the hero. -->')
    reminder_position = HOMEPAGE.index('<!-- Single compact homepage signup form')
    show_cards_position = HOMEPAGE.index('<!-- Show Cards -->')

    refute_nil filter_position
    refute_nil show_cards_position
    refute_nil spot_position
    refute_nil reminder_position
    assert_operator reminder_position, :<, spot_position
    assert_operator spot_position, :<, filter_position
    assert_operator filter_position, :<, show_cards_position
    assert_includes HOMEPAGE, 'id="spot-ticker"'
    refute_includes HOMEPAGE, 'sponsor-preview-section'
    refute_includes HOMEPAGE, 'dealer-section'
    refute_includes HOMEPAGE, 'dealer-reg-form'
    assert_includes HOMEPAGE, 'Stay in the <span>Loupe</span>'
    assert_includes HOMEPAGE, 'This Weekend'
    assert_includes HOMEPAGE, 'This Month'
    assert_includes HOMEPAGE, 'id="state-filter"'
    assert_includes HOMEPAGE, 'data-upcoming-dates='
  end

  def test_homepage_reminder_interest_collects_preferences_without_phone_or_sms
    assert_includes HOMEPAGE, 'id="notify-form"'
    assert_includes HOMEPAGE, 'name="first_name"'
    assert_includes HOMEPAGE, 'name="last_name"'
    assert_includes HOMEPAGE, 'name="preferredState"'
    assert_includes HOMEPAGE, 'name="interested_shows_locations"'
    assert_includes HOMEPAGE, 'name="contactConsent"'
    assert_includes HOMEPAGE, 'No recurring reminder service is active yet.'
    refute_includes HOMEPAGE, 'name="phone"'
    refute_includes HOMEPAGE, 'name="sms_consent"'
    refute_includes HOMEPAGE, 'name="showReminderOptIn"'
    refute_includes HOMEPAGE, 'smsConsentTimestamp'
  end

  def test_show_reminder_interest_does_not_collect_phone_or_promise_delivery
    assert_includes SHOW_LAYOUT, 'id="show-reminder-form"'
    assert_includes SHOW_LAYOUT, 'No recurring reminder service is active yet.'
    refute_includes SHOW_LAYOUT, 'name="phone"'
    refute_includes SHOW_LAYOUT, 'name="sms_consent"'
    refute_includes SHOW_LAYOUT, 'name="showReminderOptIn"'
    assert_includes PRIVACY_POLICY, 'do not collect mobile numbers or activate recurring email or text messages'
    assert_includes TERMS_OF_USE, 'No Current SMS Reminder Program'
  end

  def test_contact_and_portal_forms_do_not_add_reminder_opt_ins
    [CONTACT_PAGE, PORTAL_PAGE].each do |page|
      refute_includes page, 'name="showReminderOptIn"'
      refute_includes page, 'reminderConsentTimestamp'
      refute_includes page, 'If I provide a phone number'
    end
  end

  def test_crm_bridge_never_infers_sms_consent
    assert_includes FORM_BRIDGE, "rawSmsConsent.toLowerCase() === 'yes' && Boolean(phone)"
    refute_includes FORM_BRIDGE, 'phone && contactConsent && showOptIn'
    assert_includes FORM_BRIDGE, "window.coinGetFormValue(form, 'first_name')"
    assert_includes FORM_BRIDGE, "window.coinGetFormValue(form, 'last_name')"
  end

  def test_show_pages_expose_verification_context
    assert_includes SHOW_LAYOUT, 'Listing Status'
    assert_includes SHOW_LAYOUT, 'Last Checked'
    assert_includes SHOW_LAYOUT, 'Verification Source'
    assert_includes SHOW_LAYOUT, 'View the source used to check this listing'
  end

  def test_organizer_workflows_require_manual_review
    assert_includes LISTING_REVIEW_FORM, '<option value="organizerVerification">'
    assert_includes LISTING_REVIEW_FORM, 'Submitted changes, verification, and removal requests are reviewed manually.'
    assert_includes SUBMIT_SHOW, 'id="show-submission-form"'
    assert_includes SUBMIT_SHOW, 'Every submission is reviewed manually.'
    assert_includes SUBMIT_SHOW, 'does not automatically create or verify a public listing'
    assert_includes SUBMIT_SHOW, '<legend>Show location</legend>'
    assert_includes SUBMIT_SHOW, 'https://coinshownearme.com/'
    assert_includes SUBMIT_SHOW, 'novalidate'
    assert_includes SUBMIT_SHOW, 'coinNormalizeFormUrls'
    assert_includes SUBMIT_SHOW, 'Help more collectors discover your event'
    assert_includes SUBMIT_SHOW, '[Coin Show Near Me][New Show]'
  end

  def test_dealer_directory_has_compact_listing_cta_before_search
    top_cta_position = DEALERS_PAGE.index('id="dealer-top-cta"')
    search_position = DEALERS_PAGE.index('id="dealer-search"')

    refute_nil top_cta_position
    refute_nil search_position
    assert_operator top_cta_position, :<, search_position
    assert_includes DEALERS_PAGE, 'href="#dealer-listing-form"'
    assert_includes DEALERS_PAGE, 'id="dealer-listing-cta"'
    assert_includes DEALERS_PAGE, 'id="dealer-listing-form"'
    assert_includes DEALERS_PAGE, 'Get Added to the Directory'
    assert_includes DEALERS_PAGE, 'Submit Dealer Listing for Review'
    refute_includes DEALERS_PAGE, '<select name="dealer_type"'
    assert_includes DEALERS_PAGE, 'name="dealer_type_brick_and_mortar"'
    assert_includes DEALERS_PAGE, 'name="dealer_type_online"'
    assert_includes DEALERS_PAGE, 'name="dealer_type_auction_house"'
    assert_includes DEALERS_PAGE, 'name="dealer_type_coin_show"'
    assert_includes DEALERS_PAGE, 'id="dealer-physical-address"'
    assert_includes DEALERS_PAGE, 'name="physical_street_address"'
    assert_includes DEALERS_PAGE, 'name="physical_postal_code"'
    assert_includes DEALERS_PAGE, 'updateDealerTypeRequirements'
    assert_includes DEALERS_PAGE, 'name="social_facebook_url"'
    assert_includes DEALERS_PAGE, 'name="social_instagram_url"'
    assert_includes DEALERS_PAGE, 'name="social_youtube_url"'
    assert_includes DEALERS_PAGE, 'name="social_tiktok_url"'
    assert_includes DEALERS_PAGE, 'name="social_linkedin_url"'
    assert_includes DEALERS_PAGE, 'name="social_x_url"'
    assert_includes HEAD_CUSTOM, '.dealer-listing-consent input[type="checkbox"]'
    assert_includes DEALERS_PAGE, 'name="specialty"'
    refute_includes DEALERS_PAGE, 'Contact Us to Be Listed'
  end

  def test_show_management_uses_one_prefilled_review_workflow
    assert_includes SHOW_LAYOUT, '{% include show-listing-review-form.html show=show review_fixture=page.review_fixture %}'
    assert_includes SHOW_LAYOUT, 'data-listing-review-trigger'
    assert_includes LISTING_REVIEW_FORM, 'id="listing-review-form"'
    assert_includes LISTING_REVIEW_FORM, 'Current listing information is shown on the left.'
    assert_includes LISTING_REVIEW_FORM, 'Correct as shown'
    assert_includes LISTING_REVIEW_FORM, 'data-confirm-target="review-show-name"'
    assert_includes LISTING_REVIEW_FORM, '<option value="correction">'
    assert_includes LISTING_REVIEW_FORM, '<option value="organizerVerification">'
    assert_includes LISTING_REVIEW_FORM, '<option value="reviewRemoval">'
    assert_includes LISTING_REVIEW_FORM, '<option value="dealerAtShow">'
    assert_includes LISTING_REVIEW_FORM, 'name="confirmation_source_type"'
    assert_includes LISTING_REVIEW_FORM, 'Organizer verified</strong> is reserved'
    assert_includes LISTING_REVIEW_FORM, 'Venue confirmed</em>, <em>Dealer reported</em>, or <em>Community reported</em>'
    assert_includes LISTING_REVIEW_FORM, 'relationshipField.setCustomValidity'
    assert_includes LISTING_REVIEW_FORM, 'name="proposed_street_address"'
    assert_includes LISTING_REVIEW_FORM, 'name="proposed_notes"'
  end

  def test_requested_featured_show_addresses_are_complete_and_verified
    long_beach = SHOWS.find { |show| show.fetch('id') == 'long-beach-expo' }
    fun = SHOWS.find { |show| show.fetch('id') == 'fun-convention' }

    assert_equal '300 East Ocean Boulevard', long_beach.fetch('street_address')
    assert_equal '90802', long_beach.fetch('postal_code')
    assert_equal '9899 International Drive', fun.fetch('street_address')
    assert_equal '32819', fun.fetch('postal_code')
  end

  def test_show_pages_do_not_present_venue_only_locations_as_verified_addresses
    assert_includes SHOW_LAYOUT, '<em>Complete street address not yet verified</em>'
    refute_includes SHOW_LAYOUT, 'destination={{ show.venue | url_encode }}'
  end

  def test_local_review_fixture_cannot_publish_or_send_forms
    assert_includes REVIEW_TEST_PAGE, 'published: false'
    assert_includes REVIEW_TEST_PAGE, 'sitemap: false'
    assert_includes REVIEW_TEST_PAGE, 'review_fixture: true'
    assert_equal 'local-review-test-show', REVIEW_SHOW.fetch('id')
    refute_includes SHOWS.map { |show| show.fetch('id') }, REVIEW_SHOW.fetch('id')
    assert_includes SHOW_LAYOUT, 'var localReviewMode = {% if page.review_fixture %}true{% else %}false{% endif %};'
    assert_includes LISTING_REVIEW_FORM, 'var localReviewMode = {% if include.review_fixture %}true{% else %}false{% endif %};'
    assert_includes SHOW_LAYOUT, 'Submissions on this unpublished fixture stay in the browser'
  end

  def test_listing_removal_is_manual_and_privacy_documented
    assert_includes LISTING_REVIEW_FORM, '<option value="reviewRemoval">'
    assert_includes LISTING_REVIEW_FORM, 'Changes, verification, and removal requests are reviewed manually and are not guaranteed.'
    assert_includes PRIVACY_POLICY, 'Public Event Information and Removal Requests'
    assert_includes PRIVACY_POLICY, 'They are not automatically removed merely because a request is submitted.'
  end

  def test_visible_version_is_current
    assert_includes HOMEPAGE, '<div class="footer-version">v0.15.1</div>'
    assert_includes File.read(File.join(ROOT, '_includes/nav_footer_custom.html')), 'v0.15.1'
  end
end
