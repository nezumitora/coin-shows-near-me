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
<strong>We're building something great.</strong> Our full-featured coin show directory with dealer verification, pre-show offers, and collection tools is launching soon. In the meantime, browse our directory of 90+ coin shows across all 50 states below.
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

If you run a coin show and want it listed, or if you notice missing or outdated information, please [open an issue on GitHub](https://github.com/nezumitora/coin-shows-near-me/issues) with the show details.

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
