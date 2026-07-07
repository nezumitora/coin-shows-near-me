---
layout: default
title: "Melt Value Calculator"
seo_title: "Coin Melt Value Calculator — US, Canadian, British & World Coin Melt Values | Coin Show Near Me"
seo_description: "Calculate the melt value of US, Canadian, British and world silver and gold coins. Instant calculator for pre-1965 silver, pre-1933 gold, Maple Leafs, Sovereigns, Krugerrands, and more."
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
    max-width: 100%;
    min-width: 0;
    overflow: hidden;
  }
  .calc-container > * { min-width: 0; }
  @media (max-width: 768px) {
    .calc-container { grid-template-columns: 1fr; }
  }
  .calc-panel {
    border: 1px solid #e5ddd0;
    border-radius: 1rem;
    padding: 1.35rem;
    background: linear-gradient(180deg, #fffdf8 0%, #f8f2e8 100%);
    box-shadow: 0 10px 22px rgba(14, 35, 56, 0.07);
    box-sizing: border-box;
    max-width: 100%;
    min-width: 0;
    overflow: hidden;
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
    box-sizing: border-box;
  }
  .field-input:focus, .field-select:focus {
    border-color: #4b5563;
    box-shadow: 0 0 0 1px rgba(75,85,99,0.18);
  }
  .calc-btn {
    display: inline-block;
    padding: 0.5rem 1.25rem;
    background: var(--coinshows-navy, #0E2338);
    color: #fff;
    border: none;
    border-radius: 999px;
    font-size: 0.95rem;
    font-weight: 600;
    cursor: pointer;
    margin-top: 0.25rem;
  }
  .calc-btn:hover { background: #2c3e50; }
  .result-box {
    margin-top: 1rem;
    padding: 1rem;
    background: linear-gradient(180deg, #fff9ed 0%, #faf6ed 100%);
    border: 1px solid rgba(184, 134, 11, 0.35);
    border-left: 5px solid var(--coinshows-navy, #0E2338);
    border-radius: 0.75rem;
    display: none;
    max-width: 100%;
    overflow-wrap: anywhere;
  }
  .result-box .big-number {
    font-size: 1.8rem;
    font-weight: 700;
    color: var(--coinshows-navy, #0E2338);
    margin: 0;
  }
  .result-box .detail {
    font-size: 0.85rem;
    color: #6b7280;
    margin: 0.25rem 0 0;
  }
  .coin-table {
    width: 100%;
    min-width: 0;
    border-collapse: collapse;
    margin: 1rem 0;
    font-size: 0.9rem;
    table-layout: fixed;
  }
  .coin-table-wrap {
    display: block;
    width: 100%;
    max-width: 100%;
    min-width: 0;
    overflow-x: auto;
    overflow-y: hidden;
    -webkit-overflow-scrolling: touch;
    border: 1px solid rgba(184, 134, 11, 0.35);
    border-radius: 0.75rem;
    background: #faf6ed;
    overscroll-behavior-x: contain;
    box-sizing: border-box;
    box-shadow: 0 8px 18px rgba(14, 35, 56, 0.06);
  }
  .coin-table-wrap .coin-table {
    margin: 0;
    max-width: 100%;
  }
  .coin-table th, .coin-table td {
    padding: 0.5rem 0.6rem;
    border-bottom: 1px solid #eadfca;
    text-align: left;
    overflow-wrap: anywhere;
    word-break: normal;
  }
  .coin-table th {
    background: linear-gradient(180deg, var(--coinshows-navy, #0E2338) 0%, #1a3652 100%);
    border-bottom: 2px solid #b8860b;
    color: #fff;
    font-weight: 800;
    font-size: 0.8rem;
    letter-spacing: 0.04em;
    text-transform: uppercase;
  }
  .coin-table th:first-child { border-left: 4px solid #b8860b; }
  .coin-table th:last-child { color: #ffd46b; }
  .coin-table td {
    background: #fffaf0;
    color: #1f2937;
  }
  .coin-table td:last-child {
    color: var(--coinshows-navy, #0E2338);
    font-weight: 800;
  }
  .coin-table tbody tr:nth-child(even) td { background: #f7eedf; }
  .coin-table tr:hover td { background: #f3e3c7; }
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
  /* Tab styles */
  .calc-tabs {
    display: flex;
    gap: 0;
    margin: 1rem 0 0;
    border-bottom: 2px solid #e5e7eb;
    max-width: 100%;
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
  }
  .calc-tab {
    padding: 0.5rem 1rem;
    font-size: 0.85rem;
    font-weight: 600;
    color: #6b7280;
    background: none;
    border: none;
    cursor: pointer;
    border-bottom: 2px solid transparent;
    margin-bottom: -2px;
    transition: color 0.2s, border-color 0.2s;
    white-space: nowrap;
  }
  .calc-tab:hover { color: #374151; }
  .calc-tab.active {
    color: #1a2332;
    border-bottom-color: #b8860b;
  }
  .tab-panel { display: none; padding-top: 0.75rem; }
  .tab-panel.active { display: block; }
  .tab-section-title {
    margin: 0.75rem 0 0.4rem;
    font-size: 0.95rem;
    font-weight: 700;
    color: #1a2332;
  }
  .calc-intro-card {
    background: #faf6ed;
    border: 1px solid #e5ddd0;
    border-left: 5px solid #b8860b;
    border-radius: 1rem;
    margin: 0 0 1.25rem;
    padding: 1rem 1.15rem;
  }
  .calc-intro-card p { margin: 0; }
  .calc-panel-accent {
    background: linear-gradient(180deg, #f8f2e8 0%, #ffffff 100%);
  }
  @media (max-width: 640px) {
    .calc-tabs { overflow-x: auto; }
    .calc-tab { padding: 0.5rem 0.75rem; }
    .coin-table-wrap { overflow-x: auto; }
    .coin-table { min-width: 0; width: 100%; font-size: 0.86rem; table-layout: fixed; }
    .coin-table thead { display: none; }
    .coin-table,
    .coin-table tbody,
    .coin-table tr,
    .coin-table td { display: block; width: 100%; }
    .coin-table tr {
      background: #fffaf0;
      border-bottom: 1px solid #e5ddd0;
      border-left: 4px solid #b8860b;
      padding: 0.55rem 0.65rem;
    }
    .coin-table tr:nth-child(even) { background: #f7eedf; }
    .coin-table tr:last-child { border-bottom: 0; }
    .coin-table td {
      background: transparent !important;
      border-bottom: 0;
      display: flex;
      justify-content: space-between;
      gap: 1rem;
      padding: 0.22rem 0;
      white-space: normal;
      overflow-wrap: anywhere;
    }
    .coin-table td::before {
      content: attr(data-label);
      color: var(--coinshows-navy, #0E2338);
      flex: 0 0 6.4rem;
      font-size: 0.78rem;
      font-weight: 700;
      text-transform: uppercase;
    }
    .coin-table td:first-child {
      display: block;
      font-weight: 700;
      margin-bottom: 0.2rem;
    }
    .coin-table td:first-child::before { display: none; }
  }
</style>

# Coin Melt Value Calculator

Calculate the **metal melt value** of your coins instantly. Covers US, Canadian, British, and world silver & gold coins. Spot prices load automatically and update every hour.

<div class="calc-intro-card">
  <p><strong>Tip:</strong> Use melt value as your baseline before asking dealers for offers. Rare dates, condition, and grading can add value above metal content.</p>
</div>

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

<div class="calc-tabs">
  <button class="calc-tab active" data-tab="us">US Silver</button>
  <button class="calc-tab" data-tab="usgold">US Gold</button>
  <button class="calc-tab" data-tab="canadian">Canadian</button>
  <button class="calc-tab" data-tab="british">British</button>
  <button class="calc-tab" data-tab="world">World</button>
</div>

<!-- US Silver Tab -->
<div class="tab-panel active" id="tab-us">
<div class="tab-section-title">90% Silver (Pre-1965)</div>
<div class="field-group">
  <label class="field-label" for="qty-dimes">Roosevelt / Mercury Dimes</label>
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

<div class="tab-section-title">40% Silver</div>
<div class="field-group">
  <label class="field-label" for="qty-40halves">40% Kennedy Half Dollars (1965-1970)</label>
  <input class="field-input" type="number" id="qty-40halves" value="0" min="0">
</div>

<div class="tab-section-title">35% Silver (War Nickels)</div>
<div class="field-group">
  <label class="field-label" for="qty-war-nickels">War Nickels (1942-1945, large mintmark above Monticello)</label>
  <input class="field-input" type="number" id="qty-war-nickels" value="0" min="0">
</div>
</div>

<!-- US Gold Tab -->
<div class="tab-panel" id="tab-usgold">
<div class="tab-section-title">American Gold Eagles</div>
<div class="field-group">
  <label class="field-label" for="qty-age-1oz">Gold Eagle (1 oz)</label>
  <input class="field-input" type="number" id="qty-age-1oz" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-age-half">Gold Eagle (1/2 oz)</label>
  <input class="field-input" type="number" id="qty-age-half" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-age-quarter">Gold Eagle (1/4 oz)</label>
  <input class="field-input" type="number" id="qty-age-quarter" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-age-tenth">Gold Eagle (1/10 oz)</label>
  <input class="field-input" type="number" id="qty-age-tenth" value="0" min="0">
</div>

<div class="tab-section-title">Gold Buffalo</div>
<div class="field-group">
  <label class="field-label" for="qty-buffalo-gold">Gold Buffalo (1 oz .9999)</label>
  <input class="field-input" type="number" id="qty-buffalo-gold" value="0" min="0">
</div>

<div class="tab-section-title">Pre-1933 US Gold</div>
<div class="field-group">
  <label class="field-label" for="qty-gold-1">$1 Gold (Type I/II/III, 1849-1889)</label>
  <input class="field-input" type="number" id="qty-gold-1" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-gold-250">$2.50 Quarter Eagle (1796-1929)</label>
  <input class="field-input" type="number" id="qty-gold-250" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-gold-3">$3 Gold (1854-1889)</label>
  <input class="field-input" type="number" id="qty-gold-3" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-gold-5">$5 Half Eagle (1795-1929)</label>
  <input class="field-input" type="number" id="qty-gold-5" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-gold-10">$10 Eagle (1795-1933)</label>
  <input class="field-input" type="number" id="qty-gold-10" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-gold-20">$20 Double Eagle (1849-1933)</label>
  <input class="field-input" type="number" id="qty-gold-20" value="0" min="0">
</div>
</div>

<!-- Canadian Tab -->
<div class="tab-panel" id="tab-canadian">
<div class="tab-section-title">Canadian Silver (80%, Pre-1968)</div>
<div class="field-group">
  <label class="field-label" for="qty-ca-dimes">Canadian Dimes (Pre-1968, 80% silver)</label>
  <input class="field-input" type="number" id="qty-ca-dimes" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-ca-quarters">Canadian Quarters (Pre-1968, 80% silver)</label>
  <input class="field-input" type="number" id="qty-ca-quarters" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-ca-halves">Canadian Half Dollars (Pre-1968, 80% silver)</label>
  <input class="field-input" type="number" id="qty-ca-halves" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-ca-dollars">Canadian Silver Dollars (Pre-1968, 80% silver)</label>
  <input class="field-input" type="number" id="qty-ca-dollars" value="0" min="0">
</div>

<div class="tab-section-title">Canadian Maple Leafs</div>
<div class="field-group">
  <label class="field-label" for="qty-ca-sml">Silver Maple Leaf (1 oz .9999)</label>
  <input class="field-input" type="number" id="qty-ca-sml" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-ca-gml-1oz">Gold Maple Leaf (1 oz .9999)</label>
  <input class="field-input" type="number" id="qty-ca-gml-1oz" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-ca-gml-half">Gold Maple Leaf (1/2 oz)</label>
  <input class="field-input" type="number" id="qty-ca-gml-half" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-ca-gml-quarter">Gold Maple Leaf (1/4 oz)</label>
  <input class="field-input" type="number" id="qty-ca-gml-quarter" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-ca-gml-tenth">Gold Maple Leaf (1/10 oz)</label>
  <input class="field-input" type="number" id="qty-ca-gml-tenth" value="0" min="0">
</div>
</div>

<!-- British Tab -->
<div class="tab-panel" id="tab-british">
<div class="tab-section-title">British Gold</div>
<div class="field-group">
  <label class="field-label" for="qty-sovereign">Gold Sovereign (0.2354 oz)</label>
  <input class="field-input" type="number" id="qty-sovereign" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-britannia-gold">Gold Britannia (1 oz .9999)</label>
  <input class="field-input" type="number" id="qty-britannia-gold" value="0" min="0">
</div>

<div class="tab-section-title">British Silver</div>
<div class="field-group">
  <label class="field-label" for="qty-britannia-silver">Silver Britannia (1 oz .999)</label>
  <input class="field-input" type="number" id="qty-britannia-silver" value="0" min="0">
</div>

<div class="tab-section-title">Pre-1947 Sterling Silver (50% silver)</div>
<div class="field-group">
  <label class="field-label" for="qty-uk-sixpence">Sixpence (Pre-1947)</label>
  <input class="field-input" type="number" id="qty-uk-sixpence" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-uk-shilling">Shilling (Pre-1947)</label>
  <input class="field-input" type="number" id="qty-uk-shilling" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-uk-florin">Florin / Two Shillings (Pre-1947)</label>
  <input class="field-input" type="number" id="qty-uk-florin" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-uk-halfcrown">Half Crown (Pre-1947)</label>
  <input class="field-input" type="number" id="qty-uk-halfcrown" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-uk-crown">Crown (Pre-1947)</label>
  <input class="field-input" type="number" id="qty-uk-crown" value="0" min="0">
</div>
</div>

<!-- World Tab -->
<div class="tab-panel" id="tab-world">
<div class="tab-section-title">World Gold Bullion (1 oz)</div>
<div class="field-group">
  <label class="field-label" for="qty-krugerrand">South African Krugerrand (1 oz)</label>
  <input class="field-input" type="number" id="qty-krugerrand" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-philharmonic">Austrian Philharmonic (1 oz .9999)</label>
  <input class="field-input" type="number" id="qty-philharmonic" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-kangaroo">Australian Kangaroo (1 oz .9999)</label>
  <input class="field-input" type="number" id="qty-kangaroo" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-panda-gold">Chinese Gold Panda (30g / ~0.9645 oz)</label>
  <input class="field-input" type="number" id="qty-panda-gold" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-libertad-gold">Mexican Gold Libertad (1 oz .999)</label>
  <input class="field-input" type="number" id="qty-libertad-gold" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-centenario">Mexican 50 Peso Centenario (1.2057 oz)</label>
  <input class="field-input" type="number" id="qty-centenario" value="0" min="0">
</div>

<div class="tab-section-title">World Silver Bullion (1 oz)</div>
<div class="field-group">
  <label class="field-label" for="qty-kookaburra">Australian Kookaburra (1 oz .999)</label>
  <input class="field-input" type="number" id="qty-kookaburra" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-libertad-silver">Mexican Silver Libertad (1 oz .999)</label>
  <input class="field-input" type="number" id="qty-libertad-silver" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-philharmonic-silver">Austrian Silver Philharmonic (1 oz .999)</label>
  <input class="field-input" type="number" id="qty-philharmonic-silver" value="0" min="0">
</div>
<div class="field-group">
  <label class="field-label" for="qty-panda-silver">Chinese Silver Panda (30g / ~0.9645 oz)</label>
  <input class="field-input" type="number" id="qty-panda-silver" value="0" min="0">
</div>
</div>

<button class="calc-btn" id="calc-btn" type="button">Calculate Melt Value</button>

<div class="result-box" id="result-box">
  <p class="big-number" id="result-total">$0.00</p>
  <p class="detail" id="result-detail"></p>
</div>

<div id="breakdown-area" style="display:none;margin-top:1rem;">
<h3 style="font-size:1rem;margin-bottom:0.5rem;">Breakdown</h3>
<div class="coin-table-wrap">
<table class="coin-table">
  <thead>
    <tr><th>Coin</th><th>Qty</th><th>Metal (oz)</th><th>Melt Value</th></tr>
  </thead>
  <tbody id="breakdown-body"></tbody>
</table>
</div>
</div>

</div>

<div class="calc-panel calc-panel-accent">
<h2>Get an Offer on Your Coins</h2>
<p style="font-size:0.9rem;color:#6b7280;margin:0 0 0.75rem;">Have coins to sell? Fill out this form and a local coin dealer will contact you with an offer. No obligation.</p>

<form class="offer-form" id="offer-form" action="#" data-form-key="mykleozw" method="POST">
  <input type="hidden" name="_subject" value="Coin Show Near Me — Melt Value Offer Request">
  <input type="hidden" name="form_type" value="melt_value_offer">
  <input type="hidden" name="source" value="Website">
  <input type="hidden" name="formName" value="meltValueOffer">
  <input type="hidden" name="coinContactRoles" value="sellerOfferRequest">
  <input type="hidden" name="ctaCode" value="melt_value_offer_request">
  <input type="hidden" name="sourceDetail" value="Melt value calculator offer request">
  <div class="field-group">
    <label class="field-label" for="offer-name">Your Name *</label>
    <input class="field-input" type="text" id="offer-name" name="name" required>
    <div class="offer-error" data-for="name"></div>
  </div>

  <div class="field-group">
    <label class="field-label" for="offer-email">Email Address *</label>
    <input class="field-input" type="email" id="offer-email" name="email" required>
    <div class="offer-error" data-for="email"></div>
  </div>

  <div class="field-group">
    <label class="field-label" for="offer-phone">Phone Number</label>
    <input class="field-input" type="tel" id="offer-phone" name="phone">
  </div>

  <div class="field-group">
    <label class="field-label" for="offer-zip">ZIP Code *</label>
    <input class="field-input" type="text" id="offer-zip" name="zip" maxlength="10" required>
    <div class="offer-error" data-for="zip"></div>
  </div>

  <div class="field-group">
    <label class="field-label" for="offer-description">What do you have to sell? *</label>
    <textarea class="field-input" id="offer-description" name="description" rows="4" placeholder="e.g., 50 pre-1965 Washington quarters, 10 Morgan silver dollars, 5 Gold Eagles..." required></textarea>
    <div class="offer-error" data-for="description"></div>
  </div>

  <div class="field-group">
    <label class="field-label" for="offer-melt">Estimated Melt Value (auto-filled)</label>
    <input class="field-input" type="text" id="offer-melt" name="estimated_melt_value" readonly style="background:#f3f4f6;">
  </div>

  <div style="display:flex;align-items:flex-start;gap:0.4rem;font-size:0.85rem;color:#6b7280;">
    <input type="checkbox" id="offer-consent" name="contactConsent" value="yes" style="margin-top:0.2rem;" required>
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
  /* Tab switching */
  var tabs = document.querySelectorAll('.calc-tab');
  var panels = document.querySelectorAll('.tab-panel');
  for (var i = 0; i < tabs.length; i++) {
    tabs[i].addEventListener('click', function() {
      for (var j = 0; j < tabs.length; j++) { tabs[j].classList.remove('active'); }
      for (var j = 0; j < panels.length; j++) { panels[j].classList.remove('active'); }
      this.classList.add('active');
      var target = document.getElementById('tab-' + this.getAttribute('data-tab'));
      if (target) target.classList.add('active');
    });
  }

  /* Coin data: { id, name, oz, metal } */
  var COINS = [
    /* US Silver */
    { id: 'qty-dimes',       name: 'Roosevelt/Mercury Dimes',        oz: 0.07234, metal: 'silver' },
    { id: 'qty-quarters',    name: 'Washington Quarters',            oz: 0.18084, metal: 'silver' },
    { id: 'qty-halves',      name: 'Half Dollars (90%)',             oz: 0.36169, metal: 'silver' },
    { id: 'qty-morgan',      name: 'Morgan/Peace Dollars',           oz: 0.77344, metal: 'silver' },
    { id: 'qty-ase',         name: 'American Silver Eagles',         oz: 1.00000, metal: 'silver' },
    { id: 'qty-40halves',    name: '40% Kennedy Halves',             oz: 0.14792, metal: 'silver' },
    { id: 'qty-war-nickels', name: 'War Nickels (35%)',              oz: 0.05626, metal: 'silver' },
    /* US Gold */
    { id: 'qty-age-1oz',       name: 'Gold Eagle 1 oz',             oz: 1.0000, metal: 'gold' },
    { id: 'qty-age-half',      name: 'Gold Eagle 1/2 oz',           oz: 0.5000, metal: 'gold' },
    { id: 'qty-age-quarter',   name: 'Gold Eagle 1/4 oz',           oz: 0.2500, metal: 'gold' },
    { id: 'qty-age-tenth',     name: 'Gold Eagle 1/10 oz',          oz: 0.1000, metal: 'gold' },
    { id: 'qty-buffalo-gold',  name: 'Gold Buffalo 1 oz',           oz: 1.0000, metal: 'gold' },
    { id: 'qty-gold-1',        name: '$1 Gold (1849-1889)',          oz: 0.04837, metal: 'gold' },
    { id: 'qty-gold-250',      name: '$2.50 Quarter Eagle',         oz: 0.12094, metal: 'gold' },
    { id: 'qty-gold-3',        name: '$3 Gold (1854-1889)',          oz: 0.14512, metal: 'gold' },
    { id: 'qty-gold-5',        name: '$5 Half Eagle',               oz: 0.24187, metal: 'gold' },
    { id: 'qty-gold-10',       name: '$10 Eagle',                   oz: 0.48375, metal: 'gold' },
    { id: 'qty-gold-20',       name: '$20 Double Eagle',            oz: 0.96750, metal: 'gold' },
    /* Canadian */
    { id: 'qty-ca-dimes',       name: 'Canadian Dimes (80%)',       oz: 0.06000, metal: 'silver' },
    { id: 'qty-ca-quarters',    name: 'Canadian Quarters (80%)',    oz: 0.15000, metal: 'silver' },
    { id: 'qty-ca-halves',      name: 'Canadian Half Dollars (80%)',oz: 0.30000, metal: 'silver' },
    { id: 'qty-ca-dollars',     name: 'Canadian Silver Dollars (80%)',oz: 0.60000, metal: 'silver' },
    { id: 'qty-ca-sml',         name: 'Silver Maple Leaf',          oz: 1.00000, metal: 'silver' },
    { id: 'qty-ca-gml-1oz',     name: 'Gold Maple Leaf 1 oz',      oz: 1.00000, metal: 'gold' },
    { id: 'qty-ca-gml-half',    name: 'Gold Maple Leaf 1/2 oz',    oz: 0.50000, metal: 'gold' },
    { id: 'qty-ca-gml-quarter', name: 'Gold Maple Leaf 1/4 oz',    oz: 0.25000, metal: 'gold' },
    { id: 'qty-ca-gml-tenth',   name: 'Gold Maple Leaf 1/10 oz',   oz: 0.10000, metal: 'gold' },
    /* British */
    { id: 'qty-sovereign',       name: 'Gold Sovereign',            oz: 0.23542, metal: 'gold' },
    { id: 'qty-britannia-gold',  name: 'Gold Britannia 1 oz',       oz: 1.00000, metal: 'gold' },
    { id: 'qty-britannia-silver',name: 'Silver Britannia 1 oz',     oz: 1.00000, metal: 'silver' },
    { id: 'qty-uk-sixpence',    name: 'UK Sixpence (Pre-1947)',     oz: 0.04547, metal: 'silver' },
    { id: 'qty-uk-shilling',    name: 'UK Shilling (Pre-1947)',     oz: 0.09094, metal: 'silver' },
    { id: 'qty-uk-florin',      name: 'UK Florin (Pre-1947)',       oz: 0.18188, metal: 'silver' },
    { id: 'qty-uk-halfcrown',   name: 'UK Half Crown (Pre-1947)',   oz: 0.22737, metal: 'silver' },
    { id: 'qty-uk-crown',       name: 'UK Crown (Pre-1947)',        oz: 0.45473, metal: 'silver' },
    /* World Gold */
    { id: 'qty-krugerrand',       name: 'Krugerrand 1 oz',          oz: 1.00000, metal: 'gold' },
    { id: 'qty-philharmonic',     name: 'Philharmonic 1 oz',        oz: 1.00000, metal: 'gold' },
    { id: 'qty-kangaroo',         name: 'Kangaroo 1 oz',            oz: 1.00000, metal: 'gold' },
    { id: 'qty-panda-gold',       name: 'Gold Panda 30g',           oz: 0.96450, metal: 'gold' },
    { id: 'qty-libertad-gold',    name: 'Gold Libertad 1 oz',       oz: 1.00000, metal: 'gold' },
    { id: 'qty-centenario',       name: '50 Peso Centenario',       oz: 1.20565, metal: 'gold' },
    /* World Silver */
    { id: 'qty-kookaburra',       name: 'Kookaburra 1 oz',          oz: 1.00000, metal: 'silver' },
    { id: 'qty-libertad-silver',  name: 'Silver Libertad 1 oz',     oz: 1.00000, metal: 'silver' },
    { id: 'qty-philharmonic-silver',name: 'Silver Philharmonic 1 oz',oz: 1.00000, metal: 'silver' },
    { id: 'qty-panda-silver',     name: 'Silver Panda 30g',         oz: 0.96450, metal: 'silver' }
  ];

  var calcBtn = document.getElementById('calc-btn');
  var resultBox = document.getElementById('result-box');
  var resultTotal = document.getElementById('result-total');
  var resultDetail = document.getElementById('result-detail');
  var breakdownArea = document.getElementById('breakdown-area');
  var breakdownBody = document.getElementById('breakdown-body');

  function getVal(id) {
    var el = document.getElementById(id);
    return el ? (parseFloat(el.value) || 0) : 0;
  }

  function formatUSD(n) { return '$' + n.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }

  calcBtn.addEventListener('click', function() {
    var spotSilver = getVal('spot-silver');
    var spotGold = getVal('spot-gold');
    var total = 0;
    var totalSilverOz = 0;
    var totalGoldOz = 0;
    var rows = [];

    COINS.forEach(function(c) {
      var qty = getVal(c.id);
      if (qty <= 0) return;
      var spot = c.metal === 'gold' ? spotGold : spotSilver;
      var metalOz = qty * c.oz;
      var value = metalOz * spot;
      total += value;
      if (c.metal === 'silver') totalSilverOz += metalOz;
      else totalGoldOz += metalOz;

      rows.push({
        coin: c.name,
        qty: String(qty),
        metal: metalOz.toFixed(4) + ' oz ' + c.metal,
        value: formatUSD(value)
      });
    });

    if (total > 0) {
      resultBox.style.display = 'block';
      resultTotal.textContent = formatUSD(total);

      var parts = [];
      if (totalSilverOz > 0) parts.push(totalSilverOz.toFixed(2) + ' oz silver');
      if (totalGoldOz > 0) parts.push(totalGoldOz.toFixed(4) + ' oz gold');
      resultDetail.textContent = 'Total metal content: ' + parts.join(' + ');

      breakdownBody.textContent = '';
      rows.forEach(function(row) {
        var tr = document.createElement('tr');
        var coinTd = document.createElement('td');
        var qtyTd = document.createElement('td');
        var metalTd = document.createElement('td');
        var valueTd = document.createElement('td');

        coinTd.setAttribute('data-label', 'Coin');
        qtyTd.setAttribute('data-label', 'Qty');
        metalTd.setAttribute('data-label', 'Metal');
        valueTd.setAttribute('data-label', 'Value');
        coinTd.textContent = row.coin;
        qtyTd.textContent = row.qty;
        metalTd.textContent = row.metal;
        valueTd.textContent = row.value;
        tr.appendChild(coinTd);
        tr.appendChild(qtyTd);
        tr.appendChild(metalTd);
        tr.appendChild(valueTd);
        breakdownBody.appendChild(tr);
      });
      breakdownArea.style.display = 'block';

      document.getElementById('offer-melt').value = formatUSD(total);
    } else {
      resultBox.style.display = 'none';
      breakdownArea.style.display = 'none';
    }
  });

  /* Offer form — submit via Formspree */
  var offerForm = document.getElementById('offer-form');
  var offerSuccess = document.getElementById('offer-success');

  offerForm.addEventListener('submit', function(e) {
    e.preventDefault();
    if (window.coinFormSpamCheck && !window.coinFormSpamCheck(offerForm)) { return; }
    window.coinSubmitForm(offerForm).then(function() {
      offerForm.style.display = 'none';
      offerSuccess.style.display = 'block';
    });
  });

  /* Auto-load spot prices */
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
      if (data.silver) {
        document.getElementById('spot-silver').value = data.silver.toFixed(2);
        document.getElementById('silver-spot-note').textContent = 'Live price loaded \u00b7 Updated ' + timeAgo(data.updated_at);
      } else {
        document.getElementById('silver-spot-note').textContent = 'Enter today\'s silver spot price per troy ounce.';
      }
      if (data.gold) {
        document.getElementById('spot-gold').value = data.gold.toFixed(2);
        document.getElementById('gold-spot-note').textContent = 'Live price loaded \u00b7 Updated ' + timeAgo(data.updated_at);
      } else {
        document.getElementById('gold-spot-note').textContent = 'Enter today\'s gold spot price per troy ounce.';
      }

      var el = function(id) { return document.getElementById(id); };
      el('calc-spot-gold-display').textContent = formatTickerPrice(data.gold);
      el('calc-spot-silver-display').textContent = formatTickerPrice(data.silver);
      el('calc-spot-platinum-display').textContent = formatTickerPrice(data.platinum);
      el('calc-spot-palladium-display').textContent = formatTickerPrice(data.palladium);
      var updated = data.updated_at ? 'Updated ' + timeAgo(data.updated_at) + ' \u00b7 Spot prices per troy oz' : 'Spot prices per troy oz';
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

## Coin Silver & Gold Content Reference

### US Coins

| Coin | Years | Composition | Metal Weight (troy oz) |
|------|-------|-------------|------------------------|
| Roosevelt/Mercury Dime | 1916-1964 | 90% Silver | 0.0723 oz |
| Washington Quarter | 1932-1964 | 90% Silver | 0.1808 oz |
| Walking Liberty / Franklin / Kennedy Half | 1916-1964 | 90% Silver | 0.3617 oz |
| Kennedy Half Dollar | 1965-1970 | 40% Silver | 0.1479 oz |
| War Nickel | 1942-1945 | 35% Silver | 0.0563 oz |
| Morgan / Peace Dollar | 1878-1935 | 90% Silver | 0.7734 oz |
| American Silver Eagle | 1986-present | 99.9% Silver | 1.0000 oz |
| $1 Gold | 1849-1889 | 90% Gold | 0.0484 oz |
| $2.50 Quarter Eagle | 1796-1929 | 90% Gold | 0.1209 oz |
| $5 Half Eagle | 1795-1929 | 90% Gold | 0.2419 oz |
| $10 Eagle | 1795-1933 | 90% Gold | 0.4838 oz |
| $20 Double Eagle | 1849-1933 | 90% Gold | 0.9675 oz |
| Gold Eagle | 1986-present | 91.67% Gold | 1.0000 oz (fine) |
| Gold Buffalo | 2006-present | 99.99% Gold | 1.0000 oz |

### Canadian Coins

| Coin | Composition | Metal Weight (troy oz) |
|------|-------------|------------------------|
| Dime (Pre-1968) | 80% Silver | 0.0600 oz |
| Quarter (Pre-1968) | 80% Silver | 0.1500 oz |
| Half Dollar (Pre-1968) | 80% Silver | 0.3000 oz |
| Silver Dollar (Pre-1968) | 80% Silver | 0.6000 oz |
| Silver Maple Leaf | 99.99% Silver | 1.0000 oz |
| Gold Maple Leaf | 99.99% Gold | 1.0000 oz |

### British Coins

| Coin | Composition | Metal Weight (troy oz) |
|------|-------------|------------------------|
| Sixpence (Pre-1947) | 50% Silver | 0.0455 oz |
| Shilling (Pre-1947) | 50% Silver | 0.0909 oz |
| Florin (Pre-1947) | 50% Silver | 0.1819 oz |
| Half Crown (Pre-1947) | 50% Silver | 0.2274 oz |
| Crown (Pre-1947) | 50% Silver | 0.4547 oz |
| Gold Sovereign | 91.67% Gold | 0.2354 oz |
| Gold Britannia | 99.99% Gold | 1.0000 oz |

### World Bullion

| Coin | Country | Metal Weight (troy oz) |
|------|---------|------------------------|
| Krugerrand | South Africa | 1.0000 oz gold |
| Philharmonic | Austria | 1.0000 oz gold or silver |
| Kangaroo | Australia | 1.0000 oz gold |
| Kookaburra | Australia | 1.0000 oz silver |
| Libertad | Mexico | 1.0000 oz gold or silver |
| 50 Peso Centenario | Mexico | 1.2057 oz gold |
| Gold Panda | China | 30g (~0.9645 oz) gold |
| Silver Panda | China | 30g (~0.9645 oz) silver |

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
  "description": "Calculate the melt value of US, Canadian, British and world silver and gold coins based on current spot prices.",
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
        "text": "The melt value of a coin is the value of the precious metal it contains, based on the current spot price. It represents the minimum intrinsic value of a coin — what the metal itself would be worth if melted down."
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
      "name": "What is a War Nickel and does it contain silver?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "War Nickels (1942-1945) contain 35% silver. They were minted with silver to conserve nickel for the war effort. You can identify them by the large mintmark (P, D, or S) above the dome of Monticello on the reverse. Each contains about 0.0563 troy ounces of silver."
      }
    },
    {
      "@type": "Question",
      "name": "How much gold is in a pre-1933 US gold coin?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Pre-1933 US gold coins are 90% gold. A $20 Double Eagle contains 0.9675 oz of gold, a $10 Eagle contains 0.4838 oz, a $5 Half Eagle contains 0.2419 oz, and a $2.50 Quarter Eagle contains 0.1209 oz. These coins often carry significant collector premiums above melt value."
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
