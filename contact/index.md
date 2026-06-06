---
layout: default
title: "Contact Us"
seo_title: "Contact Us | Coin Show Near Me"
seo_description: "Get in touch with Coin Show Near Me. Submit a show, report an error, ask a question, or register as a dealer."
permalink: /contact/
nav_order: 8
breadcrumb_current: "Contact Us"
---

# Contact Us

Have a question, found an error, or want to submit a show? We'd love to hear from you.

<div class="contact-grid" style="margin:0 0 1.25rem;">
  <div class="contact-card">
    <h2 style="margin-top:0 !important;">Fastest Ways to Help</h2>
    <p style="margin-bottom:0.75rem;">Send the important details once, and we can route it to the right place.</p>
    <ul style="margin-bottom:0;">
      <li><strong>Submit a show</strong> — name, date, venue, and organizer link.</li>
      <li><strong>Report an error</strong> — tell us which listing needs a fix.</li>
      <li><strong>Dealer listing</strong> — share your shop, online store, or specialties.</li>
    </ul>
  </div>
  <div class="contact-card">
    <h2 style="margin-top:0 !important;">Follow Along</h2>
    <p style="margin-bottom:0.5rem;">Social profiles are coming soon. These are placeholders for the local preview.</p>
    <div class="contact-socials">
      <a class="contact-social-link" href="#" aria-label="Facebook coming soon"><span class="contact-social-icon">f</span> Facebook</a>
      <a class="contact-social-link" href="#" aria-label="Instagram coming soon"><span class="contact-social-icon">◎</span> Instagram</a>
      <a class="contact-social-link" href="#" aria-label="X Twitter coming soon"><span class="contact-social-icon">𝕏</span> X/Twitter</a>
      <a class="contact-social-link" href="#" aria-label="LinkedIn coming soon"><span class="contact-social-icon">in</span> LinkedIn</a>
    </div>
  </div>
</div>

<div class="notify-section" style="margin:1rem 0 1.25rem;padding:1.25rem;">
<h3>Send Us a Message</h3>
<p>Fill out the form below and we'll get back to you as soon as we can.</p>

<form class="notify-form" id="contact-form" action="https://formspree.io/f/mykleozw" method="POST">
<input type="hidden" name="_subject" value="Coin Show Near Me — Contact Form">
<input type="hidden" name="form_type" value="contact">
<div class="form-row">
<input type="text" name="name" placeholder="Your name" style="background:#fff;color:#111;">
<input type="email" name="email" placeholder="Email address" required style="background:#fff;color:#111;">
</div>
<select name="reason" style="width:100%;padding:0.6rem 0.75rem;border:1px solid var(--coin-border);border-radius:6px;font-size:0.9rem;background:#fff;color:#111;margin-top:0.5rem;">
<option value="">What can we help with?</option>
<option value="submit-show">Submit a coin show</option>
<option value="report-error">Report an error or outdated listing</option>
<option value="dealer-registration">Register as a dealer</option>
<option value="general-question">General question</option>
<option value="feedback">Feedback or suggestion</option>
<option value="other">Other</option>
</select>
<textarea name="message" placeholder="Your message..." style="background:#fff;color:#111;margin-top:0.5rem;"></textarea>
<button type="submit">Send Message</button>
</form>
<div class="notify-success" id="contact-success" style="background:#065f46;margin-top:0.5rem;">
Thank you for reaching out! We'll get back to you shortly.
</div>
</div>

<div class="public-grid" style="margin-top:1rem;">
  <div class="public-card">
    <h2 style="margin-top:0 !important;">Quick Links</h2>
    <ul style="margin-bottom:0;">
      <li><a href="/states/">Find Coin Shows by State</a></li>
      <li><a href="/coin-shows-this-weekend/">Coin Shows This Weekend</a></li>
      <li><a href="/tools/melt-value-calculator/">Melt Value Calculator</a></li>
      <li><a href="/guides/beginners-guide/">Beginner's Guide to Coin Shows</a></li>
      <li><a href="/dealers/">Find a Dealer</a></li>
    </ul>
  </div>
  <div class="public-cta public-cta--compact">
    <h2>Have a show, shop, or collection question?</h2>
    <p>Tell us about your show, shop, or collection request and we’ll use it to improve the directory and dealer matching tools.</p>
    <a href="/dealers/">Find a Dealer</a>
  </div>
</div>

<script>
var form = document.getElementById('contact-form');
if (form) {
  form.addEventListener('submit', function(e) {
    e.preventDefault();
    var data = new FormData(form);
    fetch(form.action, {
      method: 'POST',
      body: data,
      headers: { 'Accept': 'application/json' }
    }).then(function(response) {
      if (response.ok) {
        form.style.display = 'none';
        document.getElementById('contact-success').style.display = 'block';
      }
    });
  });
}
</script>
