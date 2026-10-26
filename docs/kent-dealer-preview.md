# Kent Coin and Bullion — approved publication

## Current handoff — October 26, 2026

The owner explicitly requested adding the reviewed Kent updates to the live site.
The canonical `_data/dealers.yml` now contains one regular Kent record with the
previously reviewed public business facts. `featured: true` enables its separate
complimentary `Featured dealer` banner in the existing non-homepage banner slots.
On `/dealers/`, the single banner appears below search/filters and above ordinary
results; its listing link clears conflicting filters before jumping to the card.
No claim/verification badge, invented website/services, billing, CRM write or
customer contact is included. The preview-only fixture and config were retired;
production no longer depends on review-mode flags. Review controls stay disabled
in ordinary builds. No homepage promotion was added.

The owner also supplied `https://pnna.org/calendar.html` for recurring regional
cross-reference. It is registered alongside the existing PNNA mobile calendar;
the rotation and exact-date/identity holds are in
`docs/listing-source-review-ledger.md`. No show records are changed by this batch.

### Current verification

- 27 Ruby syntax checks; 138 Ruby tests / 14,212 assertions; 16 JavaScript tests:
  passed. Existing data validator: 50 states, 225 shows, 33 aliases, 10 city redirects.
- Generator currentness and whitespace passed; no show/feed/generated-page change.
- No-network source comparison passed: 124 rows, 56 sources; new PNNA short-URL
  source is registered. This is configuration validation, not a full live recrawl.
- Ordinary production Docker Jekyll build passed. Browser checks at 1440×900 and
  375×667 verified a single directory banner and ordinary Kent card, public
  contacts, Maps link, name/state/type searches, anchor/filter reset and visible
  keyboard focus. No horizontal overflow; promotional links at least 44px tall.
- Viewport-only directory and Greater Tacoma show-page captures returned HTTP 200
  with no console errors; screenshots were opened and visually inspected. Banner
  title, address and both actions are readable at both widths. Homepage remains
  promotion-free. No forms submitted, calls made or customer contact performed.

Publication and final live verification receipts will be recorded after deployment.

## Historical preview evidence (before publication approval)

### Scope

Owner requested a complimentary featured placement plus an ordinary directory
listing, with visual review before anything goes live. No billing, customer
contact, CRM changes, ownership claim, verification badge, commit or deployment
is included in this preview. Promotion is separate from business-data verification.

### Public facts and unknowns

- Name/category: Kent Coin and Bullion, coin dealer.
- Public business address: 428 W Harrison St, Kent, WA 98032.
- Public phone: (253) 443-1960.
- Source: owner's supplied Google Maps listing,
  https://maps.app.goo.gl/sFADk38zxiEvtHS58?g_st=ic, observed October 26, 2026.
- Maps did not link a website. No website, hours, shipping, buying/appraisal
  services, social profiles, ratings, logo or personal testimonial was invented.

### Implementation

- `_data/review_dealers.yml` holds public preview facts, not a production entry.
  `_data/dealers.yml` is unchanged.
- `_config.kent-preview.yml` opts into Kent's preview only when `review_mode` is
  also enabled. Build with all three config files; neither flag alone publishes
  the preview dealer or replaces the banner.
- `_includes/featured-dealer.html` reuses the existing non-homepage banner space.
  Owner requested removal of the complimentary-placement/verification paragraph;
  the card now retains only the simple `Featured dealer` label. External
  promotional Maps links still use sponsored/nofollow attributes.
- `dealers/index.md` appends one ordinary local-shop card only in the preview;
  its stable anchor is `dealer-kent-coin-and-bullion`. No promotion/verification
  badge is applied to that regular card.
- Kent's clean directory preview suppresses floating annotation controls so they
  do not obscure business information on mobile. Other review builds retain them.
  The review pin layer also has viewport-bound width to prevent resize overflow.
- Analytics/capture bridge remain disabled by the existing review-mode guard.

### Verification

- Existing dealer/homepage trust suite: 26 tests, 564 assertions, no failures.
- Preview and ordinary production Jekyll builds succeeded. Production output
  contained no Kent business name in generated HTML/XML; preview homepage also
  contained no Kent promotion. No live deployment was run.
- Browser interactions checked name/state/type searches, one regular Kent card,
  correct directory anchor and Maps links, complete public contact fields, and no
  fabricated website or Claimed/Verified badge. No forms submitted or calls made.
- Final persistent screenshots: desktop 1440×900 and mobile 375×667, viewport-only.
  All four captures returned HTTP 200, no console errors or horizontal overflow;
  promotional phone/CTA controls measured at least 44px tall.
- Pixel inspection found inherited theme colors hiding the initial featured title
  and lowering CTA contrast. Scoped component styles fixed those before final
  captures; final screenshots display the business name and readable CTA labels.

### Previous approval hold (superseded by current owner approval)

Owner approved the higher directory position on October 26, 2026. The preview
now has one clearly labeled featured block below search/filters and above the
first dealer result, separate from normal results. The previous lower slot is
suppressed only in this gated preview, avoiding duplicate promotions. Ordinary
production builds retain the inherited placeholder position and contain no Kent
listing. This keeps search controls accessible on mobile; it is not a measured
conversion improvement. Other templates remain unchanged and need separate review;
do not blindly insert an ad above essential show dates, address or controls.

Owner must review the featured and regular cards before any production listing
or placement is enabled. Future paid placement requires a separate disclosure
and commercial decision; do not silently turn this courtesy into a paid position.
