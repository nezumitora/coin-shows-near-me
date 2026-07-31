# TODO

Public-facing task tracker for contributors.

## Contributing

Know of a coin show not in the directory? Open an issue with:

- Show name
- City, State
- Venue name and address
- Date(s)
- Organizer name + website

## Current

- [ ] **HIGH PRIORITY: Reconcile the 2026-07-27 Google Search Console indexing report before changing index rules** — export the exact example URLs, last-crawl dates, source sitemap, inspection result, and selected canonical for both 404s, both 403s, the redirect, and a representative sample of the 233 noindex URLs. Current source explains only 32 intentional noindex alias pages, so do not bulk-remove noindex until the deployed-page discrepancy is proven.
- [ ] **HIGH PRIORITY: Stop expired dates from emitting scheduled Event schema** — add an explicit future-date guard and regression tests for expired, TBD, partial, range, and future dates; review APNSCC, First Annual Lansing, and WNY against official/direct evidence and set unconfirmed next dates to TBD without deleting qualified recurring-series pages.
- [ ] Build a version-controlled public-URL retirement map for deleted or corrected city/show slugs, starting with the confirmed `/cities/westland-mi/` → `/cities/warren-mi/` successor; add one-hop redirects only for exact successors and use genuine 404/410 responses for removed one-time content instead of broad homepage redirects.
- [ ] Add rendered SEO validation: every sitemap URL must return 200, remain indexable, use a consistent canonical, and not be an alias; alias destinations must resolve and expired dates must not emit scheduled Event schema.
- [ ] **HIGH PRIORITY: Make `_data/shows.yml` the enforced source for `shows.json`** — current audit found 197 YAML records versus 199 JSON records, 30 missing JSON IDs, 32 extra JSON IDs, and 164 mismatched core fields. Add deterministic generation/parity validation before correcting and republishing the widget feed; do not patch only Westland while the wider feed remains stale.
- [ ] Diagnose each GSC 403 using the exact reported URL, crawl time, response headers, hostname, and Cloudflare/GitHub Pages evidence before changing any security rule.
- [ ] Turn organizer verification into the first outreach offer: confirm listing facts, show a visible evidence-backed verification state, provide a correction path, and only then optionally invite sharing or a backlink; never require a link or payment for verification.
- [ ] Validate dealer demand with free registration/profile claiming before testing a clearly defined founding-dealer package; keep paid placement separate from verification and editorial trust.
- [ ] **HIGH PRIORITY: Complete nationwide 2026-2027 show refresh** — gather every active U.S. coin show from official organizer/club/state-association calendars first, use third-party directories only as leads, verify show name/date/venue/address/organizer/source URL before publishing, and track uncertain leads separately.
- [ ] **Improve source discovery reliability** — for each state, run source-discovery passes that search for official regional promoter calendars and club/event pages for every TBD listing before marking a state launch-ready; Arcadia/California Coin Events was the first missed-source example to fold into this process.
- [ ] Add upcoming shows as dates are confirmed by organizers
- [ ] Verify TBD shows when organizers announce 2026 dates
- [ ] Resolve future-date review issues from `todo/tasks/future-date-review-2026-07-13.md`, using official organizer/club/venue sources before publishing dates.
- [ ] Use `docs/future-date-refresh-routine.md` as the source pattern for future scheduled date-refresh reports.
- [ ] Expand state pages with additional local shows
- [ ] Add operating company/entity wording to Privacy Policy, Terms, and legal pages using the business entity/DBA decision; do not list personal name or home address.
- [ ] Create dealer acquisition plan: identify target coin dealers, add/claim dealer profiles, invite dealers to submit or update listings, and track outreach/results.
- [ ] Add server-side Cloudflare Turnstile validation via a Worker/Formspree bridge so invalid form submissions are rejected before they count against monthly Formspree quota.
- [ ] Build a server-side Cloudflare Worker bridge before re-enabling EspoCRM forwarding for Coin Shows forms; the rotated Lead Capture URL is stored locally and must never be placed in public HTML/JavaScript.
- [ ] Review saved Instagram item for Coin Shows relevance. Instagram often blocks bot fetching, so open directly or use a screenshot/summary before creating website/content/operations tasks. Source: inbox/2026-05-05_165001_milo-bot-coinshows.json

## Logo & Branding

- [ ] **Primary logo** — gold buffalo (no star) on navy background with "Coin Show Near Me" in white text below, straight line. Generate via AI image tool (ChatGPT/DALL-E or Nano), then clean up in Canva or similar. Remove watermark if using Nano free tier.
- [ ] **Transparent buffalo watermark** — large buffalo silhouette as a transparent PNG for use as a background element in the "Stay in the Loupe" CTA section (5-10% opacity, covers ~75% of section). AI generators can't output transparent PNGs directly — generate on a solid background, then use remove.bg or Canva background remover.
- [ ] **Favicon update** — create a simplified buffalo-head-only version for the browser tab icon (32x32 and 180x180 for Apple touch).
- [ ] **Create email addresses** — set up legal@ and privacy@ (or a single contact@) for coinshownearme.com, then update /contact/ page and legal docs with the real addresses.
- [ ] **Add transparent buffalo to CTA** — once the transparent PNG is ready, add it as a background image in the "Stay in the Loupe" signup section at low opacity.

## Pre-Launch / WordPress Migration

- [ ] **Full URL path and slug audit** — generate a complete map of every page URL on the Jekyll site before building WordPress. Every URL must match 1:1 in WordPress permalinks. Any URL that changes needs a 301 redirect. No URL changes = no SEO loss.

## SEO — Backlink Directory Registrations

Research and register Coin Show Near Me on coin collecting, numismatic, and hobby-related directories to build backlinks and traffic.

- [ ] Google Business Profile — verify listing optimized (if applicable as a directory site)
- [ ] ANA — American Numismatic Association (money.org) — member/resource listing
- [ ] PNG — Professional Numismatists Guild (pngdealers.org) — directory listing
- [ ] PCGS Coin Forum / community links (pcgs.com) — resource listing
- [ ] NGC Coin community (ngccoin.com) — resource/directory listing
- [ ] CoinTalk forum resource listing (cointalk.com) — numismatic community
- [ ] Coin World (coinworld.com) — numismatic publication, resource directory
- [ ] Numismatic News (numismaticnews.net) — hobby publication directory
- [ ] Reddit r/coins sidebar/wiki — community resource listing
- [ ] Coin Dealer Directory (coindealerdirectory.com) — if accepting related listings
- [ ] Hobby-related directories (hobbydb.com, collectorsweekly.com)
- [ ] Crunchbase (crunchbase.com) — free company profile
- [ ] Bing Places for Business (bingplaces.com) — free
- [ ] Apple Business Connect (businessconnect.apple.com) — free

## Roadmap

- Interactive map view
- Calendar export (iCal/Google Calendar)
- Show-finder by date range
- State sales tax guide for coins & precious metals
- Beginner's guide to coin shows
- Estate / inherited coin collection guide
- Coin show trip planner / driving directions
- Buffalo logo monogram pattern — create a micro version of the buffalo nickel logo as a repeating pattern (Gucci-style interlocking monogram). Use as subtle background texture for hero, section dividers, or card backgrounds.

See `README.md` for the full show list.
