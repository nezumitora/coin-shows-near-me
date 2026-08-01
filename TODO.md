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

- [x] **Reconcile the current Google Search Console indexing report before changing index rules** — current property evidence shows two failed-validation 404s, no current 403 or redirect category, one intentional noindex alias, and 32 crawled-not-indexed URLs classified against repository history. No security rule or bulk index rule was changed.
- [ ] **After an approved v0.12.2 deployment, verify production before touching GSC controls** — confirm all seven exact city redirects, corrected Tucson page, noindex widget, deterministic feed, and sitemap output; then resubmit `sitemap.xml` and restart only the failed 404 validation.
- [ ] **HIGH PRIORITY: Stop expired dates from emitting scheduled Event schema** — add an explicit future-date guard and regression tests for expired, TBD, partial, range, and future dates; review APNSCC, First Annual Lansing, and WNY against official/direct evidence and set unconfirmed next dates to TBD without deleting qualified recurring-series pages.
- [x] Build a version-controlled public-URL retirement map for seven proven city successors, including `/cities/westland-mi/` → `/cities/warren-mi/` and the corrected malformed Tucson city slug; generated pages use one-hop canonical/noindex redirects rather than broad homepage redirects.
- [ ] Add rendered SEO validation: every sitemap URL must return 200, remain indexable, use a consistent canonical, and not be an alias; alias destinations must resolve and expired dates must not emit scheduled Event schema.
- [x] **Make `_data/shows.yml` the enforced source for `shows.json`** — deterministic generation now emits exactly 197 canonical records, excludes aliases/internal notes, sanitizes website URLs, and fails validation/CI on any feed drift or ID mismatch.
- [x] Confirm the current GSC report has no 403 category or example URLs; no Cloudflare, GitHub Pages, or other security rule was weakened.
- [ ] Turn organizer verification into the first outreach offer: confirm listing facts, show a visible evidence-backed verification state, provide a correction path, and only then optionally invite sharing or a backlink; never require a link or payment for verification.
- [ ] **HIGH PRIORITY: Track every verification as a separate evidence record** — the append-only record schema and public-provenance rules are documented; implement the protected EspoCRM synchronization so multiple organizer/venue/dealer/community records never overwrite earlier evidence.
- [ ] **HIGH PRIORITY: Complete proposed-date CRM synchronization** — the form now uses validated ISO start/end dates plus explicit `Date TBD` and generates a four-digit-year review summary; add protected server-side revalidation and synchronize dates to EspoCRM only after manual acceptance.
- [x] **Audit test-show submission routing** — documented browser-only fixture behavior, production Formspree routing, disabled browser-side EspoCRM capture, and a visible result summary that sends and saves nothing.
- [ ] Validate dealer demand with free registration/profile claiming before testing a clearly defined founding-dealer package; keep paid placement separate from verification and editorial trust.
- [ ] Test a small direct numismatic sponsorship package only after recording a traffic baseline; label paid placements clearly, keep advertising separate from verification/ranking, and defer programmatic identity advertising unless its privacy and operational costs become justified.
- [ ] **HIGH PRIORITY: Audit the existing 50-state coin and bullion sales-tax guide against primary government sources** — record an exact statute, regulation, or agency-guidance URL and source-checked date for every state/DC; verify product definitions, thresholds, seller conditions, local-tax caveats, and effective dates before promoting summaries as current.
- [ ] Automate a monthly upcoming-show media package from verified directory data: produce an accessible slideshow/video, narration-ready script, podcast audio and transcript, show notes, chapter timestamps, and source links; keep every release in draft for human fact-checking before any YouTube, podcast, or social publication.
- [ ] **HIGH PRIORITY: Complete nationwide 2026-2027 show refresh** — gather every active U.S. coin show from official organizer/club/state-association calendars first, use third-party directories only as leads, verify show name/date/venue/address/organizer/source URL before publishing, and track uncertain leads separately.
- [ ] **HIGH PRIORITY: Verify and normalize full addresses for the existing directory** — collect street, city, state, and ZIP from official organizer/club/venue sources for every show and future dealer profile; never infer or invent missing address components, and clearly label records still awaiting verification.
- [ ] **Improve source discovery reliability** — for each state, run source-discovery passes that search for official regional promoter calendars and club/event pages for every TBD listing before marking a state launch-ready; Arcadia/California Coin Events was the first missed-source example to fold into this process.
- [ ] **Audit the Ahrefs spam-backlink spike without reacting blindly** — export the referring-domain report, classify indexability/dofollow/relevance, compare it with GSC Links and Manual Actions over time, and do not request removals or submit a disavow file unless verified evidence shows Google is counting harmful manipulative links.
- [ ] Add upcoming shows as dates are confirmed by organizers
- [ ] Verify TBD shows when organizers announce 2026 dates
- [ ] Resolve future-date review issues from `todo/tasks/future-date-review-2026-07-13.md`, using official organizer/club/venue sources before publishing dates.
- [ ] Use `docs/future-date-refresh-routine.md` as the source pattern for future scheduled date-refresh reports.
- [ ] Expand state pages with additional local shows
- [ ] Add operating company/entity wording to Privacy Policy, Terms, and legal pages using the business entity/DBA decision; do not list personal name or home address.
- [ ] Create dealer acquisition plan: identify target coin dealers, add/claim dealer profiles, invite dealers to submit or update listings, and track outreach/results.
- [x] Defer dealer quote requests until a reviewed dealer workflow exists; show and city pages now provide only junk-silver melt-value education, disclose that dealer offers are unavailable, and link to the calculator.
- [ ] Add server-side Cloudflare Turnstile validation via a Worker/Formspree bridge so invalid form submissions are rejected before they count against monthly Formspree quota.
- [ ] Build a server-side Cloudflare Worker bridge before re-enabling EspoCRM forwarding for Coin Shows forms; the rotated Lead Capture URL is stored locally and must never be placed in public HTML/JavaScript.
- [ ] Review saved Instagram item for Coin Shows relevance. Instagram often blocks bot fetching, so open directly or use a screenshot/summary before creating website/content/operations tasks. Source: inbox/2026-05-05_165001_milo-bot-coinshows.json

## Logo & Branding

- [ ] **Primary logo** — gold buffalo (no star) on navy background with "Coin Show Near Me" in white text below, straight line. Generate via AI image tool (ChatGPT/DALL-E or Nano), then clean up in Canva or similar. Remove watermark if using Nano free tier.
- [ ] **Transparent buffalo watermark** — large buffalo silhouette as a transparent PNG for use as a background element in the "Stay in the Loupe" CTA section (5-10% opacity, covers ~75% of section). AI generators can't output transparent PNGs directly — generate on a solid background, then use remove.bg or Canva background remover.
- [ ] **Favicon update** — create a simplified buffalo-head-only version for the browser tab icon (32x32 and 180x180 for Apple touch).
- [ ] **Create secured domain email** — choose one protected primary `contact@` or `info@` mailbox with MFA and role aliases (`legal@`, `privacy@`, `dealers@`, and `promoters@`), document provider/cost/credential location in the dashboard, then update Formspree, `/contact/`, and legal pages after controlled delivery and reply-from-domain tests.
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
- State sales tax guide for coins & precious metals (built; primary-source accuracy audit in progress)
- Beginner's guide to coin shows
- Estate / inherited coin collection guide
- Coin show trip planner / driving directions
- Selling junk silver at a coin show guide — explain melt value, condition and numismatic premiums, safe handling, and how to use the melt-value calculator before attending; do not promise advance dealer offers.
- Coin collection protection guide — compare safe types, installation and fire/water ratings, inventory documentation, and specialist coin/collectibles insurance options without endorsing an insurer before independent review.
- Buffalo logo monogram pattern — create a micro version of the buffalo nickel logo as a repeating pattern (Gucci-style interlocking monogram). Use as subtle background texture for hero, section dividers, or card backgrounds.

See `README.md` for the full show list.
