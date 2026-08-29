# frozen_string_literal: true

require 'minitest/autorun'
require 'date'
require 'yaml'
require_relative 'show_date_status'

class HomepageTrustTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)
  HOMEPAGE = File.read(File.join(ROOT, '_layouts/homepage.html'))
  SHOW_LAYOUT = File.read(File.join(ROOT, '_layouts/show.html'))
  CITY_LAYOUT = File.read(File.join(ROOT, '_layouts/city.html'))
  STATE_LAYOUT = File.read(File.join(ROOT, '_layouts/state.html'))
  STATE_TAX_LAYOUT = File.read(File.join(ROOT, '_layouts/state-tax.html'))
  SALES_TAX_INDEX = File.read(File.join(ROOT, 'tools/sales-tax-guide/index.md'))
  SUBMIT_SHOW = File.read(File.join(ROOT, 'submit-show.md'))
  CONTACT_PAGE = File.read(File.join(ROOT, 'contact/index.md'))
  DEALERS_PAGE = File.read(File.join(ROOT, 'dealers/index.md'))
  HEAD_CUSTOM = File.read(File.join(ROOT, '_includes/head_custom.html'))
  PORTAL_PAGE = File.read(File.join(ROOT, 'portal/index.md'))
  FORM_BRIDGE = File.read(File.join(ROOT, '_includes/form_capture_bridge.html'))
  FOOTER_CUSTOM = File.read(File.join(ROOT, '_includes/footer_custom.html'))
  LISTING_REVIEW_FORM = File.read(File.join(ROOT, '_includes/show-listing-review-form.html'))
  SHOW_CARD = File.read(File.join(ROOT, '_includes/show-card.html'))
  SHOW_DATE_SCRIPT = File.read(File.join(ROOT, '_includes/show-date-status.js'))
  SCHEMA_EVENT = File.read(File.join(ROOT, '_includes/schema-event.html'))
  WEEKEND_LAYOUT = File.read(File.join(ROOT, '_layouts/weekend.html'))
  MAJOR_SHOWS = File.read(File.join(ROOT, 'major-shows/index.md'))
  WIDGET = File.read(File.join(ROOT, 'widget.html'))
  EMBED_GENERATOR = File.read(File.join(ROOT, 'embed-generator.html'))
  MELT_CALCULATOR = File.read(File.join(ROOT, 'tools/melt-value-calculator.md'))
  COLLECTION_TRACKER = File.read(File.join(ROOT, 'tools/collection-tracker.md'))
  SHOW_SHARE = File.read(File.join(ROOT, '_includes/show-share.html'))
  PRIVACY_POLICY = File.read(File.join(ROOT, 'legal/privacy-policy.md'))
  TERMS_OF_USE = File.read(File.join(ROOT, 'legal/terms-of-use.md'))
  DISCLAIMER = File.read(File.join(ROOT, 'legal/disclaimer.md'))
  REVIEW_TEST_PAGE = File.read(File.join(ROOT, 'review-test-show.md'))
  REVIEW_SHOW = YAML.load_file(File.join(ROOT, '_data/review_show.yml'))
  SHOWS = YAML.load_file(File.join(ROOT, '_data/shows.yml'))
  STATE_TAX = YAML.load_file(File.join(ROOT, '_data/state_tax.yml'))
  CONFIG = YAML.load_file(File.join(ROOT, '_config.yml'))
  AS_OF = Date.new(2026, 8, 24)

  def date_status(show)
    ShowDateStatus.classification(show, as_of: AS_OF)
  end

  def test_every_show_receives_one_plain_language_date_status
    statuses = SHOWS.map { |show| date_status(show) }

    refute_empty statuses
    assert_equal SHOWS.length, statuses.length
    assert_equal statuses.length, statuses.count { |status| %i[scheduled date_not_confirmed past_date_unconfirmed past_show].include?(status) }
    assert_includes statuses, :scheduled
    assert_includes statuses, :date_not_confirmed
    assert_includes statuses, :past_date_unconfirmed
    refute_includes statuses, :past_show
  end

  def test_month_only_dates_are_not_confirmed_not_scheduled
    partial_ids = SHOWS.select { |show| ShowDateParser.partial_date?(show.fetch('next_date')) }.map { |show| show['id'] }

    assert_equal %w[cheyenne-coin-expo hawaii-state-numismatic-association-show], partial_ids.sort
    partial_ids.each do |show_id|
      show = SHOWS.find { |entry| entry.fetch('id') == show_id }
      assert_equal :date_not_confirmed, date_status(show)
    end
  end

  def test_past_specific_dates_use_recurring_unconfirmed_status
    expired_ids = SHOWS.select { |show| date_status(show) == :past_date_unconfirmed }.map { |show| show['id'] }

    assert_equal %w[
      3rd-sunday-columbus-coin-show
      apnscc-coin-show-sat-july-18th-9am-6pm-sun-july-19th-9am-4pm
      boeing-employees-coin-club-show
      first-annual-lansing-coin-show
      greater-johnstown-coin-club-show
      low-country-coin-club-show
      missouri-numismatic-society-annual-coin-show
      san-francisco-coin-show
      tallahassee-coin-club-two-day-show
      valley-coin-show
      wny-coin-show-meetings-4th-sunday-each-month
    ], expired_ids.sort
  end

  def test_all_public_show_surfaces_use_confirmed_date_ranges
    assert_includes HOMEPAGE, '{% include show-date-status.js %}'
    assert_includes HEAD_CUSTOM, '{% include show-date-status.js %}'
    [HOMEPAGE, SHOW_LAYOUT, SHOW_CARD, LISTING_REVIEW_FORM, MAJOR_SHOWS].each do |surface|
      assert_includes surface, 'data-show-date-record'
    end
    assert_includes WEEKEND_LAYOUT, 'firstShowDateRangeOverlapping'
    assert_includes WEEKEND_LAYOUT, 'firstShowWeekendRangeBetween'
    refute_includes WEEKEND_LAYOUT, 'show.next_date'
    assert_includes WIDGET, 'classifyShowDates(show.upcoming_dates'
    refute_includes WIDGET, 'show.next_date &&'
    assert_includes SCHEMA_EVENT, 'include.show.upcoming_dates'
    refute_includes SCHEMA_EVENT, 'include.show.next_date'
    assert_includes SHOW_DATE_SCRIPT, "'Past date — next date unconfirmed'"
    assert_includes SHOW_DATE_SCRIPT, "label: 'Date not confirmed'"
    [HOMEPAGE, SHOW_LAYOUT].each do |surface|
      refute_includes surface, 'Expired date'
      refute_includes surface, 'Partial date'
      refute_includes surface, 'Date TBD'
    end
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
    refute CONFIG.fetch('search_enabled'), 'unused theme search must stay disabled; homepage search is custom'
  end

  def test_internal_working_documents_are_excluded_from_public_builds
    required_exclusions = %w[DESIGN.md SESSION-STATE.md docs/ inbox/ prompts/ todo/]

    assert_equal [], required_exclusions - CONFIG.fetch('exclude')
  end

  def test_homepage_reminder_interest_collects_preferences_without_phone_or_sms
    assert_includes HOMEPAGE, 'id="notify-form"'
    assert_includes HOMEPAGE, 'name="first_name"'
    assert_includes HOMEPAGE, 'name="last_name"'
    assert_includes HOMEPAGE, 'name="preferredState"'
    assert_includes HOMEPAGE, 'name="interested_shows_locations"'
    assert_includes HOMEPAGE, 'name="contactConsent"'
    assert_includes HOMEPAGE, 'name="first_name" aria-label="First name"'
    assert_includes HOMEPAGE, 'name="preferredState" aria-label="State"'
    assert_includes HOMEPAGE, 'Notify me when show reminders become available. No reminder service is active yet. <a href="/legal/privacy-policy/">Privacy Policy</a>.'
    refute_includes HOMEPAGE, 'name="phone"'
    refute_includes HOMEPAGE, 'name="sms_consent"'
    refute_includes HOMEPAGE, 'name="showReminderOptIn"'
    refute_includes HOMEPAGE, 'smsConsentTimestamp'
  end

  def test_show_reminder_interest_does_not_collect_phone_or_promise_delivery
    assert_includes SHOW_LAYOUT, 'id="show-reminder-form"'
    assert_includes SHOW_LAYOUT, 'name="email" aria-label="Email address"'
    assert_includes SHOW_LAYOUT, 'Notify me when show reminders become available. No reminder service is active yet. <a href="/legal/privacy-policy/"'
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

  def test_collection_tracker_survey_is_low_friction_and_review_safe
    assert_match(/\{% if site\.review_mode %\}[\s\S]*id="tracker-feature-survey"[\s\S]*\{% endif %\}/, COLLECTION_TRACKER)
    assert_includes COLLECTION_TRACKER, 'id="tracker-feature-survey"'
    assert_includes COLLECTION_TRACKER, 'name="tracking_method"'
    assert_includes COLLECTION_TRACKER, 'name="priority_feature"'
    assert_includes COLLECTION_TRACKER, 'name="feature_message" maxlength="500"'
    assert_includes COLLECTION_TRACKER, 'Name (optional)'
    assert_includes COLLECTION_TRACKER, 'Email (optional, only if you want a reply)'
    assert_includes COLLECTION_TRACKER, 'This does not join a reminder or marketing list.'
    assert_includes COLLECTION_TRACKER, 'var localReviewMode = {% if site.review_mode %}true{% else %}false{% endif %};'
    assert_includes COLLECTION_TRACKER, 'this form sends nowhere and stores nothing remotely.'
    assert_includes COLLECTION_TRACKER, 'Local review complete — nothing was sent or saved.'
    refute_includes COLLECTION_TRACKER, 'type="file"'
    refute_includes COLLECTION_TRACKER, 'name="phone"'
    assert_includes PRIVACY_POLICY, '**Feature-research surveys (inactive):**'
    assert_includes PRIVACY_POLICY, 'Collection Tracker feature-survey responses because those services are not active'
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

  def test_show_pages_offer_canonical_accessible_sharing
    assert_includes SHOW_LAYOUT, '{% include show-share.html show=show %}'
    assert_includes SHOW_SHARE, 'Collector share kit'
    assert_includes SHOW_SHARE, 'Pass this show along'
    assert_includes SHOW_SHARE, 'navigator.share'
    assert_includes SHOW_SHARE, 'navigator.clipboard.writeText(value)'
    assert_includes SHOW_SHARE, "copyValue(shareUrl, 'Link copied.'"
    assert_includes SHOW_SHARE, 'link[rel="canonical"]'
    assert_includes SHOW_SHARE, 'https://www.facebook.com/sharer/sharer.php?u='
    assert_includes SHOW_SHARE, 'https://x.com/intent/tweet?text='
    assert_includes SHOW_SHARE, 'mailto:?subject='
    %w[Instagram TikTok Snapchat Whatnot YouTube].each do |platform|
      assert_includes SHOW_SHARE, %(data-platform="#{platform}")
    end
    assert_includes SHOW_SHARE, 'ready-to-paste caption'
    assert_includes SHOW_SHARE, 'aria-live="polite"'
  end

  def test_state_pages_link_tax_summaries_to_primary_source_guides
    california = STATE_TAX.find { |entry| entry.fetch('abbrev') == 'CA' }

    assert_includes STATE_LAYOUT, 'Coin and bullion sales tax in {{ page.state_name }}'
    assert_includes STATE_LAYOUT, '/tools/sales-tax-guide/{{ state_tax.slug }}/'
    assert_includes STATE_LAYOUT, 'General information only.'
    assert_includes STATE_TAX_LAYOUT, '{{ tax.tax_authority_url }}'
    assert_equal 'https://cdtfa.ca.gov/lawguides/vol1/sutr/1599.html', california.fetch('tax_authority_url')
    assert_includes california.fetch('notes'), 'at least $2,000'
    refute_includes california.fetch('details'), 'avoids the tax'
  end

  def test_organizer_workflows_require_manual_review
    assert_includes LISTING_REVIEW_FORM, '<option value="organizerVerification">'
    assert_includes LISTING_REVIEW_FORM, 'Submitted changes, claims, verification, and removal requests are reviewed manually.'
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
    assert_includes DEALERS_PAGE, 'data-dealer-claim-trigger'
    assert_includes DEALERS_PAGE, 'id="dealer-claim-form"'
    assert_includes DEALERS_PAGE, 'Request Manual Claim Review'
    assert_includes DEALERS_PAGE, 'claiming and verification are separate manual decisions'
    assert_includes DEALERS_PAGE, 'payment or promotion cannot affect the decision'
    assert_includes DEALERS_PAGE, 'nothing publishes automatically'
    assert_includes DEALERS_PAGE, 'dealer.public_contacts.publication_basis'
    assert_includes DEALERS_PAGE, 'public_contact_basis == "voluntarily_submitted" or public_contact_basis == "source_verified"'
    assert_includes DEALERS_PAGE, 'Private contact email <span>(not published)</span>'
    assert_includes DEALERS_PAGE, 'educational metal-content estimate, not a guaranteed minimum price'
    assert_includes DEALERS_PAGE, 'href="#dealer-listing-form"'
    refute_includes DEALERS_PAGE, 'href="{{ dealer.website }}"'
    refute_includes DEALERS_PAGE, 'Get matched with attendees'
    refute_includes DEALERS_PAGE, 'as your price floor'
    refute_includes DEALERS_PAGE, 'Contact Us to Be Listed'
  end

  def test_show_management_uses_one_prefilled_review_workflow
    assert_includes SHOW_LAYOUT, '{% include show-listing-review-form.html show=show review_fixture=page.review_fixture %}'
    assert_includes SHOW_LAYOUT, 'data-listing-review-trigger'
    assert_includes LISTING_REVIEW_FORM, 'id="listing-review-form"'
    assert_includes LISTING_REVIEW_FORM, '<span class="listing-review-title">Review or update this listing.</span>'
    assert_includes LISTING_REVIEW_FORM, 'Expand the form to confirm details, submit a correction, request a manual claim or verification review, or request removal.'
    assert_includes LISTING_REVIEW_FORM, 'Expand the full review form'
    assert_includes LISTING_REVIEW_FORM, 'Collapse the full review form'
    assert_includes LISTING_REVIEW_FORM, 'Correct as shown'
    assert_includes LISTING_REVIEW_FORM, 'data-confirm-target="review-show-name"'
    assert_includes LISTING_REVIEW_FORM, '<option value="correction">'
    assert_includes LISTING_REVIEW_FORM, '<option value="claimListing">'
    assert_includes LISTING_REVIEW_FORM, '<option value="organizerVerification">'
    assert_includes LISTING_REVIEW_FORM, '<option value="reviewRemoval">'
    assert_includes LISTING_REVIEW_FORM, '<option value="dealerAtShow">'
    assert_includes LISTING_REVIEW_FORM, 'name="confirmation_source_type"'
    assert_includes LISTING_REVIEW_FORM, 'Organizer verified</strong> is reserved'
    assert_includes LISTING_REVIEW_FORM, 'Venue confirmed</em>, <em>Dealer reported</em>, or <em>Community reported</em>'
    assert_includes LISTING_REVIEW_FORM, 'relationshipField.setCustomValidity'
    assert_includes LISTING_REVIEW_FORM, 'name="proposed_street_address"'
    assert_includes LISTING_REVIEW_FORM, 'name="proposed_notes"'
    assert_includes LISTING_REVIEW_FORM, 'Ask us to verify my organizer or representative role'
    assert_includes LISTING_REVIEW_FORM, 'Choosing this request does not verify the listing automatically.'
    assert_includes LISTING_REVIEW_FORM, 'type="date" name="proposed_start_date"'
    assert_includes LISTING_REVIEW_FORM, 'type="date" name="proposed_end_date"'
    assert_includes LISTING_REVIEW_FORM, 'name="proposed_date_tbd"'
    assert_includes LISTING_REVIEW_FORM, 'name="proposed_next_date"'
    assert_includes LISTING_REVIEW_FORM, 'The end date cannot be before the start date.'
  end

  def test_seller_ctas_are_educational_until_dealer_offers_exist
    [SHOW_LAYOUT, CITY_LAYOUT].each do |layout|
      assert_includes layout, "Know Your Junk Silver's Melt Value"
      assert_includes layout, 'This site does not request dealer offers yet.'
      assert_includes layout, 'Calculate Junk Silver Melt Value'
      refute_includes layout, 'Get Dealer Quotes Before the Show'
      refute_includes layout, 'Get Offers on Your Coins'
    end
    assert_includes WIDGET, 'No offer request is active.'
    assert_includes WIDGET, 'Calculate Junk Silver Melt Value'
    refute_includes WIDGET, 'id="csw-lead-form"'
    refute_includes WIDGET, 'dealerEmail'
    refute_includes WIDGET, 'mailto:'
    refute_includes EMBED_GENERATOR, 'eg-dealer-email'
    refute_includes EMBED_GENERATOR, 'dealerEmail'
    assert_includes MELT_CALCULATOR, 'This calculator does not collect your contact information or request dealer offers.'
    assert_includes MELT_CALCULATOR, 'not a guaranteed price floor'
    refute_includes MELT_CALCULATOR, 'id="offer-form"'
    refute_includes MELT_CALCULATOR, 'sellerOfferRequest'
    assert_includes PORTAL_PAGE, 'No dealer portal, account system, collection upload, offer request, or portal notification service is active.'
    refute_includes PORTAL_PAGE, 'id="portal-form"'
    refute_includes PORTAL_PAGE, 'sellerOfferRequest'
    assert_includes PRIVACY_POLICY, 'We do not currently operate a pre-show offer system'
    assert_includes TERMS_OF_USE, 'The Platform does not accept seller collection submissions'
    assert_includes DISCLAIMER, 'We do not operate an offer marketplace'
    assert_includes DEALERS_PAGE, 'id="dealer-search" aria-label="Search dealers"'
    assert_includes WIDGET, 'for="csw-state-filter"'
    assert_includes WIDGET, 'for="csw-zip-filter"'
  end

  def test_melt_calculator_supports_named_us_bullion_and_all_four_metals
    assert_includes MELT_CALCULATOR, 'browse the dealer directory'
    assert_includes MELT_CALCULATOR, 'Walking Liberty / Franklin / Kennedy Half Dollars'
    assert_includes MELT_CALCULATOR, 'American Silver Eagle (ASE) $1'
    assert_includes MELT_CALCULATOR, 'American Gold Eagle $50 (1 oz fine gold)'
    assert_includes MELT_CALCULATOR, 'American Buffalo Gold Bullion Coin $50'
    assert_includes MELT_CALCULATOR, 'id="spot-platinum"'
    assert_includes MELT_CALCULATOR, 'id="spot-palladium"'
    assert_includes MELT_CALCULATOR, 'id="tab-us-platinum-palladium"'
    assert_includes MELT_CALCULATOR, "metal: 'platinum'"
    assert_includes MELT_CALCULATOR, "metal: 'palladium'"
    assert_includes MELT_CALCULATOR, "platinum: getVal('spot-platinum')"
    assert_includes MELT_CALCULATOR, "palladium: getVal('spot-palladium')"
    assert_includes MELT_CALCULATOR, '| Coin / established name | Common shorthand | Face value |'
    assert_includes MELT_CALCULATOR, '| American Gold Eagle, 1/2 oz | AGE | $25 |'
    assert_includes MELT_CALCULATOR, '| American Eagle Platinum Bullion Coin, 1 oz | <span data-review-note-anchor="owner-review-note-6">APE</span> | $100 |'
    assert_includes MELT_CALCULATOR, '| American Palladium Eagle | Palladium Eagle | $25 |'
    assert_includes MELT_CALCULATOR, 'The established platinum coin name appears in the first column; APE is its shorthand.'
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
    assert_includes LISTING_REVIEW_FORM, 'Local test completed — nothing was sent or saved.'
    assert_includes LISTING_REVIEW_FORM, 'This preview did not contact Formspree or EspoCRM.'
    assert_includes LISTING_REVIEW_FORM, 'Fields marked for change'
  end

  def test_listing_removal_is_manual_and_privacy_documented
    assert_includes LISTING_REVIEW_FORM, '<option value="reviewRemoval">'
    assert_includes LISTING_REVIEW_FORM, 'Changes, verification, and removal requests are reviewed manually and are not guaranteed.'
    assert_includes PRIVACY_POLICY, 'Public Event Information and Removal Requests'
    assert_includes PRIVACY_POLICY, 'They are not automatically removed merely because a request is submitted.'
  end

  def test_unchecked_tax_claims_are_suppressed_and_filterable
    assert_equal 51, STATE_TAX.length
    assert_includes STATE_TAX_LAYOUT, 'Review pending'
    assert_includes SALES_TAX_INDEX, '**Review pending** means'
    assert_includes STATE_LAYOUT, 'exact primary-source review'
    assert_includes SALES_TAX_INDEX, 'data-filter="pending"'
    assert_includes SALES_TAX_INDEX, '{% unless tax.source_checked %}pending'

    alabama = STATE_TAX.find { |tax| tax.fetch('abbrev') == 'AL' }
    refute alabama.key?('source_checked')
  end

  def test_primary_source_tax_corrections_are_recorded
    kentucky = STATE_TAX.find { |tax| tax.fetch('abbrev') == 'KY' }
    minnesota = STATE_TAX.find { |tax| tax.fetch('abbrev') == 'MN' }
    nevada = STATE_TAX.find { |tax| tax.fetch('abbrev') == 'NV' }
    new_jersey = STATE_TAX.find { |tax| tax.fetch('abbrev') == 'NJ' }
    virginia = STATE_TAX.find { |tax| tax.fetch('abbrev') == 'VA' }
    washington = STATE_TAX.find { |tax| tax.fetch('abbrev') == 'WA' }
    wisconsin = STATE_TAX.find { |tax| tax.fetch('abbrev') == 'WI' }

    assert kentucky.fetch('bullion_exempt')
    assert_equal 'August 1, 2024', kentucky.fetch('effective_date')
    refute minnesota.fetch('coins_exempt')
    refute nevada.fetch('bullion_exempt')
    assert_equal 'Category-specific', new_jersey.fetch('threshold')
    refute virginia.fetch('bullion_exempt')
    refute washington.fetch('bullion_exempt')
    assert_equal 'March 23, 2024', wisconsin.fetch('effective_date')

    [kentucky, minnesota, nevada, new_jersey, virginia, washington, wisconsin].each do |tax|
      assert_equal 'August 1, 2026', tax.fetch('source_checked')
      assert_match(%r{\Ahttps?://}, tax.fetch('tax_authority_url'))
    end
  end

  def test_visible_version_is_current
    assert_includes HOMEPAGE, '<div class="footer-version">v0.17.0</div>'
    assert_includes FOOTER_CUSTOM, '<div class="page-footer-version">v0.17.0</div>'
  end
end
