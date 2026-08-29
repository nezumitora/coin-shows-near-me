---
layout: default
title: "Find a Dealer"
description: "Find coin and precious metals dealers, including local shops, online bullion sellers, and auction houses. Search by location or specialty."
permalink: /dealers/
nav_order: 7
has_children: true
breadcrumb_current: "Find a Dealer"
---

# Find a Coin Dealer

Browse listed coin dealers, bullion sellers, and auction houses. Search by name, location, or filter by type. Public contact details appear only after voluntary submission or source verification.

**Listing labels:** `Claimed` means a representative's relationship to the business passed manual review. `Verified` means the displayed public business details were independently checked against an approved source. Claiming never guarantees verification, and payment or promotion never affects either review.

<aside id="dealer-top-cta" aria-labelledby="dealer-top-cta-title" style="display:flex;align-items:center;justify-content:space-between;gap:1rem;flex-wrap:wrap;background:#fff7e6;border:1px solid #daa520;border-radius:10px;padding:0.85rem 1rem;margin:0 0 1.25rem;">
  <div style="flex:1;min-width:220px;">
    <h2 id="dealer-top-cta-title" style="margin:0 0 0.2rem !important;font-size:1rem !important;color:#1a2332;">Are you a coin dealer?</h2>
    <p style="margin:0;color:#555;font-size:0.88rem;line-height:1.45;">Request a free directory listing for manual review. Approved public business details can help collectors find you.</p>
  </div>
  <a href="#dealer-listing-form" class="dealer-listing-button" style="display:inline-block;background:#b8860b;color:#fff;padding:0.55rem 1rem;border-radius:6px;font-size:0.88rem;font-weight:800;text-decoration:none;white-space:nowrap;">Get Added to the Directory</a>
</aside>

<div class="dealer-feature-grid" style="margin:0 0 1.25rem;">
  <div class="dealer-feature-card">
    <h2 style="margin-top:0 !important;">For Collectors</h2>
    <p>Compare dealer types, specialties, and locations before you buy or sell. Coin shows are still one of the easiest ways to get multiple opinions in one room.</p>
  </div>
  <div class="dealer-feature-card">
    <h2 style="margin-top:0 !important;">For Dealers</h2>
    <p>Want to be included? Submit a listing for manual review. Existing records include a separate claim link for authorized representatives.</p>
  </div>
</div>

<div class="dealer-search-panel" style="margin:1rem 0 1.25rem;">
<div style="margin:0 0 1rem;">
  <input type="text" id="dealer-search" aria-label="Search dealers" placeholder="Search by dealer name, city, or state..." style="box-sizing:border-box;width:100%;max-width:500px;padding:0.75rem 1rem;border:2px solid #e5ddd0;border-radius:8px;font-size:1rem;outline:none;" onfocus="this.style.borderColor='#b8860b'" onblur="this.style.borderColor='#e5ddd0'">
</div>

<div style="display:flex;gap:0.5rem;margin-bottom:1rem;flex-wrap:wrap;">
  <button class="dealer-filter-btn active" data-filter="all" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#1a2332;color:#fff;font-weight:600;">All Dealers</button>
  <button class="dealer-filter-btn" data-filter="brick-and-mortar" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#fff;color:#555;">Brick & Mortar</button>
  <button class="dealer-filter-btn" data-filter="online" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#fff;color:#555;">Online</button>
  <button class="dealer-filter-btn" data-filter="both" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#fff;color:#555;">Online + Storefront</button>
</div>

<div style="margin-bottom:1rem;font-size:0.9rem;color:#555;" id="dealer-results-count">Showing all dealers</div>
</div>

<div id="dealer-grid">
{% for dealer in site.data.dealers %}
{% assign dealer_id = dealer.id | default: dealer.name | slugify %}
{% assign public_contact_basis = dealer.public_contacts.publication_basis | default: "" %}
{% assign publish_public_contacts = false %}
{% if public_contact_basis == "voluntarily_submitted" or public_contact_basis == "source_verified" %}{% assign publish_public_contacts = true %}{% endif %}
<div class="dealer-card-item" data-name="{{ dealer.name | downcase }}" data-city="{{ dealer.city | downcase }}" data-state="{{ dealer.state_name | downcase }}" data-state-abbrev="{{ dealer.state | downcase }}" data-type="{{ dealer.type }}" style="border:1px solid #e5ddd0;border-radius:10px;padding:1.25rem;margin-bottom:0.75rem;background:#fff;transition:all 0.2s;">
  <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:0.5rem;flex-wrap:wrap;gap:0.5rem;">
    <div>
      {% if publish_public_contacts and dealer.public_contacts.website %}<a href="{{ dealer.public_contacts.website }}" target="_blank" rel="noopener noreferrer" style="font-size:1.1rem;font-weight:700;color:#2c2c2c;text-decoration:none;">{{ dealer.name }}</a>{% else %}<span style="font-size:1.1rem;font-weight:700;color:#2c2c2c;">{{ dealer.name }}</span>{% endif %}
      <span style="display:inline-block;margin-left:0.5rem;font-size:0.7rem;font-weight:700;padding:0.15rem 0.5rem;border-radius:4px;vertical-align:middle;{% if dealer.type == 'online' %}background:#e0f2fe;color:#0369a1;{% elsif dealer.type == 'brick-and-mortar' %}background:#fef3c7;color:#92400e;{% else %}background:#f0fdf4;color:#166534;{% endif %}">
        {% if dealer.type == 'online' %}ONLINE{% elsif dealer.type == 'brick-and-mortar' %}LOCAL SHOP{% else %}ONLINE + LOCAL{% endif %}
      </span>
      {% if dealer.claim_status == "claimed" %}<span class="dealer-status-badge dealer-status-badge--claimed">Claimed</span>{% elsif dealer.claim_status == "verified" %}<span class="dealer-status-badge dealer-status-badge--verified">Verified</span>{% endif %}
    </div>
    {% if dealer.accepts_trade_ins %}
    <span style="font-size:0.7rem;font-weight:600;color:#16a34a;background:#dcfce7;padding:0.15rem 0.5rem;border-radius:4px;">BUYS COINS</span>
    {% endif %}
  </div>
  <div style="font-size:0.85rem;color:#555;margin-bottom:0.5rem;">{{ dealer.city }}, {{ dealer.state_name }}</div>
  <p style="font-size:0.88rem;color:#555;line-height:1.6;margin:0 0 0.75rem;">{{ dealer.description }}</p>
  {% if publish_public_contacts %}
  <div class="dealer-contact-list">
    {% if dealer.public_contacts.street_address %}<span><strong>Public business address:</strong> {{ dealer.public_contacts.street_address }}{% if dealer.public_contacts.city %}, {{ dealer.public_contacts.city }}{% endif %}{% if dealer.public_contacts.state %}, {{ dealer.public_contacts.state }}{% endif %}{% if dealer.public_contacts.postal_code %} {{ dealer.public_contacts.postal_code }}{% endif %}</span>{% endif %}
    {% if dealer.public_contacts.phone %}<span><strong>Public phone:</strong> <a href="tel:{{ dealer.public_contacts.phone | replace: ' ', '' | replace: '(', '' | replace: ')', '' | replace: '-', '' }}">{{ dealer.public_contacts.phone }}</a></span>{% endif %}
  </div>
  {% endif %}
  <div style="display:flex;flex-wrap:wrap;gap:0.4rem;margin-bottom:0.75rem;">
    {% for spec in dealer.specialties %}
    <span style="font-size:0.75rem;padding:0.2rem 0.6rem;border-radius:4px;background:#f5f0e8;color:#555;">{{ spec }}</span>
    {% endfor %}
  </div>
  <div style="display:flex;gap:0.75rem;align-items:center;flex-wrap:wrap;">
    {% if publish_public_contacts and dealer.public_contacts.website %}<a href="{{ dealer.public_contacts.website }}" target="_blank" rel="noopener noreferrer" style="font-size:0.85rem;font-weight:600;color:#b8860b;text-decoration:none;">Visit Website &rarr;</a>{% endif %}
    {% if publish_public_contacts and dealer.public_contacts.instagram %}<a href="{{ dealer.public_contacts.instagram }}" target="_blank" rel="noopener noreferrer" style="font-size:0.85rem;font-weight:600;color:#b8860b;text-decoration:none;">Instagram</a>{% endif %}
    {% if publish_public_contacts and dealer.public_contacts.facebook %}<a href="{{ dealer.public_contacts.facebook }}" target="_blank" rel="noopener noreferrer" style="font-size:0.85rem;font-weight:600;color:#b8860b;text-decoration:none;">Facebook</a>{% endif %}
    {% if publish_public_contacts and dealer.public_contacts.youtube %}<a href="{{ dealer.public_contacts.youtube }}" target="_blank" rel="noopener noreferrer" style="font-size:0.85rem;font-weight:600;color:#b8860b;text-decoration:none;">YouTube</a>{% endif %}
    {% if publish_public_contacts and dealer.public_contacts.x %}<a href="{{ dealer.public_contacts.x }}" target="_blank" rel="noopener noreferrer" style="font-size:0.85rem;font-weight:600;color:#b8860b;text-decoration:none;">X</a>{% endif %}
    {% if dealer.ships_nationwide %}
    <span style="font-size:0.75rem;color:#888;">Ships nationwide</span>
    {% endif %}
    <a href="#dealer-claim" class="dealer-claim-link" data-dealer-claim-trigger data-dealer-id="{{ dealer_id }}" data-dealer-name="{{ dealer.name | escape }}">Claim this listing</a>
  </div>
</div>
{% endfor %}
</div>

<section id="dealer-claim" class="public-cta" aria-labelledby="dealer-claim-title" style="margin:1.5rem 0;scroll-margin-top:6rem;">
   <h2 id="dealer-claim-title" style="color:#daa520;margin-top:0 !important;">Claim this listing</h2>
   <p style="color:#cbd5e1;">A business owner or authorized representative may request a manual ownership review. A claim does not verify every listing detail, payment or promotion cannot affect the decision, and submitted changes never publish automatically.</p>
   <p style="color:#94a3b8;font-size:0.85rem;">Use a business-domain email and an official public source when possible. Do not send passwords, identity documents, private home addresses, or other sensitive personal information.</p>
   <p id="dealer-claim-selection" role="status" aria-live="polite" style="color:#fef3c7;font-weight:700;">Select Claim this listing on a dealer card to prefill that exact record.</p>
  <form id="dealer-claim-form" class="dealer-listing-form" action="#" data-form-key="mykleozw" method="POST" novalidate>
    <input type="hidden" name="_subject" value="[Coin Show Near Me][Dealer Claim] Manual ownership review request">
    <input type="hidden" name="form_type" value="dealer_listing_claim">
    <input type="hidden" name="source" value="Website">
    <input type="hidden" name="formName" value="dealerListingClaim">
    <input type="hidden" name="coinContactRoles" value="dealerVendor">
    <input type="hidden" name="ctaCode" value="dealer_directory_claim">
    <input type="hidden" name="sourceDetail" value="Find a Coin Dealer listing claim form">
    <input type="hidden" name="dealer_id" value="">
    <input type="hidden" name="pageUrl" value="">
    <input type="hidden" name="referringUrl" value="">
    <input type="hidden" name="submittedAt" value="">
    <input type="hidden" name="contactConsentTimestamp" value="">
    <input type="hidden" name="contactConsentVersion" value="coin-dealer-claim-consent-v1">
    <input type="hidden" name="contactConsentText" value="Contact me to review this dealer listing claim. Claims and proposed changes are manually reviewed and never publish automatically.">
    <div class="dealer-listing-grid">
      <label class="dealer-listing-wide">Dealer or business listing<input type="text" name="dealer_name" required></label>
      <label>First name<input type="text" name="first_name" autocomplete="given-name" required></label>
      <label>Last name<input type="text" name="last_name" autocomplete="family-name" required></label>
      <label>Private contact email <span>(not published)</span><input type="email" name="email" autocomplete="email" required></label>
      <label>Your role
        <select name="claimant_role" required>
          <option value="">Select role</option>
          <option value="owner">Business owner</option>
          <option value="authorizedEmployee">Authorized employee</option>
          <option value="authorizedAgent">Authorized representative</option>
        </select>
      </label>
      <label class="dealer-listing-wide">Official public business or organization URL<input type="url" name="official_source_url" placeholder="www.example.com/contact" required></label>
      <label class="dealer-listing-wide">How can we confirm your relationship?<textarea name="claim_evidence" placeholder="Describe the public business evidence we should check. Do not include passwords or identity documents." required></textarea></label>
    </div>
    <label class="mobile-consent-label dealer-listing-consent">
      <input type="checkbox" name="contactConsent" value="yes" required>
      <span>Contact me to review this claim. I understand that claiming and verification are separate manual decisions, promotion does not affect them, and no submitted change publishes automatically. See our <a href="/legal/privacy-policy/">Privacy Policy</a>.</span>
    </label>
    <button type="submit" class="dealer-listing-submit">Request Manual Claim Review</button>
  </form>
  <div id="dealer-claim-success" role="status" tabindex="-1" style="display:none;background:#065f46;color:#fff;padding:0.85rem;border-radius:6px;margin-top:0.75rem;">
    Thank you — the claim was recorded for manual ownership review. The listing has not changed.
  </div>
</section>

{% include ad-placeholder.html %}

<div id="dealer-no-results" style="display:none;text-align:center;padding:2rem;color:#888;">
  <p>No dealers match your search.</p>
</div>

---

## Are You a Dealer?

<div class="public-cta" id="dealer-listing-cta" style="margin:1.5rem 0;scroll-margin-top:6rem;">
  <h3 style="color:#daa520;font-size:1.2rem;font-weight:700;margin:0 0 0.5rem;">Get Listed in Our Directory</h3>
  <p style="color:#cbd5e1;font-size:0.92rem;line-height:1.6;margin:0 0 1rem;">Submit your details here for manual review. You will not be sent to another page, and submitting does not automatically publish or verify a listing.</p>
  <ul style="list-style:none;padding:0;margin:0 0 1.25rem;">
    <li style="color:#94a3b8;font-size:0.85rem;padding:0.25rem 0;padding-left:1.25rem;position:relative;"><span style="position:absolute;left:0;color:#daa520;font-weight:700;">&#10003;</span> Free listing in our dealer directory</li>
    <li style="color:#94a3b8;font-size:0.85rem;padding:0.25rem 0;padding-left:1.25rem;position:relative;"><span style="position:absolute;left:0;color:#daa520;font-weight:700;">&#10003;</span> Present an approved business location, dealer type, and specialties</li>
    <li style="color:#94a3b8;font-size:0.85rem;padding:0.25rem 0;padding-left:1.25rem;position:relative;"><span style="position:absolute;left:0;color:#daa520;font-weight:700;">&#10003;</span> Propose public business contact details for manual review</li>
    <li style="color:#94a3b8;font-size:0.85rem;padding:0.25rem 0;padding-left:1.25rem;position:relative;"><span style="position:absolute;left:0;color:#daa520;font-weight:700;">&#10003;</span> Link to your website and show your specialties</li>
  </ul>
  <form id="dealer-listing-form" class="dealer-listing-form" action="#" data-form-key="mykleozw" method="POST" novalidate>
    <input type="hidden" name="_subject" value="[Coin Show Near Me][Dealer Listing] Manual review request">
    <input type="hidden" name="form_type" value="dealer_registration">
    <input type="hidden" name="source" value="Website">
    <input type="hidden" name="formName" value="dealerListingRequest">
    <input type="hidden" name="coinContactRoles" value="dealerVendor">
    <input type="hidden" name="ctaCode" value="dealer_directory_listing">
    <input type="hidden" name="sourceDetail" value="Find a Coin Dealer directory listing form">
    <input type="hidden" name="pageUrl" value="">
    <input type="hidden" name="referringUrl" value="">
    <input type="hidden" name="submittedAt" value="">
    <input type="hidden" name="contactConsentTimestamp" value="">
    <input type="hidden" name="contactConsentVersion" value="coin-dealer-listing-consent-v1">
    <input type="hidden" name="contactConsentText" value="Contact me to review the proposed dealer listing. Submission does not guarantee publication, claiming, or verification, and nothing publishes automatically.">
    <div class="dealer-listing-grid">
      <label>First name<input type="text" name="first_name" autocomplete="given-name" required></label>
      <label>Last name<input type="text" name="last_name" autocomplete="family-name" required></label>
      <label>Dealer or business name<input type="text" name="business_name" autocomplete="organization" required></label>
      <label>Private contact email <span>(not published)</span><input type="email" name="email" autocomplete="email" required></label>
      <label>Private review phone <span>(optional; not published)</span><input type="tel" name="phone" autocomplete="tel"></label>
      <label>Proposed public website<input type="url" name="website" placeholder="www.example.com" required></label>
      <fieldset class="dealer-listing-section dealer-listing-wide">
        <legend>Dealer types <span>(select all that apply)</span></legend>
        <div class="dealer-listing-options dealer-type-options">
          <label><input type="checkbox" name="dealer_type_brick_and_mortar" value="yes" data-dealer-type="brick-and-mortar"> Brick-and-mortar shop</label>
          <label><input type="checkbox" name="dealer_type_online" value="yes" data-dealer-type="online"> Online dealer</label>
          <label><input type="checkbox" name="dealer_type_auction_house" value="yes" data-dealer-type="auction-house"> Auction house</label>
          <label><input type="checkbox" name="dealer_type_coin_show" value="yes" data-dealer-type="coin-show"> Coin show dealer</label>
        </div>
      </fieldset>
      <label>Primary city or service area<input type="text" name="city" autocomplete="address-level2" required></label>
      <label>Primary state
        <select name="state" autocomplete="address-level1" required>
          <option value="">Select state</option>
          {% for state in site.data.states %}<option value="{{ state.abbrev }}">{{ state.name }}</option>{% endfor %}
        </select>
      </label>
      <label>Specialties<input type="text" name="specialty" placeholder="US coins, bullion, currency, appraisals" required></label>
      <fieldset id="dealer-physical-address" class="dealer-listing-section dealer-listing-wide" hidden>
        <legend>Physical store address</legend>
        <p>Required when Brick-and-mortar shop is selected.</p>
        <div class="dealer-listing-grid">
          <label class="dealer-listing-wide">Street address<input type="text" name="physical_street_address" autocomplete="street-address"></label>
          <label>Suite or unit <span>(optional)</span><input type="text" name="physical_address_line_2" autocomplete="address-line2"></label>
          <label>City<input type="text" name="physical_city" autocomplete="address-level2"></label>
          <label>State
            <select name="physical_state" autocomplete="address-level1">
              <option value="">Select state</option>
              {% for state in site.data.states %}<option value="{{ state.abbrev }}">{{ state.name }}</option>{% endfor %}
            </select>
          </label>
          <label>ZIP code<input type="text" name="physical_postal_code" autocomplete="postal-code" inputmode="numeric"></label>
        </div>
      </fieldset>
      <fieldset class="dealer-listing-section dealer-listing-wide">
        <legend>Social profiles <span>(optional)</span></legend>
        <p>Use one field per profile so each account can be stored separately.</p>
        <div class="dealer-listing-grid">
          <label>Facebook<input type="url" name="social_facebook_url" placeholder="www.facebook.com/yourdealer"></label>
          <label>Instagram<input type="url" name="social_instagram_url" placeholder="www.instagram.com/yourdealer"></label>
          <label>YouTube<input type="url" name="social_youtube_url" placeholder="www.youtube.com/@yourdealer"></label>
          <label>TikTok<input type="url" name="social_tiktok_url" placeholder="www.tiktok.com/@yourdealer"></label>
          <label>LinkedIn<input type="url" name="social_linkedin_url" placeholder="www.linkedin.com/company/yourdealer"></label>
          <label>X / Twitter<input type="url" name="social_x_url" placeholder="x.com/yourdealer"></label>
          <label class="dealer-listing-wide">Other public profile<input type="url" name="social_other_url" placeholder="www.example.com/your-profile"></label>
        </div>
      </fieldset>
      <label class="dealer-listing-wide">Directory description<textarea name="description" placeholder="Briefly describe what you sell, buy, or specialize in." required></textarea></label>
    </div>
    <div class="dealer-listing-options">
      <label><input type="checkbox" name="accepts_trade_ins" value="yes"> Buys coins or accepts trade-ins</label>
      <label><input type="checkbox" name="ships_nationwide" value="yes"> Ships nationwide</label>
      <label><input type="checkbox" name="publicContactConsent" value="yes" required> The website, social profiles, and physical store address I entered are public business contacts that may be published only after manual review. My review email and phone stay private.</label>
    </div>
    <label class="mobile-consent-label dealer-listing-consent">
      <input type="checkbox" name="contactConsent" value="yes" required>
      <span>Contact me to review the proposed dealer listing. Submission does not guarantee publication, claiming, or verification, and nothing publishes automatically. See our <a href="/legal/privacy-policy/">Privacy Policy</a>.</span>
    </label>
    <button type="submit" class="dealer-listing-submit">Submit Dealer Listing for Review</button>
  </form>
  <div id="dealer-listing-success" role="status" tabindex="-1" style="display:none;background:#065f46;color:#fff;padding:0.85rem;border-radius:6px;margin-top:0.75rem;">
    Thank you — your dealer listing request was recorded for manual review.
  </div>
</div>

## How to Choose a Dealer

Whether you're buying your first silver coin or discussing a collection with a dealer, compare independent information and confirm all terms yourself. Directory inclusion is not an endorsement.

### Buying

- **Compare total cost** — include premiums, shipping, insurance, payment fees, taxes, and return terms.
- **Confirm the item** — ask how authenticity, grade, condition, and any third-party holder were evaluated.
- **Review written policies** — understand returns, shipping, storage, buybacks, and dispute procedures before paying.
- **Use payment safeguards** — understand whether a payment method offers recourse and never share passwords or remote access.
- **Check independent evidence** — compare public business details, references, and reviews from more than one source.

### Selling

- **Compare independent opinions** — ask dealers to explain their evaluation, deductions, fees, and proposed terms.
- **Separate metal and collector value** — use the [Melt Value Calculator](/tools/melt-value-calculator/) as an educational metal-content estimate, not a guaranteed minimum price.
- **Ask about evaluation fees** — confirm whether an appraisal, grading opinion, consignment, or other service has a charge.
- **Protect your property and identity** — keep an inventory, avoid unnecessary personal data, and use safe public meeting practices.
- **Verify before traveling** — [find a show near you](/states/) and confirm event details and dealer attendance independently.

### Red Flags

- Pressure to buy immediately or "limited time" offers
- Refusal to explain pricing, fees, return terms, or payment instructions
- A claimed physical storefront with no verifiable public business address or phone number
- Requests for passwords, remote computer access, gift cards, cryptocurrency, or unusual payment changes
- Social-media accounts that imitate a known dealer but use a new handle, changed payment details, or unverifiable contact information

---

*Know a dealer we should review for the directory? [Submit the dealer for manual review](#dealer-listing-form).*

<script>
/* Dealer search and filter */
(function() {
  var searchInput = document.getElementById('dealer-search');
  var cards = document.querySelectorAll('.dealer-card-item');
  var filterBtns = document.querySelectorAll('.dealer-filter-btn');
  var countEl = document.getElementById('dealer-results-count');
  var noResults = document.getElementById('dealer-no-results');
  var activeFilter = 'all';

  function filterCards() {
    var term = searchInput.value.toLowerCase().trim();
    var visible = 0;
    for (var i = 0; i < cards.length; i++) {
      var card = cards[i];
      var name = card.getAttribute('data-name');
      var city = card.getAttribute('data-city');
      var state = card.getAttribute('data-state');
      var stateAbbrev = card.getAttribute('data-state-abbrev');
      var type = card.getAttribute('data-type');
      var matchSearch = !term || name.indexOf(term) !== -1 || city.indexOf(term) !== -1 || state.indexOf(term) !== -1 || stateAbbrev.indexOf(term) !== -1;
      var matchFilter = activeFilter === 'all' || type === activeFilter;
      if (matchSearch && matchFilter) {
        card.style.display = '';
        visible++;
      } else {
        card.style.display = 'none';
      }
    }
    countEl.textContent = visible === cards.length ? 'Showing all dealers' : 'Showing ' + visible + ' of ' + cards.length + ' dealers';
    noResults.style.display = visible === 0 ? 'block' : 'none';
  }

  searchInput.addEventListener('input', filterCards);

  for (var i = 0; i < filterBtns.length; i++) {
    filterBtns[i].addEventListener('click', function() {
      for (var j = 0; j < filterBtns.length; j++) {
        filterBtns[j].style.background = '#fff';
        filterBtns[j].style.color = '#555';
        filterBtns[j].classList.remove('active');
      }
      this.style.background = '#1a2332';
      this.style.color = '#fff';
      this.classList.add('active');
      activeFilter = this.getAttribute('data-filter');
      filterCards();
    });
  }

  function fillReviewMetadata(form) {
    var now = new Date().toISOString();
    ['pageUrl', 'referringUrl', 'submittedAt', 'contactConsentTimestamp'].forEach(function(name) {
      var field = form.querySelector('[name="' + name + '"]');
      if (!field) { return; }
      field.value = name === 'referringUrl' ? (document.referrer || '') : (name === 'pageUrl' ? window.location.href : now);
    });
  }

  function localReviewMode() {
    return window.location.hostname === '127.0.0.1' || window.location.hostname === 'localhost';
  }

  var claimForm = document.getElementById('dealer-claim-form');
  var claimTriggers = document.querySelectorAll('[data-dealer-claim-trigger]');
  var claimSelection = document.getElementById('dealer-claim-selection');
  for (var claimIndex = 0; claimIndex < claimTriggers.length; claimIndex++) {
    claimTriggers[claimIndex].addEventListener('click', function(event) {
      event.preventDefault();
      if (!claimForm) { return; }
      claimForm.querySelector('[name="dealer_id"]').value = this.getAttribute('data-dealer-id') || '';
      var dealerName = this.getAttribute('data-dealer-name') || '';
      var dealerField = claimForm.querySelector('[name="dealer_name"]');
      dealerField.value = dealerName;
      dealerField.readOnly = true;
      if (claimSelection) { claimSelection.textContent = 'Selected listing: ' + dealerName + '. This claim is a manual review request only.'; }
      window.history.replaceState(null, '', '#dealer-claim');
      claimForm.closest('#dealer-claim').scrollIntoView({ behavior: 'smooth', block: 'start' });
      window.setTimeout(function() { dealerField.focus({ preventScroll: true }); }, 350);
    });
  }

  var dealerForm = document.getElementById('dealer-listing-form');
  if (dealerForm) {
    var dealerTypeBoxes = dealerForm.querySelectorAll('[data-dealer-type]');
    var firstDealerType = dealerTypeBoxes[0];
    var physicalAddress = document.getElementById('dealer-physical-address');
    var physicalAddressFields = physicalAddress.querySelectorAll('[name="physical_street_address"], [name="physical_city"], [name="physical_state"], [name="physical_postal_code"]');

    function updateDealerTypeRequirements() {
      var anyTypeSelected = false;
      var brickAndMortarSelected = false;
      for (var typeIndex = 0; typeIndex < dealerTypeBoxes.length; typeIndex++) {
        if (dealerTypeBoxes[typeIndex].checked) { anyTypeSelected = true; }
        if (dealerTypeBoxes[typeIndex].getAttribute('data-dealer-type') === 'brick-and-mortar' && dealerTypeBoxes[typeIndex].checked) {
          brickAndMortarSelected = true;
        }
      }
      firstDealerType.setCustomValidity(anyTypeSelected ? '' : 'Select at least one dealer type.');
      physicalAddress.hidden = !brickAndMortarSelected;
      for (var addressIndex = 0; addressIndex < physicalAddressFields.length; addressIndex++) {
        physicalAddressFields[addressIndex].required = brickAndMortarSelected;
      }
    }

    for (var typeIndex = 0; typeIndex < dealerTypeBoxes.length; typeIndex++) {
      dealerTypeBoxes[typeIndex].addEventListener('change', updateDealerTypeRequirements);
    }
    updateDealerTypeRequirements();

    dealerForm.noValidate = true;
    dealerForm.addEventListener('submit', function(event) {
      event.preventDefault();
      updateDealerTypeRequirements();
      if (window.coinNormalizeFormUrls) { window.coinNormalizeFormUrls(dealerForm); }
      if (!dealerForm.reportValidity()) { return; }
      fillReviewMetadata(dealerForm);
      function showSuccess() {
        dealerForm.style.display = 'none';
        var success = document.getElementById('dealer-listing-success');
        success.style.display = 'block';
        success.focus();
      }
      if (localReviewMode()) {
        showSuccess();
        return;
      }
      if (window.coinFormSpamCheck && !window.coinFormSpamCheck(dealerForm)) { return; }
      window.coinSubmitForm(dealerForm).then(showSuccess);
    });
  }

  if (claimForm) {
    claimForm.noValidate = true;
    claimForm.addEventListener('submit', function(event) {
      event.preventDefault();
      if (window.coinNormalizeFormUrls) { window.coinNormalizeFormUrls(claimForm); }
      if (!claimForm.reportValidity()) { return; }
      fillReviewMetadata(claimForm);
      function showClaimSuccess() {
        claimForm.style.display = 'none';
        var success = document.getElementById('dealer-claim-success');
        success.style.display = 'block';
        success.focus();
      }
      if (localReviewMode()) {
        showClaimSuccess();
        return;
      }
      if (window.coinFormSpamCheck && !window.coinFormSpamCheck(claimForm)) { return; }
      window.coinSubmitForm(claimForm).then(showClaimSuccess);
    });
  }
})();
</script>
