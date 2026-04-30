---
layout: default
title: "Melt Value Calculator"
seo_title: "Coin Melt Value Calculator — Silver & Gold Coin Melt Values | Coin Show Near Me"
seo_description: "Calculate the melt value of US silver and gold coins. Instant calculator for pre-1965 silver quarters, dimes, half dollars, silver dollars, and gold coins. Get an offer from a local dealer."
permalink: /tools/melt-value-calculator/
parent: "Tools"
nav_order: 1
breadcrumb_current: "Melt Value Calculator"
---

<style>
  .calc-container {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.5rem;
    margin: 1.5rem 0;
  }
  @media (max-width: 768px) {
    .calc-container { grid-template-columns: 1fr; }
  }
  .calc-panel {
    border: 1px solid #e5e7eb;
    border-radius: 0.75rem;
    padding: 1.25rem;
    background: #f9fafb;
  }
  .calc-panel h2 {
    margin-top: 0;
    font-size: 1.15rem;
  }
  .field-group {
    margin-bottom: 0.75rem;
  }
  .field-label {
    display: block;
    font-size: 0.85rem;
    font-weight: 600;
    margin-bottom: 0.2rem;
    color: #374151;
  }
  .field-input, .field-select {
    width: 100%;
    padding: 0.45rem 0.6rem;
    border: 1px solid #e5e7eb;
    border-radius: 0.5rem;
    font-size: 0.95rem;
    background: #fff;
    outline: none;
  }
  .field-input:focus, .field-select:focus {
    border-color: #4b5563;
    box-shadow: 0 0 0 1px rgba(75,85,99,0.18);
  }
  .calc-btn {
    display: inline-block;
    padding: 0.5rem 1.25rem;
    background: #4b5563;
    color: #fff;
    border: none;
    border-radius: 999px;
    font-size: 0.95rem;
    font-weight: 600;
    cursor: pointer;
    margin-top: 0.25rem;
  }
  .calc-btn:hover { background: #374151; }
  .result-box {
    margin-top: 1rem;
    padding: 1rem;
    background: #ecfdf5;
    border: 1px solid #a7f3d0;
    border-radius: 0.5rem;
    display: none;
  }
  .result-box .big-number {
    font-size: 1.8rem;
    font-weight: 700;
    color: #065f46;
    margin: 0;
  }
  .result-box .detail {
    font-size: 0.85rem;
    color: #6b7280;
    margin: 0.25rem 0 0;
  }
  .coin-table {
    width: 100%;
    border-collapse: collapse;
    margin: 1rem 0;
    font-size: 0.9rem;
  }
  .coin-table th, .coin-table td {
    padding: 0.5rem 0.6rem;
    border-bottom: 1px solid #e5e7eb;
    text-align: left;
  }
  .coin-table th {
    background: #f3f4f6;
    font-weight: 600;
    font-size: 0.8rem;
    text-transform: uppercase;
    color: #6b7280;
  }
  .coin-table tr:hover { background: #f9fafb; }
  .offer-form {
    display: flex;
    flex-direction: column;
    gap: 0.6rem;
  }
  .offer-success {
    display: none;
    padding: 0.75rem;
    background: #ecfdf5;
    border: 1px solid #a7f3d0;
    border-radius: 0.5rem;
    color: #065f46;
    font-size: 0.9rem;
  }
  .offer-error {
    font-size: 0.8rem;
    color: #b91c1c;
    display: none;
  }
  .spot-note {
    font-size: 0.8rem;
    color: #6b7280;
    margin-top: 0.25rem;
  }
</style>

# Coin Melt Value Calculator

Calculate the **metal melt value** of your US silver and gold coins instantly. Spot prices are loaded automatically and updated every hour — or enter your own.

<div class="spot-ticker" id="calc-spot-ticker" style="display:none;">
  <div class="spot-ticker-item">
    <span class="spot-ticker-label">Gold</span>
    <span class="spot-ticker-price" id="calc-spot-gold-display">--</span>
  </div>
  <span class="spot-ticker-sep">|</span>
  <div class="spot-ticker-item">
    <span class="spot-ticker-label">Silver</span>
    <span class="spot-ticker-price" id="calc-spot-silver-display">--</span>
  </div>
  <span class="spot-ticker-sep">|</span>
  <div class="spot-ticker-item">
    <span class="spot-ticker-label">Platinum</span>
    <span class="spot-ticker-price" id="calc-spot-platinum-display">--</span>
  </div>
  <span class="spot-ticker-sep">|</span>
  <div class="spot-ticker-item">
    <span class="spot-ticker-label">Palladium</span>
    <span class="spot-ticker-price" id="calc-spot-palladium-display">--</span>
  </div>
  <div class="spot-ticker-updated" id="calc-spot-updated"></div>
</div>

<div class="calc-container">

<div class="calc-panel">
<h2>Calculator</h2>

<div class="field-group">
  <label class="field-label" for="spot-silver">Silver Spot Price ($/oz)</label>
  <input class="field-input" type="number" id="spot-silver" step="0.01" value="78.67" min="0">
  <div class="spot-note" id="silver-spot-note">Loading live price...</div>
</div>

<div class="field-group">
  <label class="field-label" for="spot-gold">Gold Spot Price ($/oz)</label>
  <input class="field-input" type="number" id="spot-gold" step="0.01" value="4789.70" min="0">
  <div class="spot-note" id="gold-spot-note">Loading live price...</div>
</div>

<h3 style="margin:1rem 0 0.5rem;font-size:1rem;">Silver Coins (90% Silver, Pre-1965)</h3>

<div class="field-group">
  <label class="field-label" for="qty-dimes">Roosevelt/Mercury Dimes</label>
  <input class="field-input" type="number" id="qty-dimes" value="0" min="0">
</div>

<div class="field-group">
  <label class="field-label" for="qty-quarters">Washington Quarters</label>
  <input class="field-input" type="number" id="qty-quarters" value="0" min="0">
</div>

<div class="field-group">
  <label class="field-label" for="qty-halves">Walking Liberty / Franklin / Kennedy Halves (Pre-1965)</label>
  <input class="field-input" type="number" id="qty-halves" value="0" min="0">
</div>

<div class="field-group">
  <label class="field-label" for="qty-morgan">Morgan / Peace Silver Dollars</label>
  <input class="field-input" type="number" id="qty-morgan" value="0" min="0">
</div>

<div class="field-group">
  <label class="field-label" for="qty-ase">American Silver Eagles (1 oz .999)</label>
  <input class="field-input" type="number" id="qty-ase" value="0" min="0">
</div>

<h3 style="margin:1rem 0 0.5rem;font-size:1rem;">40% Silver (1965-1970 Kennedy Halves)</h3>

<div class="field-group">
  <label class="field-label" for="qty-40halves">40% Kennedy Half Dollars</label>
  <input class="field-input" type="number" id="qty-40halves" value="0" min="0">
</div>

<h3 style="margin:1rem 0 0.5rem;font-size:1rem;">Gold Coins</h3>

<div class="field-group">
  <label class="field-label" for="qty-age-1oz">American Gold Eagle (1 oz)</label>
  <input class="field-input" type="number" id="qty-age-1oz" value="0" min="0">
</div>

<div class="field-group">
  <label class="field-label" for="qty-age-half">American Gold Eagle (1/2 oz)</label>
  <input class="field-input" type="number" id="qty-age-half" value="0" min="0">
</div>

<div class="field-group">
  <label class="field-label" for="qty-age-quarter">American Gold Eagle (1/4 oz)</label>
  <input class="field-input" type="number" id="qty-age-quarter" value="0" min="0">
</div>

<div class="field-group">
  <label class="field-label" for="qty-age-tenth">American Gold Eagle (1/10 oz)</label>
  <input class="field-input" type="number" id="qty-age-tenth" value="0" min="0">
</div>

<button class="calc-btn" id="calc-btn" type="button">Calculate Melt Value</button>

<div class="result-box" id="result-box">
  <p class="big-number" id="result-total">$0.00</p>
  <p class="detail" id="result-detail"></p>
</div>

<div id="breakdown-area" style="display:none;margin-top:1rem;">
<h3 style="font-size:1rem;margin-bottom:0.5rem;">Breakdown</h3>
<table class="coin-table">
  <thead>
    <tr><th>Coin</th><th>Qty</th><th>Silver/Gold (oz)</th><th>Melt Value</th></tr>
  </thead>
  <tbody id="breakdown-body"></tbody>
</table>
</div>

</div>

<div class="calc-panel">
<h2>Get an Offer on Your Coins</h2>
<p style="font-size:0.9rem;color:#6b7280;margin:0 0 0.75rem;">Have coins to sell? Fill out this form and a local coin dealer will contact you with an offer. No obligation.</p>

<form class="offer-form" id="offer-form" novalidate>
  <div class="field-group">
    <label class="field-label" for="offer-name">Your Name *</label>
    <input class="field-input" type="text" id="offer-name" required>
    <div class="offer-error" data-for="name"></div>
  </div>

  <div class="field-group">
    <label class="field-label" for="offer-email">Email Address *</label>
    <input class="field-input" type="email" id="offer-email" required>
    <div class="offer-error" data-for="email"></div>
  </div>

  <div class="field-group">
    <label class="field-label" for="offer-phone">Phone Number</label>
    <input class="field-input" type="tel" id="offer-phone">
  </div>

  <div class="field-group">
    <label class="field-label" for="offer-zip">ZIP Code *</label>
    <input class="field-input" type="text" id="offer-zip" maxlength="10" required>
    <div class="offer-error" data-for="zip"></div>
  </div>

  <div class="field-group">
    <label class="field-label" for="offer-description">What do you have to sell? *</label>
    <textarea class="field-input" id="offer-description" rows="4" placeholder="e.g., 50 pre-1965 Washington quarters, 10 Morgan silver dollars, a bag of wheat pennies..." required></textarea>
    <div class="offer-error" data-for="description"></div>
  </div>

  <div class="field-group">
    <label class="field-label" for="offer-melt">Estimated Melt Value (auto-filled)</label>
    <input class="field-input" type="text" id="offer-melt" readonly style="background:#f3f4f6;">
  </div>

  <div style="display:flex;align-items:flex-start;gap:0.4rem;font-size:0.85rem;color:#6b7280;">
    <input type="checkbox" id="offer-consent" style="margin-top:0.2rem;">
    <label for="offer-consent">I agree to be contacted by a coin dealer about my coins. *</label>
  </div>
  <div class="offer-error" data-for="consent"></div>

  <button class="calc-btn" type="submit">Submit for Offer</button>
</form>

<div class="offer-success" id="offer-success">
  Your request has been submitted. A dealer in your area will contact you soon.
</div>
</div>

</div>

<script>
(function() {
  /* Silver content in troy ounces per coin (90% silver coins) */
  var SILVER_CONTENT = {
    dimes:    0.07234,   /* 2.5g x 0.900 / 31.1035 */
    quarters: 0.18084,   /* 6.25g x 0.900 / 31.1035 */
    halves:   0.36169,   /* 12.5g x 0.900 / 31.1035 */
    morgan:   0.77344,   /* 26.73g x 0.900 / 31.1035 */
    ase:      1.00000,   /* 1 troy oz .999 fine */
    halves40: 0.14792    /* 11.5g x 0.400 / 31.1035 */
  };

  var GOLD_CONTENT = {
    age1oz:    0.9167,   /* AGE is 22k (91.67% gold), but contains exactly 1 oz fine gold */
    ageHalf:   0.5000,
    ageQtr:    0.2500,
    ageTenth:  0.1000
  };

  /* Actually AGE contains exact fine gold weights: */
  GOLD_CONTENT.age1oz = 1.0000;
  GOLD_CONTENT.ageHalf = 0.5000;
  GOLD_CONTENT.ageQtr = 0.2500;
  GOLD_CONTENT.ageTenth = 0.1000;

  var calcBtn = document.getElementById('calc-btn');
  var resultBox = document.getElementById('result-box');
  var resultTotal = document.getElementById('result-total');
  var resultDetail = document.getElementById('result-detail');
  var breakdownArea = document.getElementById('breakdown-area');
  var breakdownBody = document.getElementById('breakdown-body');

  function getVal(id) { return parseFloat(document.getElementById(id).value) || 0; }

  function formatUSD(n) { return '$' + n.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }

  calcBtn.addEventListener('click', function() {
    var spotSilver = getVal('spot-silver');
    var spotGold = getVal('spot-gold');

    var rows = [
      { name: 'Roosevelt/Mercury Dimes', qty: getVal('qty-dimes'), oz: SILVER_CONTENT.dimes, metal: 'silver' },
      { name: 'Washington Quarters', qty: getVal('qty-quarters'), oz: SILVER_CONTENT.quarters, metal: 'silver' },
      { name: 'Half Dollars (90%)', qty: getVal('qty-halves'), oz: SILVER_CONTENT.halves, metal: 'silver' },
      { name: 'Morgan/Peace Dollars', qty: getVal('qty-morgan'), oz: SILVER_CONTENT.morgan, metal: 'silver' },
      { name: 'American Silver Eagles', qty: getVal('qty-ase'), oz: SILVER_CONTENT.ase, metal: 'silver' },
      { name: '40% Kennedy Halves', qty: getVal('qty-40halves'), oz: SILVER_CONTENT.halves40, metal: 'silver' },
      { name: 'Gold Eagle 1 oz', qty: getVal('qty-age-1oz'), oz: GOLD_CONTENT.age1oz, metal: 'gold' },
      { name: 'Gold Eagle 1/2 oz', qty: getVal('qty-age-half'), oz: GOLD_CONTENT.ageHalf, metal: 'gold' },
      { name: 'Gold Eagle 1/4 oz', qty: getVal('qty-age-quarter'), oz: GOLD_CONTENT.ageQtr, metal: 'gold' },
      { name: 'Gold Eagle 1/10 oz', qty: getVal('qty-age-tenth'), oz: GOLD_CONTENT.ageTenth, metal: 'gold' }
    ];

    var total = 0;
    var totalSilverOz = 0;
    var totalGoldOz = 0;
    var html = '';

    rows.forEach(function(r) {
      if (r.qty <= 0) return;
      var spot = r.metal === 'gold' ? spotGold : spotSilver;
      var metalOz = r.qty * r.oz;
      var value = metalOz * spot;
      total += value;
      if (r.metal === 'silver') totalSilverOz += metalOz;
      else totalGoldOz += metalOz;

      html += '<tr>' +
        '<td>' + r.name + '</td>' +
        '<td>' + r.qty + '</td>' +
        '<td>' + metalOz.toFixed(4) + ' oz ' + r.metal + '</td>' +
        '<td>' + formatUSD(value) + '</td>' +
        '</tr>';
    });

    if (total > 0) {
      resultBox.style.display = 'block';
      resultTotal.textContent = formatUSD(total);

      var parts = [];
      if (totalSilverOz > 0) parts.push(totalSilverOz.toFixed(2) + ' oz silver');
      if (totalGoldOz > 0) parts.push(totalGoldOz.toFixed(4) + ' oz gold');
      resultDetail.textContent = 'Total metal content: ' + parts.join(' + ');

      breakdownBody.innerHTML = html;
      breakdownArea.style.display = 'block';

      /* Auto-fill the offer form */
      document.getElementById('offer-melt').value = formatUSD(total);
    } else {
      resultBox.style.display = 'none';
      breakdownArea.style.display = 'none';
    }
  });

  /* Offer form */
  var offerForm = document.getElementById('offer-form');
  var offerSuccess = document.getElementById('offer-success');

  offerForm.addEventListener('submit', function(e) {
    e.preventDefault();
    var valid = true;

    function setErr(field, msg) {
      var el = document.querySelector('.offer-error[data-for="' + field + '"]');
      if (el) { el.textContent = msg; el.style.display = msg ? 'block' : 'none'; }
      if (msg) valid = false;
    }

    var name = document.getElementById('offer-name').value.trim();
    var email = document.getElementById('offer-email').value.trim();
    var zip = document.getElementById('offer-zip').value.trim();
    var desc = document.getElementById('offer-description').value.trim();
    var consent = document.getElementById('offer-consent').checked;

    setErr('name', name ? '' : 'Please enter your name.');
    setErr('email', email.includes('@') ? '' : 'Please enter a valid email.');
    setErr('zip', zip.length >= 5 ? '' : 'Please enter your ZIP code.');
    setErr('description', desc ? '' : 'Please describe what you have to sell.');
    setErr('consent', consent ? '' : 'You must agree to be contacted.');

    if (!valid) return;

    /* For now, show success. In production, this would POST to an API. */
    offerForm.style.display = 'none';
    offerSuccess.style.display = 'block';
  });

  /* Auto-load spot prices from pre-fetched JSON */
  function formatTickerPrice(price) {
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
      /* Update calculator input fields */
      if (data.silver) {
        document.getElementById('spot-silver').value = data.silver.toFixed(2);
        document.getElementById('silver-spot-note').textContent = 'Live price loaded · Updated ' + timeAgo(data.updated_at);
      } else {
        document.getElementById('silver-spot-note').textContent = 'Enter today\'s silver spot price per troy ounce.';
      }
      if (data.gold) {
        document.getElementById('spot-gold').value = data.gold.toFixed(2);
        document.getElementById('gold-spot-note').textContent = 'Live price loaded · Updated ' + timeAgo(data.updated_at);
      } else {
        document.getElementById('gold-spot-note').textContent = 'Enter today\'s gold spot price per troy ounce.';
      }

      /* Update ticker display */
      var el = function(id) { return document.getElementById(id); };
      el('calc-spot-gold-display').textContent = formatTickerPrice(data.gold);
      el('calc-spot-silver-display').textContent = formatTickerPrice(data.silver);
      el('calc-spot-platinum-display').textContent = formatTickerPrice(data.platinum);
      el('calc-spot-palladium-display').textContent = formatTickerPrice(data.palladium);
      var updated = data.updated_at ? 'Updated ' + timeAgo(data.updated_at) + ' · Spot prices per troy oz' : 'Spot prices per troy oz';
      el('calc-spot-updated').textContent = updated;
      el('calc-spot-ticker').style.display = 'flex';
    })
    .catch(function() {
      document.getElementById('silver-spot-note').textContent = 'Enter today\'s silver spot price per troy ounce.';
      document.getElementById('gold-spot-note').textContent = 'Enter today\'s gold spot price per troy ounce.';
    });
})();
</script>

---

## US Coin Silver Content Reference

Not sure about the silver content of your coins? Here's a quick reference:

| Coin | Years | Composition | Silver Weight (troy oz) |
|------|-------|-------------|------------------------|
| Roosevelt Dime | 1946-1964 | 90% Silver | 0.0723 oz |
| Mercury Dime | 1916-1945 | 90% Silver | 0.0723 oz |
| Washington Quarter | 1932-1964 | 90% Silver | 0.1808 oz |
| Walking Liberty Half | 1916-1947 | 90% Silver | 0.3617 oz |
| Franklin Half Dollar | 1948-1963 | 90% Silver | 0.3617 oz |
| Kennedy Half Dollar | 1964 | 90% Silver | 0.3617 oz |
| Kennedy Half Dollar | 1965-1970 | 40% Silver | 0.1479 oz |
| Morgan Silver Dollar | 1878-1921 | 90% Silver | 0.7734 oz |
| Peace Silver Dollar | 1921-1935 | 90% Silver | 0.7734 oz |
| American Silver Eagle | 1986-present | 99.9% Silver | 1.0000 oz |

## What is Melt Value?

The **melt value** of a coin is the value of the precious metal it contains, based on the current spot price. It represents the minimum intrinsic value of a coin — what the metal itself would be worth if melted down.

For example, a pre-1965 Washington quarter contains approximately 0.1808 troy ounces of silver. If silver is trading at $78/oz, that quarter's melt value is about $14.11 — regardless of its face value of $0.25.

### Melt Value vs. Collector Value

Melt value is the **floor price** for a coin. Many coins are worth significantly more than melt value due to:

- **Rarity** — low mintage coins command premiums
- **Condition** — uncirculated or high-grade coins are worth more
- **Key dates** — certain years/mint marks are especially valuable
- **Collector demand** — popular series like Morgan dollars carry premiums

**If you think your coins might have collector value**, bring them to a [local coin show]({{ site.baseurl }}/states/) for a free appraisal before selling for melt.

## Sell Your Coins at a Coin Show

Coin shows are the best place to get competitive offers on your coins. Multiple dealers under one roof means you can compare prices. Find a [coin show near you]({{ site.baseurl }}/).

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Coin Melt Value Calculator",
  "url": "{{ site.url }}{{ site.baseurl }}/tools/melt-value-calculator/",
  "description": "Calculate the melt value of US silver and gold coins based on current spot prices.",
  "applicationCategory": "FinanceApplication",
  "operatingSystem": "Any",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  }
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is the melt value of a coin?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The melt value of a coin is the value of the precious metal it contains, based on the current spot price. It represents the minimum intrinsic value of a coin — what the metal itself would be worth if melted down. For example, a pre-1965 Washington quarter contains approximately 0.1808 troy ounces of silver."
      }
    },
    {
      "@type": "Question",
      "name": "What is the difference between melt value and collector value?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Melt value is the floor price for a coin — the value of its metal content alone. Many coins are worth significantly more than melt value due to rarity, condition (grade), key dates, and collector demand. For example, Morgan silver dollars typically sell well above melt value because of their popularity with collectors."
      }
    },
    {
      "@type": "Question",
      "name": "How much silver is in a pre-1965 quarter?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Pre-1965 Washington quarters contain 90% silver and have approximately 0.1808 troy ounces of silver content. At current spot prices, this makes each quarter worth significantly more than its 25-cent face value."
      }
    },
    {
      "@type": "Question",
      "name": "Where is the best place to sell silver and gold coins?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Coin shows are one of the best places to sell coins because multiple dealers under one roof means you can get competing offers. Use our Melt Value Calculator to know the minimum metal value before selling, and bring your coins to a local coin show for the best prices."
      }
    }
  ]
}
</script>
