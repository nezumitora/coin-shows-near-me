---
layout: default
title: "Collection Tracker"
description: "A future coin collection tracker for coins, bullion, purchase price, melt value, notes, photos, and collection totals."
permalink: /tools/collection-tracker/
parent: "Tools"
nav_order: 3
breadcrumb_parent: "Tools"
breadcrumb_parent_url: "/tools/"
breadcrumb_current: "Collection Tracker"
---

# Collection Tracker

This tool is planned for a future release.

<div class="public-card" style="margin:1rem 0 1.25rem;">
  <h2 style="margin-top:0 !important;">Track your collection in one place</h2>
  <p>A future tool to help collectors track coins, bullion, purchase price, melt value, notes, photos, and collection totals.</p>
  <p style="margin-bottom:0;">The goal is a simple database or Google Sheets-style workflow that keeps your collection organized while still making it easy to estimate total metal value.</p>
</div>

## Planned Features

- Coin and bullion inventory tracking
- Purchase price and date fields
- Melt value estimates from current metal prices
- Notes for condition, grade, provenance, or dealer details
- Photo attachments for coin images and receipts
- Collection totals by metal, type, and estimated value

{% if site.review_mode %}
<style>
.tracker-survey { margin:1.5rem 0 0; padding:1.25rem; border:1px solid var(--coin-border); border-radius:10px; background:#f8fafc; }
.tracker-survey h2 { margin-top:0 !important; }
.tracker-survey-form { display:flex; flex-direction:column; gap:1rem; }
.tracker-survey-form fieldset { margin:0; padding:0.9rem 1rem; border:1px solid #cbd5e1; border-radius:8px; background:#fff; }
.tracker-survey-form legend { padding:0 0.35rem; color:var(--coin-navy); font-weight:800; }
.tracker-survey-options { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:0.55rem 1rem; }
.tracker-survey-option { display:flex; align-items:flex-start; gap:0.45rem; color:#334155; font-size:0.9rem; line-height:1.4; }
.tracker-survey-option input { margin-top:0.18rem; accent-color:var(--coin-gold); }
.tracker-survey-label { display:flex; flex-direction:column; gap:0.3rem; color:#334155; font-size:0.85rem; font-weight:700; }
.tracker-survey-label input,
.tracker-survey-label textarea { width:100%; box-sizing:border-box; padding:0.7rem 0.8rem; border:1px solid #cbd5e1; border-radius:6px; background:#fff; color:#111; font:inherit; }
.tracker-survey-label textarea { min-height:90px; resize:vertical; }
.tracker-survey-contact { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:0.75rem; }
.tracker-survey-consent { display:flex; align-items:flex-start; gap:0.5rem; color:#475569; font-size:0.8rem; line-height:1.45; }
.tracker-survey-consent input { margin-top:0.15rem; accent-color:var(--coin-gold); }
.tracker-survey-form button { align-self:flex-start; padding:0.7rem 1.3rem; border:2px solid var(--coin-gold); border-radius:6px; background:var(--coin-navy); color:#fff; cursor:pointer; font-weight:800; }
.tracker-survey-form button:hover { background:var(--coin-gold-light); color:var(--coin-navy); }
.tracker-survey-note { color:#64748b; font-size:0.8rem; line-height:1.5; }
.tracker-survey-success { display:none; padding:1rem; border:1px solid #86efac; border-radius:8px; background:#ecfdf5; color:#14532d; }
@media (max-width:700px) {
  .tracker-survey-options,
  .tracker-survey-contact { grid-template-columns:1fr; }
}
</style>

<div class="tracker-survey">
  <h2>Help shape the Collection Tracker</h2>
  <p>Two quick choices will help us prioritize the first version. Your name and email are optional.</p>
  <form class="tracker-survey-form" id="tracker-feature-survey" action="#" data-form-key="mykleozw" method="POST">
    <input type="hidden" name="_subject" value="[Coin Show Near Me][Feature Survey] Collection Tracker feedback">
    <input type="hidden" name="form_type" value="feature_feedback">
    <input type="hidden" name="source" value="Website">
    <input type="hidden" name="formName" value="collectionTrackerFeatureSurvey">
    <input type="hidden" name="ctaCode" value="collection_tracker_feature_survey">
    <input type="hidden" name="sourceDetail" value="Collection Tracker feature survey">
    <input type="hidden" name="pageUrl" value="">
    <input type="hidden" name="referringUrl" value="">
    <input type="hidden" name="submittedAt" value="">
    <input type="hidden" name="contactConsentTimestamp" value="">
    <input type="hidden" name="contactConsentVersion" value="coin-feature-feedback-reply-v1">
    <input type="hidden" name="contactConsentText" value="If I provide an email address, Coin Show Near Me may reply about this feature feedback. This does not join a reminder or marketing list.">

    <fieldset>
      <legend>How do you track your collection today?</legend>
      <div class="tracker-survey-options">
        <label class="tracker-survey-option"><input type="radio" name="tracking_method" value="notebook" required> Notebook or paper records</label>
        <label class="tracker-survey-option"><input type="radio" name="tracking_method" value="spreadsheet"> Spreadsheet</label>
        <label class="tracker-survey-option"><input type="radio" name="tracking_method" value="app"> Collection app or software</label>
        <label class="tracker-survey-option"><input type="radio" name="tracking_method" value="none"> I do not currently track it</label>
        <label class="tracker-survey-option"><input type="radio" name="tracking_method" value="other"> Other</label>
      </div>
    </fieldset>

    <fieldset>
      <legend>Which feature would help you most?</legend>
      <div class="tracker-survey-options">
        <label class="tracker-survey-option"><input type="radio" name="priority_feature" value="inventory" required> Simple coin and bullion inventory</label>
        <label class="tracker-survey-option"><input type="radio" name="priority_feature" value="value_totals"> Melt value and collection totals</label>
        <label class="tracker-survey-option"><input type="radio" name="priority_feature" value="purchase_history"> Purchase price and history</label>
        <label class="tracker-survey-option"><input type="radio" name="priority_feature" value="photos_notes"> Photos and notes</label>
        <label class="tracker-survey-option"><input type="radio" name="priority_feature" value="other"> Other</label>
      </div>
    </fieldset>

    <label class="tracker-survey-label">What is the one feature you would want most? (optional)
      <textarea name="feature_message" maxlength="500" placeholder="A short answer is plenty."></textarea>
    </label>

    <div class="tracker-survey-contact">
      <label class="tracker-survey-label">Name (optional)
        <input type="text" name="name" maxlength="100" autocomplete="name">
      </label>
      <label class="tracker-survey-label">Email (optional, only if you want a reply)
        <input type="email" name="email" autocomplete="email">
      </label>
    </div>

    <label class="tracker-survey-consent">
      <input type="checkbox" name="contactConsent" value="yes">
      <span>If I provide an email address, Coin Show Near Me may reply about this feature feedback. This does not join a reminder or marketing list.</span>
    </label>

    <p class="tracker-survey-note">Please do not include coin inventories, photos, receipts, passwords, account numbers, identification documents, or private addresses. See our <a href="/legal/privacy-policy/">Privacy Policy</a>.</p>
    <button type="submit">Send Feature Feedback</button>
  </form>
  <div class="tracker-survey-success" id="tracker-survey-success" role="status" tabindex="-1">Thank you. Your answers will be used to help plan the first version of the Collection Tracker.</div>
</div>

<script>
(function() {
  var form = document.getElementById('tracker-feature-survey');
  if (!form) { return; }
  var email = form.querySelector('[name="email"]');
  var consent = form.querySelector('[name="contactConsent"]');
  var localReviewMode = {% if site.review_mode %}true{% else %}false{% endif %};

  function setFormValue(name, value) {
    var field = form.querySelector('[name="' + name + '"]');
    if (field) { field.value = value; }
  }

  function validateOptionalContact() {
    var needsConsent = email.value.trim() !== '';
    consent.required = needsConsent;
    consent.setCustomValidity(needsConsent && !consent.checked ? 'Please allow a reply or remove the optional email address.' : '');
  }

  email.addEventListener('input', validateOptionalContact);
  consent.addEventListener('change', validateOptionalContact);
  form.addEventListener('submit', function(event) {
    event.preventDefault();
    validateOptionalContact();
    if (!form.reportValidity()) { return; }
    var now = new Date().toISOString();
    setFormValue('pageUrl', window.location.href);
    setFormValue('referringUrl', document.referrer || '');
    setFormValue('submittedAt', now);
    setFormValue('contactConsentTimestamp', consent.checked ? now : '');
    if (window.coinFormSpamCheck && !window.coinFormSpamCheck(form)) { return; }

    function showSuccess(message) {
      form.style.display = 'none';
      var success = document.getElementById('tracker-survey-success');
      if (message) { success.textContent = message; }
      success.style.display = 'block';
      success.focus();
    }

    if (localReviewMode) {
      showSuccess('Local review complete — nothing was sent. The production form will collect the two choices and optional feedback after approval.');
      return;
    }

    window.coinSubmitForm(form).then(function() {
      showSuccess('Thank you. Your answers will be used to help plan the first version of the Collection Tracker.');
    });
  });
})();
</script>
{% else %}
<div class="public-cta" style="margin:1.5rem 0 0;">
  <h2>Want this tool?</h2>
  <p>Tell us how you currently track your collection so we can shape the first version around real collector workflows.</p>
  <a href="/contact/">Share Feedback</a>
</div>
{% endif %}
