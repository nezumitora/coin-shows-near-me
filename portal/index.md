---
layout: default
title: "Dealer Portal — Pre-Show Offers for Coin Dealers & Collectors"
seo_title: "Coin Show Dealer Portal — Register, Browse Collections, Make Offers | Coin Show Near Me"
seo_description: "Register as a verified coin dealer, upload your collection as an attendee, or submit your show as a promoter. Get pre-show offers and save time at the bourse."
permalink: /portal/
nav_exclude: true
breadcrumb_current: "Dealer Portal"
---

# Dealer Portal

<div style="background:linear-gradient(135deg, var(--coin-navy) 0%, var(--coin-navy-light) 100%);color:#f1f5f9;padding:1.5rem;border-radius:8px;margin-bottom:2rem;border-left:4px solid var(--coin-gold);">
<p style="font-size:1.1rem;margin:0 0 0.75rem;"><strong style="color:var(--coin-gold-light);">Coming Soon</strong> — We're building a dealer portal to connect coin dealers with collectors before the show even starts.</p>
<p style="font-size:0.95rem;margin:0;color:#cbd5e1;">Register your interest below to be first in line when we launch.</p>
</div>

## How It Works

The Coin Show Near Me dealer portal connects three groups — **dealers**, **attendees**, and **promoters** — to make coin shows more efficient for everyone.

<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:1.25rem;margin:1.5rem 0;">

<div style="border:1px solid var(--coin-border);border-radius:0.75rem;padding:1.25rem;background:var(--coin-gold-bg);">
<h3 style="margin:0 0 0.5rem;color:var(--coin-navy);font-size:1.05rem;">For Dealers</h3>
<p style="font-size:0.9rem;margin:0 0 0.75rem;color:#4b5563;">Register as a verified dealer and confirm which shows you're attending. Browse attendee collections before the show and make offers — so you know exactly what's walking through the door.</p>
<ul style="font-size:0.85rem;margin:0;padding-left:1.25rem;color:#6b7280;">
<li>Verify via ANA, PNG, PCGS, or NGC credentials</li>
<li>Browse collections for your confirmed shows</li>
<li>Make offers on individual items or entire collections</li>
<li>Coordinate meeting details at the bourse</li>
</ul>
</div>

<div style="border:1px solid var(--coin-border);border-radius:0.75rem;padding:1.25rem;background:var(--coin-gold-bg);">
<h3 style="margin:0 0 0.5rem;color:var(--coin-navy);font-size:1.05rem;">For Collectors & Sellers</h3>
<p style="font-size:0.9rem;margin:0 0 0.75rem;color:#4b5563;">Upload your collection ahead of a coin show you plan to attend. Verified dealers will review what you have and make offers — no more lugging coins table to table hoping for a fair price.</p>
<ul style="font-size:0.85rem;margin:0;padding-left:1.25rem;color:#6b7280;">
<li>Upload photos and descriptions of your coins</li>
<li>Receive offers from multiple verified dealers</li>
<li>Accept, counter, or decline — all before the show</li>
<li>Meet at the dealer's table to complete the transaction</li>
</ul>
</div>

<div style="border:1px solid var(--coin-border);border-radius:0.75rem;padding:1.25rem;background:var(--coin-gold-bg);">
<h3 style="margin:0 0 0.5rem;color:var(--coin-navy);font-size:1.05rem;">For Show Promoters</h3>
<p style="font-size:0.9rem;margin:0 0 0.75rem;color:#4b5563;">Submit your show to our directory and manage your exhibitor list. Approve dealer attendance claims, update show details, and see how many collectors are planning to attend.</p>
<ul style="font-size:0.85rem;margin:0;padding-left:1.25rem;color:#6b7280;">
<li>Get your show listed in our directory of 190+ shows</li>
<li>Manage and verify your dealer/exhibitor list</li>
<li>Track registered attendees and scheduled offers</li>
<li>Update dates, venues, and cancellations</li>
</ul>
</div>

</div>

---

## Why Pre-Show Offers?

At a typical coin show, sellers walk from table to table, showing the same coins to dealer after dealer, hoping for a fair price. Dealers spend time evaluating collections that may not match their buying interests. Both sides waste time.

**The portal changes this:**

- **Sellers** know which dealers are interested *before* they arrive — and at what price
- **Dealers** see exactly what's coming and can prepare competitive offers
- **Everyone** spends less time negotiating and more time doing what they love

---

## Register Your Interest

<div class="notify-section">
<h3>Be the first to know when the portal launches</h3>
<p>Whether you're a dealer, collector, or show promoter — sign up and we'll notify you when the portal is ready.</p>

<form class="notify-form" id="portal-form" action="https://formspree.io/f/mykleozw" method="POST">
<input type="hidden" name="_subject" value="Coin Show Near Me — Portal Interest">
<input type="hidden" name="source" value="portal-landing-page">
<div class="form-row">
<input type="text" name="name" placeholder="Name" style="background:#fff;color:#111;">
<input type="email" name="email" placeholder="Email address" required style="background:#fff;color:#111;">
</div>
<div class="form-row" style="margin-top:0.5rem;">
<select name="role" style="flex:1;min-width:200px;padding:0.6rem 0.75rem;border:1px solid var(--coin-border);border-radius:6px;font-size:0.9rem;background:#fff;color:#111;">
<option value="">I am a...</option>
<option value="dealer">Coin Dealer</option>
<option value="collector">Collector / Seller</option>
<option value="promoter">Show Promoter</option>
</select>
<button type="submit">Notify Me</button>
</div>
<textarea name="message" placeholder="Anything you'd like us to know — your dealer credentials, shows you attend, what you collect (optional)" style="background:#fff;color:#111;margin-top:0.5rem;"></textarea>
</form>
<div class="notify-success" id="portal-success" style="background:#065f46;margin-top:0.5rem;">
Thank you! We'll notify you when the dealer portal launches.
</div>
</div>

---

## Frequently Asked Questions

### Is the portal free?

The portal will be free for collectors and attendees. Dealer registration is also free. We may offer optional premium placements for dealers in the future.

### How do you verify dealers?

Dealers must provide at least one verifiable credential — ANA membership, PNG membership, PCGS Authorized Dealer status, NGC Authorized Dealer status, or a state business license. New dealers undergo additional review before gaining full access.

### When will the portal launch?

We're actively building the portal now. Sign up above to be notified as soon as it's ready.

### Can I still sell coins at a show without the portal?

Absolutely. The portal is an additional tool to make the experience better — coin shows work great without it. Use our [Melt Value Calculator](/tools/melt-value-calculator/) to know the metal value of your coins before attending.

<script>
var form = document.getElementById('portal-form');
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
        document.getElementById('portal-success').style.display = 'block';
      }
    });
  });
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Is the coin show dealer portal free?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The portal will be free for collectors and attendees. Dealer registration is also free. Optional premium placements for dealers may be offered in the future."
      }
    },
    {
      "@type": "Question",
      "name": "How do you verify coin dealers on the portal?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Dealers must provide at least one verifiable credential — ANA membership, PNG membership, PCGS Authorized Dealer status, NGC Authorized Dealer status, or a state business license. New dealers undergo additional review before gaining full access."
      }
    },
    {
      "@type": "Question",
      "name": "What are pre-show offers at coin shows?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Pre-show offers allow coin collectors to upload their collection before a show, and verified dealers confirmed for that show can review and make offers in advance. This saves time for both parties — sellers know what to expect and dealers can prepare competitive offers."
      }
    }
  ]
}
</script>
