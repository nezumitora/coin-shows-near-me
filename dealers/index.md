---
layout: default
title: "Dealer Portal — Register & Get Pre-Show Leads"
seo_title: "Coin Dealer Portal — Register & Receive Pre-Show Offer Requests | Coin Show Near Me"
seo_description: "Register as a coin dealer on Coin Show Near Me. Verify your show attendance and receive pre-show offer requests from sellers bringing coins, bullion, and currency to your next show."
permalink: /dealers/
nav_order: 5
breadcrumb_current: "Dealers"
---

{% include form-styles.html %}

# Dealer Portal

Get a head start on your next coin show. Register as a dealer, verify which shows you're attending, and receive pre-show offer requests from sellers who want to bring their coins, bullion, and currency directly to your table.

<div class="feature-grid">
  <div class="feature-card">
    <h3>Pre-Show Leads</h3>
    <p>Receive detailed submissions from sellers — descriptions, photos, and estimated values — before you even set up your table.</p>
  </div>
  <div class="feature-card">
    <h3>Verified Attendance</h3>
    <p>Show up on event pages as a verified attending dealer. Sellers will know you'll be at the show before they pack up their collection.</p>
  </div>
  <div class="feature-card">
    <h3>Save Time</h3>
    <p>Review collections online. Make preliminary offers. Know exactly who's coming to your table and what they're bringing.</p>
  </div>
  <div class="feature-card">
    <h3>Free to Register</h3>
    <p>No cost to join the directory. Get listed, get leads, and grow your business at every show.</p>
  </div>
</div>

---

## Register as a Dealer

<form class="portal-form" id="dealer-form" action="https://formspree.io/f/REPLACE_WITH_YOUR_FORMSPREE_ID" method="POST">
  <input type="hidden" name="_form_type" value="dealer_registration">

  <div class="form-section">
    <h3>Business Information</h3>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="d-business">Business Name <span class="req">*</span></label>
        <input class="form-input" type="text" id="d-business" name="business_name" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="d-contact">Contact Name <span class="req">*</span></label>
        <input class="form-input" type="text" id="d-contact" name="contact_name" required>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="d-email">Email <span class="req">*</span></label>
        <input class="form-input" type="email" id="d-email" name="email" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="d-phone">Phone <span class="req">*</span></label>
        <input class="form-input" type="tel" id="d-phone" name="phone" required>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="d-city">City</label>
        <input class="form-input" type="text" id="d-city" name="city">
      </div>
      <div class="form-group">
        <label class="form-label" for="d-state">State <span class="req">*</span></label>
        <select class="form-select" id="d-state" name="state" required>
          <option value="">Select state...</option>
        </select>
      </div>
    </div>

    <div class="form-group">
      <label class="form-label" for="d-website">Website</label>
      <input class="form-input" type="url" id="d-website" name="website" placeholder="https://">
    </div>
  </div>

  <div class="form-section">
    <h3>Dealer Specialties</h3>
    <p class="form-help" style="margin-bottom:0.75rem;">Select all that apply — this helps match you with the right sellers.</p>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.25rem;">
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="us_coins"><label>US Coins</label></div>
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="world_coins"><label>World / Foreign Coins</label></div>
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="ancient_coins"><label>Ancient Coins</label></div>
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="paper_currency"><label>Paper Currency / Banknotes</label></div>
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="gold_bullion"><label>Gold Bullion</label></div>
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="silver_bullion"><label>Silver Bullion</label></div>
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="platinum_bullion"><label>Platinum / Palladium</label></div>
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="tokens_medals"><label>Tokens & Medals</label></div>
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="graded_coins"><label>Graded / Certified Coins</label></div>
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="error_coins"><label>Error Coins / Varieties</label></div>
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="estates"><label>Estate Lots / Collections</label></div>
      <div class="form-checkbox"><input type="checkbox" name="specialties[]" value="supplies"><label>Supplies & Accessories</label></div>
    </div>
  </div>

  <div class="form-section">
    <h3>Memberships & Certifications</h3>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.25rem;">
      <div class="form-checkbox"><input type="checkbox" name="memberships[]" value="ana"><label>ANA Member</label></div>
      <div class="form-checkbox"><input type="checkbox" name="memberships[]" value="png"><label>PNG Member</label></div>
      <div class="form-checkbox"><input type="checkbox" name="memberships[]" value="pcgs"><label>PCGS Authorized</label></div>
      <div class="form-checkbox"><input type="checkbox" name="memberships[]" value="ngc"><label>NGC Authorized</label></div>
      <div class="form-checkbox"><input type="checkbox" name="memberships[]" value="cac"><label>CAC Authorized</label></div>
      <div class="form-checkbox"><input type="checkbox" name="memberships[]" value="state_assoc"><label>State Numismatic Assoc.</label></div>
    </div>

    <div class="form-group" style="margin-top:0.5rem;">
      <label class="form-label" for="d-other-certs">Other memberships or certifications</label>
      <input class="form-input" type="text" id="d-other-certs" name="other_certifications" placeholder="e.g., BBB Accredited, FUN Life Member">
    </div>
  </div>

  <div class="form-section">
    <h3>Shows You Plan to Attend</h3>
    <p class="form-help" style="margin-bottom:0.75rem;">Check the shows where you'll have a table. This lets sellers know you'll be there and can send you pre-show offer requests.</p>

    <div class="form-group">
      <label class="form-label" for="d-show-filter">Filter by state</label>
      <select class="form-select" id="d-show-filter" style="max-width:200px;">
        <option value="all">All States</option>
      </select>
    </div>

    <div class="show-checklist" id="show-checklist">
      <!-- Populated by JS from site data -->
    </div>
  </div>

  <div class="form-section">
    <div class="form-checkbox">
      <input type="checkbox" id="d-terms" name="agree_terms" required>
      <label for="d-terms">I agree to the <a href="{{ site.baseurl }}/legal/terms-of-use/" target="_blank">Terms of Use</a> and <a href="{{ site.baseurl }}/legal/privacy-policy/" target="_blank">Privacy Policy</a>. I understand that registration does not constitute endorsement by Coin Show Near Me. <span class="req">*</span></label>
    </div>
    <div class="form-error" data-for="terms"></div>
  </div>

  <button class="form-btn" type="submit">Register as Dealer</button>
</form>

<div class="form-success" id="dealer-success">
  <strong>Registration submitted.</strong> We'll review your information and get back to you within 2 business days. Once approved, you'll appear as a verified dealer on the shows you selected.
</div>

<script>
(function() {
  var shows = {{ site.data.shows | jsonify }};
  var states = {{ site.data.states | jsonify }};

  // Populate state dropdowns
  var stateSelect = document.getElementById('d-state');
  var filterSelect = document.getElementById('d-show-filter');
  states.forEach(function(s) {
    var opt = document.createElement('option');
    opt.value = s.abbrev;
    opt.textContent = s.name;
    stateSelect.appendChild(opt);

    var opt2 = opt.cloneNode(true);
    filterSelect.appendChild(opt2);
  });

  // Populate show checklist
  var checklist = document.getElementById('show-checklist');
  function renderChecklist(filter) {
    checklist.innerHTML = '';
    var filtered = filter === 'all' ? shows : shows.filter(function(s) { return s.state === filter; });
    filtered.sort(function(a,b) { return a.name.localeCompare(b.name); });

    filtered.forEach(function(show) {
      var div = document.createElement('div');
      div.className = 'show-check-item';
      div.innerHTML = '<input type="checkbox" name="attending_shows[]" value="' + show.id + '">' +
        '<div><div>' + show.name + '</div>' +
        '<div class="show-check-meta">' + show.city + ', ' + show.state_name + ' &mdash; ' + show.frequency + '</div></div>';
      checklist.appendChild(div);
    });
  }
  renderChecklist('all');

  filterSelect.addEventListener('change', function() {
    renderChecklist(this.value);
  });

  // Form submission
  var form = document.getElementById('dealer-form');
  var success = document.getElementById('dealer-success');

  form.addEventListener('submit', function(e) {
    // If using Formspree, let it handle the redirect.
    // For the placeholder endpoint, show success locally.
    if (form.action.includes('REPLACE_WITH')) {
      e.preventDefault();
      form.style.display = 'none';
      success.style.display = 'block';
      window.scrollTo({top: success.offsetTop - 100, behavior: 'smooth'});
    }
  });
})();
</script>

---

## How the Pre-Show Offer System Works

1. **You register** and verify which shows you're attending
2. **Sellers browse** the show page and see which dealers are attending
3. **Sellers submit** descriptions and photos of what they want to sell
4. **You receive** the submission via email with full details
5. **You respond** with a preliminary offer or expression of interest
6. **You meet at the show** to inspect items and finalize the deal

It's that simple. You know what's coming to your table before the doors open.

---

## Questions?

Email us at [dealers@coinshownearme.com](mailto:dealers@coinshownearme.com)
