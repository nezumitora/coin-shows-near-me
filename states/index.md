---
layout: default
title: "Browse by State"
seo_title: "Coin Shows by State — Find Coin Shows in Every US State | Coin Show Near Me"
seo_description: "Browse coin shows in all 50 US states. Find upcoming coin shows, expos, and numismatic conventions near you with dates, venues, and details."
permalink: /states/
nav_order: 2
breadcrumb_current: "States"
---

# Coin Shows by State

Find coin shows in every US state. Click a state below to see all upcoming shows, venues, and schedules.

{% assign shows = site.data.shows %}

<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:0.5rem;margin:1.5rem 0;">
{% for state in site.data.states %}
  {% assign state_count = shows | where: "state", state.abbrev | size %}
  <a href="{{ site.baseurl }}/states/{{ state.slug }}/" style="display:block;padding:0.6rem 0.8rem;border:1px solid #e5e7eb;border-radius:0.5rem;text-decoration:none;color:#111827;background:#f9fafb;">
    <strong>{{ state.name }}</strong>
    <span style="color:#6b7280;font-size:0.85rem;"> ({{ state_count }})</span>
  </a>
{% endfor %}
</div>
