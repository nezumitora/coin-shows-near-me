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

<div class="notify-section">
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

---

## Other Ways to Reach Us

- **Submit a show we're missing** -- use the form above or [sign up for updates](/#signup) and mention the show
- **Report an error** -- dates, venues, or organizer details that need updating? Let us know
- **Dealer registration** -- want to be listed in our [dealer directory](/dealers/)? Fill out the form above or [register here](/#signup)

---

## Quick Links

- [Find Coin Shows by State](/states/)
- [Coin Shows This Weekend](/coin-shows-this-weekend/)
- [Melt Value Calculator](/tools/melt-value-calculator/)
- [Beginner's Guide to Coin Shows](/guides/beginners-guide/)
- [Find a Dealer](/dealers/)

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
