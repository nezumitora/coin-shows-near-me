---
layout: default
title: "Submit a Coin Show"
seo_title: "Submit a Coin Show | Coin Show Near Me"
seo_description: "Submit a missing coin show for manual review and possible inclusion in the Coin Show Near Me directory."
permalink: /submit-show/
nav_exclude: true
breadcrumb_current: "Submit a Show"
---

# Submit a Coin Show

Use this form if you organize, promote, host, or represent a coin show that is missing from the directory.

<div style="background:#eff6ff;border:1px solid #bfdbfe;border-radius:10px;padding:1rem 1.15rem;margin:1rem 0 1.25rem;color:#1e3a8a;">
  <strong>Every submission is reviewed manually.</strong> A submission does not automatically create or verify a public listing. We compare the details with an official show, promoter, club, association, or venue source before publishing. Never send passwords, identification documents, or other sensitive information.
</div>

<style>
.show-submission-form { display:flex; flex-direction:column; gap:0.75rem; }
.show-submission-grid { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:0.75rem; }
.show-submission-form label { display:flex; flex-direction:column; gap:0.3rem; color:#334155; font-size:0.82rem; font-weight:700; }
.show-submission-form input,
.show-submission-form select,
.show-submission-form textarea { width:100%; min-width:0; padding:0.7rem 0.8rem; border:1px solid var(--coin-border); border-radius:6px; background:#fff; color:#111; font:inherit; font-size:0.9rem; }
.show-submission-form textarea { min-height:105px; resize:vertical; }
.show-submission-form input:focus,
.show-submission-form select:focus,
.show-submission-form textarea:focus { border-color:var(--coin-gold); outline:none; box-shadow:0 0 0 3px rgba(218,165,32,0.16); }
.show-submission-form .submission-consent { display:flex; flex-direction:row; align-items:flex-start; gap:0.55rem; font-size:0.78rem; font-weight:500; line-height:1.45; }
.show-submission-form .submission-consent input { width:1rem; height:1rem; margin-top:0.15rem; flex:0 0 auto; accent-color:var(--coin-gold); }
.show-submission-form button { align-self:flex-start; padding:0.7rem 1.3rem; border:0; border-radius:6px; background:var(--coin-navy); color:#fff; cursor:pointer; font-weight:800; }
.show-submission-form button:hover { background:var(--coin-gold); }
@media (max-width:700px) { .show-submission-grid { grid-template-columns:1fr; } }
</style>

<div class="notify-section" style="margin:1rem 0;padding:1.25rem;">
<form class="show-submission-form" id="show-submission-form" action="#" data-form-key="mykleozw" method="POST">
  <input type="hidden" name="_subject" value="Coin Show Near Me — New Show Submission">
  <input type="hidden" name="form_type" value="show_submission">
  <input type="hidden" name="source" value="Website">
  <input type="hidden" name="formName" value="showSubmission">
  <input type="hidden" name="coinContactRoles" value="showOrganizer">
  <input type="hidden" name="ctaCode" value="submit_show_page_form">
  <input type="hidden" name="sourceDetail" value="Dedicated submit a show page">
  <input type="hidden" name="pageUrl" value="">
  <input type="hidden" name="referringUrl" value="">
  <input type="hidden" name="submittedAt" value="">
  <input type="hidden" name="contactConsentTimestamp" value="">
  <input type="hidden" name="contactConsentVersion" value="coin-show-submission-consent-v1">
  <input type="hidden" name="contactConsentText" value="I agree that Coin Show Near Me may contact me to review this show submission. Submitted details are reviewed before publication.">

  <div class="show-submission-grid">
    <label>Your full name
      <input type="text" name="contact_name" autocomplete="name" required>
    </label>
    <label>Organization, club, or venue
      <input type="text" name="organization_name" required>
    </label>
  </div>

  <div class="show-submission-grid">
    <label>Official contact email
      <input type="email" name="email" autocomplete="email" required>
    </label>
    <label>Your role
      <select name="organizer_role" required>
        <option value="">Select your role</option>
        <option value="organizer">Organizer or promoter</option>
        <option value="clubOfficer">Coin club officer</option>
        <option value="venueContact">Venue representative</option>
        <option value="authorizedStaff">Authorized show staff</option>
        <option value="communityReporter">Community member sharing a public source</option>
      </select>
    </label>
  </div>

  <label>Coin show name
    <input type="text" name="show_name" required>
  </label>

  <div class="show-submission-grid">
    <label>Upcoming date or dates
      <input type="text" name="upcoming_dates" placeholder="Example: October 10–11, 2026" required>
    </label>
    <label>Venue name
      <input type="text" name="venue_name" required>
    </label>
  </div>

  <label>Street address
    <input type="text" name="street_address" autocomplete="street-address" required>
  </label>

  <div class="show-submission-grid">
    <label>City
      <input type="text" name="city" autocomplete="address-level2" required>
    </label>
    <label>State
      <select name="state" autocomplete="address-level1" required>
        <option value="">Select a state</option>
        {% for state in site.data.states %}<option value="{{ state.abbrev }}">{{ state.name }}</option>{% endfor %}
      </select>
    </label>
  </div>

  <div class="show-submission-grid">
    <label>ZIP code
      <input type="text" name="postal_code" inputmode="numeric" autocomplete="postal-code" required>
    </label>
    <label>Official public source URL
      <input type="url" name="official_source_url" placeholder="Show, club, promoter, association, or venue page" required>
    </label>
  </div>

  <label>Public event details
    <textarea name="event_details" placeholder="Include public hours, admission, frequency, organizer name, and anything else visitors should know."></textarea>
  </label>

  <label class="submission-consent">
    <input type="checkbox" name="contactConsent" value="yes" required>
    <span>I agree that Coin Show Near Me may contact me to review this show submission. Submitted details are reviewed before publication. See our <a href="/legal/privacy-policy/">Privacy Policy</a>.</span>
  </label>

  <button type="submit">Submit Show for Review</button>
</form>
<div class="notify-success" id="show-submission-success" style="display:none;background:#065f46;color:#fff;padding:0.9rem;border-radius:6px;margin-top:0.75rem;">
  Thank you — the show was submitted for manual review. We may email you if we need clarification or stronger official-source evidence.
</div>
</div>

Already listed? Open the show page and use **Organize this show? Request verification** or **Update show info** instead.

<script>
(function() {
  var form = document.getElementById('show-submission-form');
  if (!form) { return; }
  function setFormValue(name, value) {
    var field = form.querySelector('[name="' + name + '"]');
    if (field) { field.value = value; }
  }
  form.addEventListener('submit', function(event) {
    event.preventDefault();
    var now = new Date().toISOString();
    setFormValue('pageUrl', window.location.href);
    setFormValue('referringUrl', document.referrer || '');
    setFormValue('submittedAt', now);
    setFormValue('contactConsentTimestamp', now);
    if (window.coinFormSpamCheck && !window.coinFormSpamCheck(form)) { return; }
    window.coinSubmitForm(form).then(function() {
      form.style.display = 'none';
      document.getElementById('show-submission-success').style.display = 'block';
    });
  });
})();
</script>
