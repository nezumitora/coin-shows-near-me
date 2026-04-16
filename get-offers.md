---
layout: default
title: "Get Pre-Show Offers on Your Coins — Submit Your Collection"
seo_title: "Get Pre-Show Offers on Your Coins, Bullion & Currency | Coin Show Near Me"
seo_description: "Submit your coin collection, bullion, or paper currency to dealers attending an upcoming coin show. Get offers before you go — skip the guesswork and save time at the show."
permalink: /get-offers/
nav_order: 6
breadcrumb_current: "Get Offers"
---

{% include form-styles.html %}

# Get Pre-Show Offers on Your Coins

**Skip the guesswork.** Submit details about your coins, bullion, or currency to dealers who are verified to attend an upcoming show. Get preliminary offers before you even walk through the door.

<div class="feature-grid">
  <div class="feature-card">
    <h3>1. Pick a Show</h3>
    <p>Select an upcoming coin show you plan to attend from our directory.</p>
  </div>
  <div class="feature-card">
    <h3>2. Describe What You Have</h3>
    <p>Tell dealers what you're bringing — coins, bullion, paper currency, full collections, or estate lots.</p>
  </div>
  <div class="feature-card">
    <h3>3. Add Photos</h3>
    <p>Upload photos so dealers can give you a better preliminary estimate. Obverse, reverse, and any problem areas.</p>
  </div>
  <div class="feature-card">
    <h3>4. Get Offers</h3>
    <p>Attending dealers review your submission and respond with preliminary offers before the show.</p>
  </div>
</div>

---

## Submit Your Collection

<form class="portal-form" id="offer-request-form" action="https://formspree.io/f/REPLACE_WITH_YOUR_FORMSPREE_ID" method="POST" enctype="multipart/form-data">
  <input type="hidden" name="_form_type" value="pre_show_offer_request">

  <div class="form-section">
    <h3>Your Information</h3>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="o-name">Full Name <span class="req">*</span></label>
        <input class="form-input" type="text" id="o-name" name="name" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="o-email">Email <span class="req">*</span></label>
        <input class="form-input" type="email" id="o-email" name="email" required>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="o-phone">Phone</label>
        <input class="form-input" type="tel" id="o-phone" name="phone">
        <div class="form-help">Optional — some dealers prefer to call about higher-value items.</div>
      </div>
      <div class="form-group">
        <label class="form-label" for="o-zip">ZIP Code <span class="req">*</span></label>
        <input class="form-input" type="text" id="o-zip" name="zip" maxlength="10" required>
      </div>
    </div>
  </div>

  <div class="form-section">
    <h3>Which Show?</h3>

    <div class="form-group">
      <label class="form-label" for="o-show-filter">Filter by state</label>
      <select class="form-select" id="o-show-filter" style="max-width:200px;">
        <option value="all">All States</option>
      </select>
    </div>

    <div class="form-group">
      <label class="form-label" for="o-show">Select the show you plan to attend <span class="req">*</span></label>
      <select class="form-select" id="o-show" name="show_id" required>
        <option value="">Choose a show...</option>
      </select>
    </div>
  </div>

  <div class="form-section">
    <h3>What Are You Selling?</h3>
    <p class="form-help" style="margin-bottom:0.75rem;">Select all categories that apply.</p>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:0.25rem;margin-bottom:0.75rem;">
      <div class="form-checkbox"><input type="checkbox" name="categories[]" value="us_coins"><label>US Coins</label></div>
      <div class="form-checkbox"><input type="checkbox" name="categories[]" value="world_coins"><label>World / Foreign Coins</label></div>
      <div class="form-checkbox"><input type="checkbox" name="categories[]" value="paper_currency"><label>Paper Currency / Banknotes</label></div>
      <div class="form-checkbox"><input type="checkbox" name="categories[]" value="gold_bullion"><label>Gold Bullion (coins, bars)</label></div>
      <div class="form-checkbox"><input type="checkbox" name="categories[]" value="silver_bullion"><label>Silver Bullion (coins, bars, rounds)</label></div>
      <div class="form-checkbox"><input type="checkbox" name="categories[]" value="graded_coins"><label>Graded / Certified Coins (PCGS, NGC)</label></div>
      <div class="form-checkbox"><input type="checkbox" name="categories[]" value="estate_collection"><label>Full Estate / Inherited Collection</label></div>
      <div class="form-checkbox"><input type="checkbox" name="categories[]" value="other"><label>Other (tokens, medals, stamps, etc.)</label></div>
    </div>

    <div class="form-group">
      <label class="form-label" for="o-description">Describe your items in detail <span class="req">*</span></label>
      <textarea class="form-textarea" id="o-description" name="description" rows="6" required
        placeholder="Be as specific as possible. Include:
- Types of coins (Morgan dollars, Walking Liberty halves, etc.)
- Approximate quantities
- Condition (circulated, uncirculated, slabbed/graded)
- Any key dates or rare items you know about
- Whether you've had items appraised before
- Approximate total weight for bullion"></textarea>
    </div>

    <div class="form-group">
      <label class="form-label" for="o-estimated-value">Your estimated value (optional)</label>
      <input class="form-input" type="text" id="o-estimated-value" name="estimated_value" placeholder="e.g., $500-$1,000 or 'Not sure'">
      <div class="form-help">A rough idea helps dealers prioritize. Don't worry if you're not sure — that's what they're for.</div>
    </div>
  </div>

  <div class="form-section">
    <h3>Photos</h3>
    <p class="form-help" style="margin-bottom:0.75rem;">Photos significantly increase the quality of offers you receive. Dealers can give much better estimates when they can see the items.</p>

    <div class="form-group">
      <label class="form-label" for="o-photos">Upload photos of your items</label>
      <input class="form-input" type="file" id="o-photos" name="photos" multiple accept="image/*" style="padding:0.35rem;">
      <div class="form-help">You can select multiple files. Max 10MB per file. JPG, PNG, or HEIC.</div>
    </div>

    <div style="background:#fffbeb;border:1px solid #fde68a;border-radius:0.5rem;padding:0.75rem;margin-top:0.5rem;">
      <strong style="font-size:0.9rem;">Photo Tips for Better Offers:</strong>
      <ul style="font-size:0.85rem;margin:0.4rem 0 0;padding-left:1.2rem;color:#374151;">
        <li><strong>Obverse AND reverse</strong> — photograph both sides of each coin</li>
        <li><strong>Good lighting</strong> — natural light or a desk lamp, avoid flash glare</li>
        <li><strong>Sharp focus</strong> — get close enough to see details and dates</li>
        <li><strong>Group shots</strong> — for large lots, a spread-out overview photo helps</li>
        <li><strong>Include holders</strong> — if coins are in PCGS/NGC slabs, photograph the label too</li>
        <li><strong>Scale reference</strong> — include a ruler or common object for bars/rounds</li>
      </ul>
    </div>
  </div>

  <div class="form-section">
    <h3>Your Expectations</h3>

    <div class="form-group">
      <label class="form-label" for="o-goal">What's your goal?</label>
      <select class="form-select" id="o-goal" name="seller_goal">
        <option value="">Select...</option>
        <option value="sell_all">Sell everything — looking for best overall offer</option>
        <option value="sell_some">Sell select items — keeping some pieces</option>
        <option value="appraisal_only">Just want to know what it's worth</option>
        <option value="exploring">Exploring options — not sure yet</option>
      </select>
    </div>

    <div class="form-group">
      <label class="form-label" for="o-notes">Any additional notes for dealers</label>
      <textarea class="form-textarea" id="o-notes" name="additional_notes" rows="3"
        placeholder="e.g., 'Inherited from grandfather, never been appraised' or 'Looking to sell quickly'"></textarea>
    </div>
  </div>

  <div class="form-section">
    <div class="form-checkbox">
      <input type="checkbox" id="o-terms" name="agree_terms" required>
      <label for="o-terms">I agree to the <a href="{{ site.baseurl }}/legal/terms-of-use/" target="_blank">Terms of Use</a> and <a href="{{ site.baseurl }}/legal/privacy-policy/" target="_blank">Privacy Policy</a>. I understand that all offers are preliminary and non-binding, and that Coin Show Near Me is not a party to any transaction. <span class="req">*</span></label>
    </div>

    <div class="form-checkbox">
      <input type="checkbox" id="o-consent" name="consent_share" required>
      <label for="o-consent">I consent to my contact information and item details being shared with registered dealers attending the selected show. <span class="req">*</span></label>
    </div>

    <div class="form-checkbox">
      <input type="checkbox" id="o-disclaimer" name="acknowledge_disclaimer" required>
      <label for="o-disclaimer">I acknowledge that preliminary offers may change upon physical inspection of items, and that I am solely responsible for accepting or declining any offer. <span class="req">*</span></label>
    </div>
  </div>

  <button class="form-btn" type="submit">Submit for Pre-Show Offers</button>
</form>

<div class="form-success" id="offer-success">
  <strong>Submission received!</strong> Your collection details will be sent to registered dealers attending the show you selected. Dealers may respond by email with preliminary offers or questions. Remember — all offers are preliminary until the dealer inspects your items in person at the show.
</div>

<script>
(function() {
  var shows = {{ site.data.shows | jsonify }};
  var states = {{ site.data.states | jsonify }};

  var filterSelect = document.getElementById('o-show-filter');
  var showSelect = document.getElementById('o-show');

  states.forEach(function(s) {
    var opt = document.createElement('option');
    opt.value = s.abbrev;
    opt.textContent = s.name;
    filterSelect.appendChild(opt);
  });

  function updateShowDropdown(filter) {
    showSelect.innerHTML = '<option value="">Choose a show...</option>';
    var filtered = filter === 'all' ? shows : shows.filter(function(s) { return s.state === filter; });
    filtered.sort(function(a,b) { return a.name.localeCompare(b.name); });
    filtered.forEach(function(show) {
      var opt = document.createElement('option');
      opt.value = show.id;
      opt.textContent = show.name + ' — ' + show.city + ', ' + show.state_name;
      showSelect.appendChild(opt);
    });
  }
  updateShowDropdown('all');

  filterSelect.addEventListener('change', function() {
    updateShowDropdown(this.value);
  });

  var form = document.getElementById('offer-request-form');
  var success = document.getElementById('offer-success');

  form.addEventListener('submit', function(e) {
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

## How It Works — For Sellers

### Before the Show
1. **Submit your collection details** using the form above
2. **Receive preliminary offers** from dealers via email
3. **Compare offers** and decide who to visit at the show

### At the Show
4. **Bring your items** to the dealers who made offers
5. **Dealers inspect in person** and confirm or adjust their offer
6. **Finalize the deal** — negotiate, accept, or walk away

### Important
- All pre-show offers are **preliminary and non-binding** — the dealer needs to physically inspect your items
- You are **never obligated** to accept any offer
- We recommend **submitting to multiple dealers** to compare offers
- See our [Disclaimer](/coin-shows-near-me/legal/disclaimer/) for full details

---

## Don't Know Which Show to Attend?

Browse our **[state directory](/coin-shows-near-me/states/)** or check **[coin shows this weekend](/coin-shows-near-me/coin-shows-this-weekend/)** to find a show near you.
