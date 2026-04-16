---
layout: default
title: "Attendee Portal — Manage Your Collection & Get Show-Ready"
seo_title: "Coin Show Attendee Portal — Organize Your Collection | Coin Show Near Me"
seo_description: "Organize your coin collection before attending a show. Upload your inventory list, add photos, and share your collection with dealers for pre-show offers."
permalink: /attendees/
nav_order: 7
breadcrumb_current: "Attendees"
---

{% include form-styles.html %}

# Attendee Portal

Get organized before your next coin show. Build your collection inventory, add photos, and share it with dealers to get offers before you arrive.

<div class="feature-grid">
  <div class="feature-card">
    <h3>Catalog Your Collection</h3>
    <p>Create a detailed inventory of what you want to bring to the show — coins, currency, bullion, and collectibles.</p>
  </div>
  <div class="feature-card">
    <h3>Add Photos</h3>
    <p>Upload clear photos so dealers can give you accurate preliminary valuations without guessing.</p>
  </div>
  <div class="feature-card">
    <h3>Get Pre-Show Offers</h3>
    <p>Share your inventory with attending dealers and receive offers before the show opens.</p>
  </div>
  <div class="feature-card">
    <h3>Save Time at the Show</h3>
    <p>Walk in knowing who wants to see your items and what to expect. No more going table to table cold.</p>
  </div>
</div>

---

## Build Your Collection Inventory

Use this form to catalog the items you plan to bring to a coin show. You can submit multiple times if you have different categories of items.

<form class="portal-form" id="inventory-form" action="https://formspree.io/f/REPLACE_WITH_YOUR_FORMSPREE_ID" method="POST" enctype="multipart/form-data">
  <input type="hidden" name="_form_type" value="collection_inventory">

  <div class="form-section">
    <h3>Your Information</h3>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="a-name">Full Name <span class="req">*</span></label>
        <input class="form-input" type="text" id="a-name" name="name" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="a-email">Email <span class="req">*</span></label>
        <input class="form-input" type="email" id="a-email" name="email" required>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="a-phone">Phone</label>
        <input class="form-input" type="tel" id="a-phone" name="phone">
      </div>
      <div class="form-group">
        <label class="form-label" for="a-zip">ZIP Code <span class="req">*</span></label>
        <input class="form-input" type="text" id="a-zip" name="zip" maxlength="10" required>
      </div>
    </div>
  </div>

  <div class="form-section">
    <h3>Collection Inventory</h3>
    <p class="form-help" style="margin-bottom:0.75rem;">List your items below. The more detail you provide, the better offers you'll receive.</p>

    <div id="inventory-items">
      <div class="inventory-item" data-index="1">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:0.5rem;">
          <strong style="font-size:0.9rem;">Item 1</strong>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label class="form-label">Item Type <span class="req">*</span></label>
            <select class="form-select" name="items[0][type]" required>
              <option value="">Select...</option>
              <option value="us_coin">US Coin</option>
              <option value="world_coin">World / Foreign Coin</option>
              <option value="paper_currency">Paper Currency / Banknote</option>
              <option value="gold_bullion_coin">Gold Bullion Coin</option>
              <option value="silver_bullion_coin">Silver Bullion Coin</option>
              <option value="gold_bar">Gold Bar</option>
              <option value="silver_bar">Silver Bar / Round</option>
              <option value="graded_coin">Graded/Certified Coin (PCGS/NGC)</option>
              <option value="token_medal">Token or Medal</option>
              <option value="lot_collection">Lot / Collection (multiple items)</option>
              <option value="other">Other</option>
            </select>
          </div>
          <div class="form-group">
            <label class="form-label">Quantity</label>
            <input class="form-input" type="number" name="items[0][quantity]" value="1" min="1">
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Description <span class="req">*</span></label>
          <input class="form-input" type="text" name="items[0][description]" required
            placeholder="e.g., 1921 Morgan Silver Dollar, Philadelphia mint, XF condition">
        </div>

        <div class="form-row">
          <div class="form-group">
            <label class="form-label">Year / Date</label>
            <input class="form-input" type="text" name="items[0][year]" placeholder="e.g., 1921, 1964, N/A">
          </div>
          <div class="form-group">
            <label class="form-label">Condition / Grade</label>
            <select class="form-select" name="items[0][condition]">
              <option value="">Select...</option>
              <option value="poor_fair">Poor / Fair (heavily worn)</option>
              <option value="good_vg">Good / Very Good</option>
              <option value="fine_vf">Fine / Very Fine</option>
              <option value="ef_au">EF / About Uncirculated</option>
              <option value="uncirculated">Uncirculated (mint state)</option>
              <option value="proof">Proof</option>
              <option value="graded_slab">Graded / Slabbed (PCGS, NGC)</option>
              <option value="unknown">Not sure</option>
            </select>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Grade Number (if graded)</label>
          <input class="form-input" type="text" name="items[0][grade_number]" placeholder="e.g., MS-65, PF-69, VF-30">
        </div>

        <div class="form-group">
          <label class="form-label">Photo</label>
          <input class="form-input" type="file" name="items[0][photo]" accept="image/*" style="padding:0.35rem;">
          <div class="form-help">Obverse and reverse preferred. JPG/PNG, max 10MB.</div>
        </div>
      </div>
    </div>

    <button type="button" class="form-btn" id="add-item-btn" style="background:#e5e7eb;color:#374151;margin-top:0.5rem;font-size:0.9rem;padding:0.4rem 1rem;">
      + Add Another Item
    </button>
  </div>

  <div class="form-section">
    <h3>Bulk Upload (Alternative)</h3>
    <p class="form-help" style="margin-bottom:0.5rem;">Have a large collection? Instead of listing items individually, you can upload a spreadsheet or text file.</p>

    <div class="form-group">
      <label class="form-label" for="a-bulk-file">Upload inventory file</label>
      <input class="form-input" type="file" id="a-bulk-file" name="bulk_inventory" accept=".csv,.xlsx,.xls,.txt,.pdf" style="padding:0.35rem;">
      <div class="form-help">Accepted: CSV, Excel, text, or PDF. Include coin type, year, quantity, and condition if possible.</div>
    </div>

    <div class="form-group">
      <label class="form-label" for="a-bulk-photos">Upload photo album (ZIP)</label>
      <input class="form-input" type="file" id="a-bulk-photos" name="bulk_photos" accept=".zip" style="padding:0.35rem;">
      <div class="form-help">ZIP file of coin photos. Name files descriptively (e.g., "1921-morgan-obverse.jpg").</div>
    </div>
  </div>

  <div class="form-section">
    <h3>What Do You Want to Do?</h3>

    <div style="margin-bottom:0.75rem;">
      <div class="form-checkbox"><input type="radio" name="intent" value="sell" checked><label>I want to <strong>sell</strong> these items at a coin show</label></div>
      <div class="form-checkbox"><input type="radio" name="intent" value="appraise"><label>I want to get these items <strong>appraised</strong> (not necessarily selling)</label></div>
      <div class="form-checkbox"><input type="radio" name="intent" value="both"><label>I want <strong>appraisals and offers</strong> — will decide at the show</label></div>
    </div>

    <div class="form-group">
      <label class="form-label" for="a-target-show">Which show are you attending?</label>
      <select class="form-select" id="a-target-show" name="target_show">
        <option value="">Select a show (optional)...</option>
      </select>
      <div class="form-help">Optional. If selected, your inventory can be shared with dealers attending this show.</div>
    </div>

    <div class="form-checkbox" style="margin-top:0.5rem;">
      <input type="checkbox" name="share_with_dealers" id="a-share">
      <label for="a-share">Yes, share my inventory with registered dealers attending the selected show so I can receive pre-show offers.</label>
    </div>
  </div>

  <div class="form-section">
    <div class="form-checkbox">
      <input type="checkbox" id="a-terms" name="agree_terms" required>
      <label for="a-terms">I agree to the <a href="{{ site.baseurl }}/legal/terms-of-use/" target="_blank">Terms of Use</a> and <a href="{{ site.baseurl }}/legal/privacy-policy/" target="_blank">Privacy Policy</a>. <span class="req">*</span></label>
    </div>
  </div>

  <button class="form-btn" type="submit">Submit My Collection</button>
</form>

<div class="form-success" id="inventory-success">
  <strong>Collection submitted!</strong> Your inventory has been saved. If you opted to share with dealers, attending dealers at your selected show will be notified and may contact you with preliminary offers.
</div>

<script>
(function() {
  var shows = {{ site.data.shows | jsonify }};
  var showSelect = document.getElementById('a-target-show');
  shows.sort(function(a,b) { return a.name.localeCompare(b.name); });
  shows.forEach(function(show) {
    var opt = document.createElement('option');
    opt.value = show.id;
    opt.textContent = show.name + ' — ' + show.city + ', ' + show.state_name;
    showSelect.appendChild(opt);
  });

  // Add item button
  var itemCount = 1;
  var addBtn = document.getElementById('add-item-btn');
  var container = document.getElementById('inventory-items');

  addBtn.addEventListener('click', function() {
    itemCount++;
    var template = container.querySelector('.inventory-item').cloneNode(true);
    template.setAttribute('data-index', itemCount);
    template.querySelector('strong').textContent = 'Item ' + itemCount;

    // Update name attributes
    var inputs = template.querySelectorAll('input, select, textarea');
    inputs.forEach(function(inp) {
      if (inp.name) {
        inp.name = inp.name.replace(/items\[\d+\]/, 'items[' + (itemCount - 1) + ']');
      }
      if (inp.type === 'text' || inp.type === 'number') inp.value = inp.type === 'number' ? '1' : '';
      if (inp.type === 'file') inp.value = '';
      if (inp.tagName === 'SELECT') inp.selectedIndex = 0;
    });

    // Add remove button
    var header = template.querySelector('div[style]');
    if (!template.querySelector('.remove-item')) {
      var removeBtn = document.createElement('button');
      removeBtn.type = 'button';
      removeBtn.textContent = 'Remove';
      removeBtn.className = 'remove-item';
      removeBtn.style.cssText = 'background:none;border:1px solid #e5e7eb;border-radius:0.25rem;padding:0.2rem 0.5rem;font-size:0.8rem;cursor:pointer;color:#6b7280;';
      removeBtn.addEventListener('click', function() {
        template.remove();
      });
      header.appendChild(removeBtn);
    }

    container.appendChild(template);
  });

  // Form submit
  var form = document.getElementById('inventory-form');
  var success = document.getElementById('inventory-success');

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

## Photography Guide for Coin Show Sellers

Great photos lead to better offers. Here's how to photograph your coins like a pro:

### Equipment
You don't need fancy equipment — a smartphone camera works fine.

### Setup
1. **Lighting:** Use natural daylight or a desk lamp. Avoid direct flash — it creates glare.
2. **Background:** White paper or a plain dark surface. No busy patterns.
3. **Stability:** Rest your phone against something stable, or use a tripod.

### What to Photograph

| Coin Type | What to Capture |
|-----------|----------------|
| **Individual coins** | Obverse (front), reverse (back), edge (if relevant) |
| **Graded coins (slabs)** | Front of holder showing coin + label, back of holder |
| **Paper currency** | Front and back, flat and well-lit |
| **Bullion bars** | Front showing stamp/hallmark, back, edge for thickness |
| **Large lots** | Spread-out overview shot + close-ups of best/notable pieces |

### Common Mistakes to Avoid
- Blurry or out-of-focus images
- Harsh flash causing white glare spots
- Coins photographed at an angle (shoot straight-on)
- Too far away — dealers need to see details and dates
- Cropping out the coin's edge

---

## Ready to Get Offers?

Once you've built your inventory, head to the **[Get Offers](/coin-shows-near-me/get-offers/)** page to submit directly to dealers attending your next show.
