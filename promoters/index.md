---
layout: default
title: "Add Your Coin Show — Promoter Submission"
seo_title: "Add Your Coin Show to Our Directory — Free Listing | Coin Show Near Me"
seo_description: "Coin show promoters: submit your show for a free listing on Coin Show Near Me. Reach thousands of collectors and dealers searching for shows in their area."
permalink: /promoters/
nav_order: 8
breadcrumb_current: "Promoters"
---

{% include form-styles.html %}

# Add Your Coin Show to the Directory

**Free listing for all coin show promoters and organizers.** Get your show in front of collectors and dealers who are actively searching for events in their area.

<div class="feature-grid">
  <div class="feature-card">
    <h3>Free Listing</h3>
    <p>No cost to list your show. We want every coin show in the US to be in our directory.</p>
  </div>
  <div class="feature-card">
    <h3>SEO-Optimized Pages</h3>
    <p>Your show gets its own dedicated page, optimized to rank in Google for people searching for shows in your area.</p>
  </div>
  <div class="feature-card">
    <h3>Pre-Show Leads</h3>
    <p>Sellers can submit collections to dealers verified at your show — driving more foot traffic through your doors.</p>
  </div>
  <div class="feature-card">
    <h3>National Reach</h3>
    <p>Your show appears on state, city, and "this weekend" pages — reaching collectors across the country.</p>
  </div>
</div>

---

## Submit Your Show

<form class="portal-form" id="promoter-form" action="https://formspree.io/f/REPLACE_WITH_YOUR_FORMSPREE_ID" method="POST">
  <input type="hidden" name="_form_type" value="show_submission">

  <div class="form-section">
    <h3>Show Details</h3>

    <div class="form-group">
      <label class="form-label" for="p-show-name">Show Name <span class="req">*</span></label>
      <input class="form-input" type="text" id="p-show-name" name="show_name" required placeholder="e.g., Greater Portland Coin & Currency Show">
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="p-city">City <span class="req">*</span></label>
        <input class="form-input" type="text" id="p-city" name="city" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="p-state">State <span class="req">*</span></label>
        <select class="form-select" id="p-state" name="state" required>
          <option value="">Select state...</option>
        </select>
      </div>
    </div>

    <div class="form-group">
      <label class="form-label" for="p-venue">Venue Name <span class="req">*</span></label>
      <input class="form-input" type="text" id="p-venue" name="venue" required placeholder="e.g., Portland Convention Center">
    </div>

    <div class="form-group">
      <label class="form-label" for="p-address">Venue Address</label>
      <input class="form-input" type="text" id="p-address" name="address" placeholder="Full street address">
    </div>
  </div>

  <div class="form-section">
    <h3>Schedule</h3>

    <div class="form-group">
      <label class="form-label" for="p-frequency">Show Frequency <span class="req">*</span></label>
      <select class="form-select" id="p-frequency" name="frequency" required>
        <option value="">Select...</option>
        <option value="weekly">Weekly</option>
        <option value="biweekly">Biweekly (every 2 weeks)</option>
        <option value="monthly">Monthly</option>
        <option value="bimonthly">Bimonthly (every 2 months)</option>
        <option value="quarterly">Quarterly</option>
        <option value="3x_year">3 Times Per Year</option>
        <option value="semiannual">Semiannual (twice a year)</option>
        <option value="annual">Annual (once a year)</option>
        <option value="other">Other (specify in notes)</option>
      </select>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="p-next-date-start">Next Show Start Date</label>
        <input class="form-input" type="date" id="p-next-date-start" name="next_date_start">
      </div>
      <div class="form-group">
        <label class="form-label" for="p-next-date-end">Next Show End Date</label>
        <input class="form-input" type="date" id="p-next-date-end" name="next_date_end">
      </div>
    </div>

    <div class="form-group">
      <label class="form-label" for="p-schedule-notes">Schedule Details</label>
      <textarea class="form-textarea" id="p-schedule-notes" name="schedule_notes" rows="2"
        placeholder="e.g., 'Every 2nd Sunday', 'Last weekend of March and September', etc."></textarea>
    </div>
  </div>

  <div class="form-section">
    <h3>Show Information</h3>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="p-tables">Number of Dealer Tables</label>
        <input class="form-input" type="text" id="p-tables" name="dealer_tables" placeholder="e.g., 50+">
      </div>
      <div class="form-group">
        <label class="form-label" for="p-admission">Admission</label>
        <input class="form-input" type="text" id="p-admission" name="admission" placeholder="e.g., Free, $5, $3 early bird">
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="p-hours">Show Hours</label>
        <input class="form-input" type="text" id="p-hours" name="hours" placeholder="e.g., Sat 9am-5pm, Sun 10am-3pm">
      </div>
      <div class="form-group">
        <label class="form-label" for="p-parking">Parking</label>
        <input class="form-input" type="text" id="p-parking" name="parking" placeholder="e.g., Free, $5 garage">
      </div>
    </div>

    <div class="form-group">
      <label class="form-label" for="p-website">Official Show Website <span class="req">*</span></label>
      <input class="form-input" type="url" id="p-website" name="website" required placeholder="https://">
    </div>

    <div class="form-group">
      <label class="form-label" for="p-description">Show Description</label>
      <textarea class="form-textarea" id="p-description" name="description" rows="3"
        placeholder="Tell collectors what makes your show worth attending."></textarea>
    </div>
  </div>

  <div class="form-section">
    <h3>Organizer Contact</h3>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="p-org-name">Organizer / Club Name <span class="req">*</span></label>
        <input class="form-input" type="text" id="p-org-name" name="organizer_name" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="p-org-contact">Contact Person <span class="req">*</span></label>
        <input class="form-input" type="text" id="p-org-contact" name="contact_person" required>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="p-org-email">Email <span class="req">*</span></label>
        <input class="form-input" type="email" id="p-org-email" name="organizer_email" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="p-org-phone">Phone</label>
        <input class="form-input" type="tel" id="p-org-phone" name="organizer_phone">
      </div>
    </div>
  </div>

  <div class="form-section">
    <div class="form-checkbox">
      <input type="checkbox" id="p-terms" name="agree_terms" required>
      <label for="p-terms">I agree to the <a href="{{ site.baseurl }}/legal/terms-of-use/" target="_blank">Terms of Use</a>. I confirm that I am authorized to submit this show listing and that the information is accurate. <span class="req">*</span></label>
    </div>

    <div class="form-checkbox">
      <input type="checkbox" id="p-updates" name="consent_updates">
      <label for="p-updates">Contact me about updates to the show listing or when sellers submit offer requests for this show.</label>
    </div>
  </div>

  <button class="form-btn" type="submit">Submit Show Listing</button>
</form>

<div class="form-success" id="promoter-success">
  <strong>Show submitted!</strong> We'll review and add your listing within 2 business days. You'll get a confirmation email once it's live with a link to your show's dedicated page.
</div>

<script>
(function() {
  var states = {{ site.data.states | jsonify }};
  var stateSelect = document.getElementById('p-state');
  states.forEach(function(s) {
    var opt = document.createElement('option');
    opt.value = s.abbrev;
    opt.textContent = s.name;
    stateSelect.appendChild(opt);
  });

  var form = document.getElementById('promoter-form');
  var success = document.getElementById('promoter-success');

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

## Already Listed?

If your show is already in our directory and you need to update the information, email us at [promoters@coinshownearme.com](mailto:promoters@coinshownearme.com) with the show name and corrections.

---

## Dealer Table Inquiries

If you're a dealer looking for table space at a show, please contact the show organizer directly through their official website. We are a directory — we do not manage table sales or reservations.
