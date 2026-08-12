---
layout: default
title: "Sales Tax Guide"
description: "Primary-source-reviewed state guide to sales tax on gold, silver, bullion, and coins, with unconfirmed classifications clearly marked as pending."
permalink: /tools/sales-tax-guide/
parent: "Tools"
nav_order: 2
breadcrumb_parent: "Tools"
breadcrumb_parent_url: "/tools/"
breadcrumb_current: "Sales Tax Guide"
---

# Sales Tax on Coins & Precious Metals by State

Heading to a coin show or buying bullion online? Whether you pay sales tax on gold, silver, and coins depends on the jurisdiction, product, transaction, and current law. This guide displays a classification only after checking an exact government source.

Use the search below to find your state's tax rules, or browse the full list.

<div class="tax-search-panel">
  <input type="text" id="state-tax-search" placeholder="Search by state name..." style="padding:0.75rem 1rem;border:2px solid #e5ddd0;border-radius:8px;font-size:1rem;outline:none;" onfocus="this.style.borderColor='#b8860b'" onblur="this.style.borderColor='#e5ddd0'">
</div>

<div style="display:flex;gap:0.5rem;margin-bottom:1.5rem;flex-wrap:wrap;">
  <button class="tax-filter-btn active" data-filter="all" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#1a2332;color:#fff;font-weight:600;">All States</button>
  <button class="tax-filter-btn" data-filter="exempt" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#fff;color:#555;">Tax-Free</button>
  <button class="tax-filter-btn" data-filter="threshold" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#fff;color:#555;">Has Threshold</button>
  <button class="tax-filter-btn" data-filter="taxed" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#fff;color:#555;">Taxed</button>
  <button class="tax-filter-btn" data-filter="pending" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#fff;color:#555;">Review Pending</button>
</div>

<div style="margin-bottom:1rem;font-size:0.9rem;color:#555;" id="tax-results-count">Showing all states</div>

<div id="state-tax-grid">
{% for tax in site.data.state_tax %}
<div class="tax-card" data-state="{{ tax.state | downcase }}" data-status="{% unless tax.source_checked %}pending{% else %}{% if tax.bullion_exempt %}{% if tax.threshold == '$0' or tax.threshold == 'N/A' %}exempt{% else %}threshold{% endif %}{% else %}taxed{% endif %}{% endunless %}" style="border:1px solid #e5ddd0;border-radius:10px;padding:1rem 1.25rem;margin-bottom:0.75rem;background:#fff;transition:all 0.2s;">
  <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:0.5rem;">
    <a href="{{ site.baseurl }}/tools/sales-tax-guide/{{ tax.slug }}/" style="font-size:1.05rem;font-weight:700;color:#2c2c2c;text-decoration:none;">{{ tax.state }}</a>
    <span style="font-size:0.75rem;font-weight:700;padding:0.2rem 0.6rem;border-radius:4px;{% unless tax.source_checked %}background:#ffedd5;color:#9a3412;{% else %}{% if tax.bullion_exempt %}background:#dcfce7;color:#16a34a;{% else %}background:#fef2f2;color:#dc2626;{% endif %}{% endunless %}">
      {% unless tax.source_checked %}REVIEW PENDING{% else %}{% if tax.bullion_exempt %}EXEMPT / CONDITIONAL{% else %}GENERALLY TAXED{% endif %}{% endunless %}
    </span>
  </div>
  <p style="font-size:0.85rem;color:#555;margin:0 0 0.5rem;line-height:1.5;">{% if tax.source_checked %}{{ tax.notes }}{% else %}Exact current statute, regulation, or tax-agency guidance still being verified. No settled classification is displayed.{% endif %}</p>
  {% if tax.source_checked %}
  <div style="display:flex;gap:1rem;font-size:0.8rem;color:#888;">
    <span>Rate: {{ tax.sales_tax }}</span>
    {% if tax.threshold and tax.threshold != "N/A" and tax.threshold != "$0" %}
    <span style="color:#f59e0b;font-weight:600;">Min: {{ tax.threshold }}</span>
    {% endif %}
  </div>
  {% endif %}
</div>
{% endfor %}
</div>

<div id="tax-no-results" style="display:none;text-align:center;padding:2rem;color:#888;">
  <p>No states match your search.</p>
</div>

## Audit Status

- Green and red classifications appear only after an exact current government source has been checked.
- Orange entries remain visible for navigation but intentionally suppress their old classification while primary-source review is pending.
- “Exempt” never means every coin or precious-metal item qualifies; product form, metal content, value, seller, documentation, and local rules may matter.

## Tips for Coin Show Buyers

1. **Know before you go** — check your state's rules above before buying at a coin show
2. **Threshold conditions** — a minimum amount alone may not create an exemption; confirm the qualifying products, transaction rules, seller requirements, and local treatment
3. **Keep receipts** — some states require documentation for the exemption, especially for large purchases
4. **Online purchases** — buying from an out-of-state dealer may trigger "use tax" in your home state
5. **Numismatic vs. bullion** — some states treat collector coins differently than bullion sold for metal value

## Find a Show Near You

Know your state's tax situation? Now find a coin show: [Browse all coin shows](/states/) or check what's happening [this weekend](/coin-shows-this-weekend/).

---

*This guide is for informational purposes only and does not constitute tax or legal advice. Tax laws change frequently — always verify with your state tax authority or a qualified tax professional. Primary-source audit updated August 1, 2026.*

<script>
/* State tax search and filter */
(function() {
  var searchInput = document.getElementById('state-tax-search');
  var cards = document.querySelectorAll('.tax-card');
  var filterBtns = document.querySelectorAll('.tax-filter-btn');
  var countEl = document.getElementById('tax-results-count');
  var noResults = document.getElementById('tax-no-results');
  var activeFilter = 'all';

  function filterCards() {
    var term = searchInput.value.toLowerCase().trim();
    var visible = 0;
    for (var i = 0; i < cards.length; i++) {
      var card = cards[i];
      var stateName = card.getAttribute('data-state');
      var status = card.getAttribute('data-status');
      var matchSearch = !term || stateName.indexOf(term) !== -1;
      var matchFilter = activeFilter === 'all' || status === activeFilter;
      if (matchSearch && matchFilter) {
        card.style.display = '';
        visible++;
      } else {
        card.style.display = 'none';
      }
    }
    countEl.textContent = visible === cards.length ? 'Showing all states' : 'Showing ' + visible + ' of ' + cards.length + ' states';
    noResults.style.display = visible === 0 ? 'block' : 'none';
  }

  searchInput.addEventListener('input', filterCards);

  for (var i = 0; i < filterBtns.length; i++) {
    filterBtns[i].addEventListener('click', function() {
      for (var j = 0; j < filterBtns.length; j++) {
        filterBtns[j].style.background = '#fff';
        filterBtns[j].style.color = '#555';
        filterBtns[j].classList.remove('active');
      }
      this.style.background = '#1a2332';
      this.style.color = '#fff';
      this.classList.add('active');
      activeFilter = this.getAttribute('data-filter');
      filterCards();
    });
  }
})();
</script>
