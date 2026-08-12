---
layout: default
title: "Submit a Coin Show"
description: "Submit a missing coin show for manual review and possible inclusion in the Coin Show Near Me directory."
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
.show-submission-form,
.show-submission-form * { box-sizing:border-box; }
.show-submission-form { display:flex; flex-direction:column; gap:0.75rem; width:100%; min-width:0; }
.show-submission-grid { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:0.75rem; }
.show-submission-wide { grid-column:1 / -1; }
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
.show-submission-fieldset { min-width:0; margin:0; padding:1rem; border:1px solid #cbd5e1; border-radius:8px; background:#f8fafc; }
.show-submission-fieldset legend { padding:0 0.35rem; color:var(--coin-navy); font-weight:800; }
.show-submission-fieldset .show-submission-grid + .show-submission-grid,
.show-submission-fieldset > label + .show-submission-grid { margin-top:0.75rem; }
.show-submission-thanks { display:none; background:#ecfdf5; color:#14532d; padding:1rem; border:1px solid #86efac; border-radius:8px; margin-top:0.75rem; }
.show-submission-thanks:focus { outline:3px solid rgba(184,134,11,0.35); outline-offset:3px; }
.show-submission-thanks a { color:#14532d; font-weight:800; text-decoration:underline; overflow-wrap:anywhere; }
.show-submission-copy { margin-top:0.75rem; padding:0.6rem 0.95rem !important; background:var(--coin-gold) !important; color:#fff !important; border-radius:6px !important; font-weight:800 !important; }
.show-submission-copy:hover { background:var(--coin-gold-light) !important; color:#fff !important; }
@media (max-width:700px) {
  .show-submission-grid { grid-template-columns:1fr; }
  .show-submission-fieldset { padding:0.8rem; }
  .show-submission-form input,
  .show-submission-form select,
  .show-submission-form textarea,
  .show-submission-form button { max-width:100%; }
}
</style>

<div class="notify-section" style="margin:1rem 0;padding:1.25rem;">
<form class="show-submission-form" id="show-submission-form" action="#" data-form-key="mykleozw" method="POST" novalidate>
  <input type="hidden" name="_subject" value="[Coin Show Near Me][New Show] Submission for manual review">
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
    <label>First name
      <input type="text" name="first_name" autocomplete="given-name" required>
    </label>
    <label>Last name
      <input type="text" name="last_name" autocomplete="family-name" required>
    </label>
  </div>

  <div class="show-submission-grid">
    <label>Organization, club, or venue
      <input type="text" name="organization_name" required>
    </label>
    <label>Official contact email
      <input type="email" name="email" autocomplete="email" required>
    </label>
    <label class="show-submission-wide">Your role
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
    <label>Official public source URL
      <input type="url" name="official_source_url" placeholder="Show, club, promoter, association, or venue page" required>
    </label>
  </div>

  <fieldset class="show-submission-fieldset">
    <legend>Show location</legend>
    <div class="show-submission-grid">
      <label>Venue name
        <input type="text" name="venue_name" required>
      </label>
      <label>Street address
        <input type="text" name="street_address" autocomplete="street-address" required>
      </label>
    </div>
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
    </div>
  </fieldset>

  <label>Public event details
    <textarea name="event_details" placeholder="Include public hours, admission, frequency, organizer name, and anything else visitors should know."></textarea>
  </label>

  <label class="submission-consent">
    <input type="checkbox" name="contactConsent" value="yes" required>
    <span>I agree that Coin Show Near Me may contact me to review this show submission. Submitted details are reviewed before publication. See our <a href="/legal/privacy-policy/">Privacy Policy</a>.</span>
  </label>

  <button type="submit">Submit Show for Review</button>
</form>
<div class="show-submission-thanks" id="show-submission-success" role="status" tabindex="-1">
  <strong>Thank you — your show was submitted for manual review.</strong>
  <p style="margin:0.45rem 0 0;">We may email you if we need clarification or stronger official-source evidence.</p>
  <p style="margin:0.75rem 0 0;">Help more collectors discover your event by linking to <a id="directory-link" href="https://coinshownearme.com/">Coin Show Near Me</a> from your official show, club, or venue website.</p>
  <button type="button" class="show-submission-copy" id="copy-directory-link">Copy directory link</button>
  <span id="copy-directory-status" aria-live="polite" style="display:inline-block;margin-left:0.5rem;font-size:0.82rem;"></span>
</div>
</div>

Already listed? Open the show page and use **Organize this show? Request verification**, **Update show info**, or **Request listing review or removal** instead.

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
    if (window.coinNormalizeFormUrls) { window.coinNormalizeFormUrls(form); }
    if (!form.reportValidity()) { return; }
    var now = new Date().toISOString();
    setFormValue('pageUrl', window.location.href);
    setFormValue('referringUrl', document.referrer || '');
    setFormValue('submittedAt', now);
    setFormValue('contactConsentTimestamp', now);
    if (window.coinFormSpamCheck && !window.coinFormSpamCheck(form)) { return; }
    window.coinSubmitForm(form).then(function() {
      form.style.display = 'none';
      var success = document.getElementById('show-submission-success');
      success.style.display = 'block';
      success.focus();
    });
  });

  var copyButton = document.getElementById('copy-directory-link');
  var copyStatus = document.getElementById('copy-directory-status');
  if (copyButton) {
    copyButton.addEventListener('click', function() {
      var directoryUrl = 'https://coinshownearme.com/';
      if (!navigator.clipboard || !navigator.clipboard.writeText) {
        copyStatus.textContent = 'Select and copy the link above.';
        return;
      }
      navigator.clipboard.writeText(directoryUrl).then(function() {
        copyStatus.textContent = 'Link copied.';
      }).catch(function() {
        copyStatus.textContent = 'Select and copy the link above.';
      });
    });
  }
})();
</script>
