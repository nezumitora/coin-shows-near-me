---
layout: default
title: "Coin Shows Near Me — Find Upcoming Coin Shows in Your Area"
seo_title: "Coin Shows Near Me — US Coin Show Directory & Schedule 2025-2026"
seo_description: "Find coin shows near you. Complete directory of 90+ coin shows across all 50 US states with dates, venues, and details. Updated regularly."
permalink: /
nav_order: 1
---

# Coin Shows Near Me

<div class="launch-banner">
<strong>Site Under Construction</strong> — We're building the most complete coin show directory in the US, with dealer verification, pre-show offers, and collection tools. Our full site is launching soon. In the meantime, browse our directory of 90+ coin shows across all 50 states below.

<hr style="border:none;border-top:2px solid #daa520;margin:1rem 0;">

<p style="margin:0 0 0.75rem;font-size:0.95rem;">Be notified when our website officially launches, or if you have any questions please provide your email address.</p>

<form class="notify-form" id="notify-form" action="https://formspree.io/f/mykleozw" method="POST">
<input type="hidden" name="_subject" value="Coin Show Near Me — New Signup">
<div class="form-row">
<input type="text" name="name" placeholder="Name (optional)" style="background:#fff;color:#111;">
<input type="email" name="email" placeholder="Email address" required style="background:#fff;color:#111;">
<button type="submit">Sign Up for Updates</button>
</div>
<textarea name="message" placeholder="Questions, show submissions, or just say hello (optional)" style="background:#fff;color:#111;margin-top:0.5rem;"></textarea>
</form>
<div class="notify-success" id="notify-success" style="background:#065f46;margin-top:0.5rem;">
Thank you! We'll notify you when we launch. If you submitted a show or question, we'll get back to you shortly.
</div>
</div>

<div class="spot-ticker" id="spot-ticker" style="display:none;">
  <div class="spot-ticker-item">
    <span class="spot-ticker-label">Gold</span>
    <span class="spot-ticker-price" id="spot-gold-price">--</span>
  </div>
  <span class="spot-ticker-sep">|</span>
  <div class="spot-ticker-item">
    <span class="spot-ticker-label">Silver</span>
    <span class="spot-ticker-price" id="spot-silver-price">--</span>
  </div>
  <span class="spot-ticker-sep">|</span>
  <div class="spot-ticker-item">
    <span class="spot-ticker-label">Platinum</span>
    <span class="spot-ticker-price" id="spot-platinum-price">--</span>
  </div>
  <span class="spot-ticker-sep">|</span>
  <div class="spot-ticker-item">
    <span class="spot-ticker-label">Palladium</span>
    <span class="spot-ticker-price" id="spot-palladium-price">--</span>
  </div>
  <div class="spot-ticker-updated" id="spot-ticker-updated"></div>
</div>

The most complete directory of coin shows in the United States. Find upcoming coin shows, numismatic conventions, and coin expos near you — with dates, venues, and details for every show.

---

## Find Coin Shows This Weekend

Looking for a coin show happening soon? Check our **[Coin Shows This Weekend](/coin-shows-this-weekend/)** page for shows happening in the next few days.

---

## Browse Coin Shows by State

{% assign shows = site.data.shows %}

<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:0.5rem;margin:1.5rem 0;">
{% for state in site.data.states %}
  {% assign state_count = shows | where: "state", state.abbrev | size %}
  {% if state_count > 0 %}
  <a href="{{ site.baseurl }}/states/{{ state.slug }}/" style="display:block;padding:0.5rem 0.75rem;border:1px solid #e5e7eb;border-radius:0.5rem;text-decoration:none;color:#111827;background:#f9fafb;font-size:0.9rem;">
    <strong>{{ state.name }}</strong>
    <span style="color:#6b7280;font-size:0.8rem;">({{ state_count }})</span>
  </a>
  {% endif %}
{% endfor %}
</div>

<p style="text-align:center;margin:1rem 0;"><a href="{{ site.baseurl }}/states/">View all 50 states &rarr;</a></p>

---

## Featured Major Coin Shows

These are the largest and most well-known coin shows in the United States — worth traveling to if you're a serious collector or dealer.

{% assign featured_ids = "fun-convention,long-beach-expo,whitman-coin-expo,csns-convention,nyinc,pan-coin-show,ana-worlds-fair" | split: "," %}

{% for fid in featured_ids %}
{% for show in site.data.shows %}
{% if show.id == fid %}
{% include show-card.html show=show %}
{% endif %}
{% endfor %}
{% endfor %}

---

## What is a Coin Show?

A **coin show** (also called a coin expo, coin convention, or numismatic bourse) is an event where coin dealers, collectors, and enthusiasts gather to buy, sell, and trade coins, paper currency, bullion, tokens, and other numismatic collectibles.

Coin shows range from small local events with a handful of tables to major national conventions with hundreds of dealers and thousands of attendees.

### What to Expect at a Coin Show

- **Dealers** selling U.S. and world coins, paper currency, gold and silver bullion, tokens, and medals
- **Free appraisals** — most dealers will look at what you have and give you an honest assessment
- **Buying and selling** — bring coins you want to sell, or cash to buy
- **Education** — many shows feature talks, presentations, and youth programs
- **Networking** — meet other collectors and join local coin clubs

### Tips for First-Time Coin Show Attendees

1. **Bring cash.** Most dealers prefer cash and may offer discounts for cash purchases.
2. **Arrive early.** The best deals often go quickly, especially at smaller shows.
3. **Bring a loupe or magnifying glass.** Examine coins before you buy.
4. **Set a budget.** It's easy to get carried away — decide what you're willing to spend.
5. **Ask questions.** Dealers are generally happy to educate newcomers.
6. **Verify dates before traveling.** Show dates and venues can change — always check the official website.

---

## About This Directory

Coin Show Near Me is a free, community-driven directory of recurring coin shows across the United States. We compile data from numismatic associations, coin clubs, and event promoters to create the most complete and up-to-date coin show directory available.

**Data sources include:**
- State and regional numismatic associations
- Individual coin club websites
- National event promoters
- Community submissions

> **Dates and venues can change.** Always verify details on the official show or club website before traveling.

### Missing a Show?

Know of a coin show not in our directory? Use the form at the top of this page to let us know — include the show name, city, state, and any details you have.

<script>
var form = document.getElementById('notify-form');
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
        document.getElementById('notify-success').style.display = 'block';
      }
    });
  });
}
</script>

<script>
// Load spot prices from pre-fetched JSON (updated hourly by GitHub Actions)
(function() {
  function formatPrice(price) {
    if (price == null) return '--';
    return '$' + price.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  }
  function timeAgo(dateStr) {
    var now = new Date();
    var then = new Date(dateStr);
    var mins = Math.round((now - then) / 60000);
    if (mins < 1) return 'just now';
    if (mins < 60) return mins + ' min ago';
    var hrs = Math.round(mins / 60);
    if (hrs < 24) return hrs + ' hr' + (hrs > 1 ? 's' : '') + ' ago';
    var days = Math.round(hrs / 24);
    return days + ' day' + (days > 1 ? 's' : '') + ' ago';
  }
  fetch('/assets/data/spot-prices.json')
    .then(function(r) { return r.json(); })
    .then(function(data) {
      document.getElementById('spot-gold-price').textContent = formatPrice(data.gold);
      document.getElementById('spot-silver-price').textContent = formatPrice(data.silver);
      document.getElementById('spot-platinum-price').textContent = formatPrice(data.platinum);
      document.getElementById('spot-palladium-price').textContent = formatPrice(data.palladium);
      var updated = data.updated_at ? 'Updated ' + timeAgo(data.updated_at) + ' · Spot prices per troy oz' : 'Spot prices per troy oz';
      document.getElementById('spot-ticker-updated').textContent = updated;
      document.getElementById('spot-ticker').style.display = 'flex';
      // Store prices globally for the melt calculator link
      window.SPOT_PRICES = data;
    })
    .catch(function() {
      // Silently fail — ticker stays hidden
    });
})();
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "Coin Show Near Me",
  "url": "{{ site.url }}{{ site.baseurl }}/",
  "description": "Complete directory of coin shows across the United States. Find upcoming coin shows, numismatic conventions, and coin expos near you.",
  "potentialAction": {
    "@type": "SearchAction",
    "target": "{{ site.url }}{{ site.baseurl }}/states/{search_term}",
    "query-input": "required name=search_term"
  }
}
</script>
