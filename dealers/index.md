---
layout: default
title: "Find a Dealer"
seo_title: "Find a Coin Dealer Near You — Online & Local Dealers | Coin Show Near Me"
seo_description: "Find trusted coin dealers and precious metals dealers — browse brick-and-mortar shops, online bullion dealers, and auction houses. Search by location or specialty."
permalink: /dealers/
nav_order: 7
has_children: true
breadcrumb_current: "Find a Dealer"
---

# Find a Coin Dealer

Browse trusted coin dealers, bullion sellers, and auction houses. Search by name, location, or filter by type.

<div style="margin:1.5rem 0;">
  <input type="text" id="dealer-search" placeholder="Search by dealer name, city, or state..." style="width:100%;max-width:500px;padding:0.75rem 1rem;border:2px solid #e5ddd0;border-radius:8px;font-size:1rem;outline:none;" onfocus="this.style.borderColor='#b8860b'" onblur="this.style.borderColor='#e5ddd0'">
</div>

<div style="display:flex;gap:0.5rem;margin-bottom:1.5rem;flex-wrap:wrap;">
  <button class="dealer-filter-btn active" data-filter="all" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#1a2332;color:#fff;font-weight:600;">All Dealers</button>
  <button class="dealer-filter-btn" data-filter="brick-and-mortar" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#fff;color:#555;">Brick & Mortar</button>
  <button class="dealer-filter-btn" data-filter="online" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#fff;color:#555;">Online</button>
  <button class="dealer-filter-btn" data-filter="both" style="padding:0.4rem 1rem;border:1px solid #e5ddd0;border-radius:20px;font-size:0.85rem;cursor:pointer;background:#fff;color:#555;">Online + Storefront</button>
</div>

<div style="margin-bottom:1rem;font-size:0.9rem;color:#555;" id="dealer-results-count">Showing all dealers</div>

<div id="dealer-grid">
{% for dealer in site.data.dealers %}
<div class="dealer-card-item" data-name="{{ dealer.name | downcase }}" data-city="{{ dealer.city | downcase }}" data-state="{{ dealer.state_name | downcase }}" data-state-abbrev="{{ dealer.state | downcase }}" data-type="{{ dealer.type }}" style="border:1px solid #e5ddd0;border-radius:10px;padding:1.25rem;margin-bottom:0.75rem;background:#fff;transition:all 0.2s;">
  <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:0.5rem;flex-wrap:wrap;gap:0.5rem;">
    <div>
      <a href="{{ dealer.website }}" target="_blank" rel="noopener noreferrer" style="font-size:1.1rem;font-weight:700;color:#2c2c2c;text-decoration:none;">{{ dealer.name }}</a>
      <span style="display:inline-block;margin-left:0.5rem;font-size:0.7rem;font-weight:700;padding:0.15rem 0.5rem;border-radius:4px;vertical-align:middle;{% if dealer.type == 'online' %}background:#e0f2fe;color:#0369a1;{% elsif dealer.type == 'brick-and-mortar' %}background:#fef3c7;color:#92400e;{% else %}background:#f0fdf4;color:#166534;{% endif %}">
        {% if dealer.type == 'online' %}ONLINE{% elsif dealer.type == 'brick-and-mortar' %}LOCAL SHOP{% else %}ONLINE + LOCAL{% endif %}
      </span>
    </div>
    {% if dealer.accepts_trade_ins %}
    <span style="font-size:0.7rem;font-weight:600;color:#16a34a;background:#dcfce7;padding:0.15rem 0.5rem;border-radius:4px;">BUYS COINS</span>
    {% endif %}
  </div>
  <div style="font-size:0.85rem;color:#555;margin-bottom:0.5rem;">{{ dealer.city }}, {{ dealer.state_name }}</div>
  <p style="font-size:0.88rem;color:#555;line-height:1.6;margin:0 0 0.75rem;">{{ dealer.description }}</p>
  <div style="display:flex;flex-wrap:wrap;gap:0.4rem;margin-bottom:0.75rem;">
    {% for spec in dealer.specialties %}
    <span style="font-size:0.75rem;padding:0.2rem 0.6rem;border-radius:4px;background:#f5f0e8;color:#555;">{{ spec }}</span>
    {% endfor %}
  </div>
  <div style="display:flex;gap:0.75rem;align-items:center;flex-wrap:wrap;">
    <a href="{{ dealer.website }}" target="_blank" rel="noopener noreferrer" style="font-size:0.85rem;font-weight:600;color:#b8860b;text-decoration:none;">Visit Website &rarr;</a>
    {% if dealer.ships_nationwide %}
    <span style="font-size:0.75rem;color:#888;">Ships nationwide</span>
    {% endif %}
  </div>
</div>
{% endfor %}
</div>

<div id="dealer-no-results" style="display:none;text-align:center;padding:2rem;color:#888;">
  <p>No dealers match your search.</p>
</div>

---

## Are You a Dealer?

<div style="background:linear-gradient(135deg, #1a2332 0%, #2c3e50 100%);color:#f1f5f9;padding:2rem;border-radius:10px;border:2px solid #b8860b;margin:1.5rem 0;">
  <h3 style="color:#daa520;font-size:1.2rem;font-weight:700;margin:0 0 0.5rem;">Get Listed in Our Directory</h3>
  <p style="color:#cbd5e1;font-size:0.92rem;line-height:1.6;margin:0 0 1rem;">Join our growing directory of trusted coin dealers. Whether you're an online seller, a brick-and-mortar shop, or an auction house — get discovered by collectors looking for dealers near them and online.</p>
  <ul style="list-style:none;padding:0;margin:0 0 1.25rem;">
    <li style="color:#94a3b8;font-size:0.85rem;padding:0.25rem 0;padding-left:1.25rem;position:relative;"><span style="position:absolute;left:0;color:#daa520;font-weight:700;">&#10003;</span> Free listing in our dealer directory</li>
    <li style="color:#94a3b8;font-size:0.85rem;padding:0.25rem 0;padding-left:1.25rem;position:relative;"><span style="position:absolute;left:0;color:#daa520;font-weight:700;">&#10003;</span> Get matched with attendees at shows you attend</li>
    <li style="color:#94a3b8;font-size:0.85rem;padding:0.25rem 0;padding-left:1.25rem;position:relative;"><span style="position:absolute;left:0;color:#daa520;font-weight:700;">&#10003;</span> Receive pre-show offer requests from sellers</li>
    <li style="color:#94a3b8;font-size:0.85rem;padding:0.25rem 0;padding-left:1.25rem;position:relative;"><span style="position:absolute;left:0;color:#daa520;font-weight:700;">&#10003;</span> Link to your website and show your specialties</li>
  </ul>
  <a href="/#signup" style="display:inline-block;background:#b8860b;color:#fff;padding:0.65rem 2rem;border-radius:6px;font-weight:700;font-size:0.95rem;text-decoration:none;">Register as a Dealer</a>
</div>

## How to Choose a Dealer

Whether you're buying your first silver coin or selling a valuable collection, here's what to look for:

### Buying

- **Compare premiums** — the markup over spot price varies by dealer. Check 2-3 dealers before buying.
- **Check shipping costs** — some dealers offer free shipping above a threshold ($99-$199 is common).
- **Read reviews** — look for dealers with established track records. Check BBB ratings and online reviews.
- **Payment methods** — credit card is convenient but often costs 3-4% more. ACH/wire/check usually gets the best price.
- **Buyback policy** — good dealers buy back what they sell, often at competitive rates.

### Selling

- **Get multiple offers** — never sell to the first dealer. Compare at least 3 offers.
- **Coin shows are best** — multiple dealers in one room means competitive offers. [Find a show near you](/states/).
- **Know your melt value** — use the [Melt Value Calculator](/tools/melt-value-calculator/) as your price floor.
- **Certified coins sell higher** — PCGS/NGC graded coins are easier for dealers to price and resell.
- **Auction for rare coins** — if a coin books over $500, consider Heritage or Great Collections for maximum return.

### Red Flags

- Pressure to buy immediately or "limited time" offers
- Premiums more than 2x what other dealers charge
- No physical address or phone number
- Unwilling to provide references or credentials
- Refuses to buy back what they sell

---

*Know a trusted dealer we should add? [Let us know](/#signup).*

<script>
/* Dealer search and filter */
(function() {
  var searchInput = document.getElementById('dealer-search');
  var cards = document.querySelectorAll('.dealer-card-item');
  var filterBtns = document.querySelectorAll('.dealer-filter-btn');
  var countEl = document.getElementById('dealer-results-count');
  var noResults = document.getElementById('dealer-no-results');
  var activeFilter = 'all';

  function filterCards() {
    var term = searchInput.value.toLowerCase().trim();
    var visible = 0;
    for (var i = 0; i < cards.length; i++) {
      var card = cards[i];
      var name = card.getAttribute('data-name');
      var city = card.getAttribute('data-city');
      var state = card.getAttribute('data-state');
      var stateAbbrev = card.getAttribute('data-state-abbrev');
      var type = card.getAttribute('data-type');
      var matchSearch = !term || name.indexOf(term) !== -1 || city.indexOf(term) !== -1 || state.indexOf(term) !== -1 || stateAbbrev.indexOf(term) !== -1;
      var matchFilter = activeFilter === 'all' || type === activeFilter;
      if (matchSearch && matchFilter) {
        card.style.display = '';
        visible++;
      } else {
        card.style.display = 'none';
      }
    }
    countEl.textContent = visible === cards.length ? 'Showing all dealers' : 'Showing ' + visible + ' of ' + cards.length + ' dealers';
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
