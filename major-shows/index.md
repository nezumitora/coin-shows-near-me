---
layout: default
title: "Major Coin Shows"
seo_title: "Major Coin Shows in the US — National Coin Show Directory | Coin Show Near Me"
seo_description: "Browse major national and regional coin shows across the United States, including FUN, Long Beach Expo, Whitman, Central States, NYINC, PAN, and ANA events."
permalink: /major-shows/
breadcrumb_current: "Major Shows"
---

# Major Coin Shows

These are the larger national and regional coin shows that collectors and dealers often travel for. They typically have bigger bourse floors, more dealers, more grading or auction activity, and stronger collector attendance than small local club shows.

{% assign featured_ids = "fun-convention,long-beach-expo,whitman-coin-expo,csns-convention,nyinc,pan-coin-show,ana-worlds-fair" | split: "," %}

<div class="major-shows-grid">
{% for fid in featured_ids %}
  {% for show in site.data.shows %}
    {% if show.id == fid %}
    <article class="major-show-card">
      <div class="major-show-card-top">
        <span class="major-show-badge">Major Show</span>
        <span class="major-show-state">{{ show.state }}</span>
      </div>
      <h2><a href="{{ site.baseurl }}/shows/{{ show.id }}/">{{ show.name }}</a></h2>
      <p class="major-show-location">{{ show.city }}, {{ show.state_name }}{% if show.venue and show.venue != "" %} — {{ show.venue }}{% endif %}</p>
      <p class="major-show-meta">
        {% if show.next_date and show.next_date != "TBD" %}<strong>Next:</strong> {{ show.next_date }}{% else %}<strong>Next:</strong> Date TBD{% endif %}
        {% if show.frequency %}<span>|</span> <strong>Frequency:</strong> {{ show.frequency }}{% endif %}
      </p>
      {% if show.notes and show.notes != "" %}<p class="major-show-notes">{{ show.notes }}</p>{% endif %}
    </article>
    {% endif %}
  {% endfor %}
{% endfor %}
</div>

## Planning a Coin Show Trip?

For larger shows, always verify dates, venue details, hotel blocks, dealer lists, and admission requirements on the official organizer website before booking travel.
