# CHANGELOG — Coin Shows Near Me (coinshownearme.com)

## Jul 29, 2026
- v0.10.0: Refocused the homepage on show discovery, removed above-the-results promotions and spot-price distractions, and added clear listing status, verification-source, and last-checked information.
- v0.9.31: Made exact two-letter state searches return only that state, added venue/address matching and regression tests, corrected the conflated Missouri Numismatic Society listing, and clarified verified versus unavailable Missouri street addresses and dates.
- v0.9.30: Resolved twenty-two expired-date records and Concord's partial date; corrected frequencies, venues, cities, and stale titles; strengthened source classifications; and merged six verified duplicate schedules while preserving redirects.
- v0.9.29: Added report-only show data-trust audit tooling with deterministic tests, and refreshed official-source classifications for the already-correct Long Beach Expo and FUN Convention records without changing their published dates.

## Jul 17, 2026
- v0.9.28: Added four official source-backed Pacific Northwest listings for Wilsonville, Grants Pass, Greater Tacoma, and the Tacoma-Lakewood Coin Club using PNNA and club event pages.
- v0.9.27: Added the official San Francisco Coin Show on August 1, 2026 at Gallery 308, Building A, Fort Mason, using the San Francisco Coin Club's dedicated show page and calendar details.

## Jul 16, 2026
- v0.9.26: Added automatic pull-request checks for Ruby syntax/tests, show and state data invariants, generated-page inventory/drift, and whitespace errors.
- v0.9.25: Added four official source-backed future shows from the Iowa Numismatic Association and Northeastern Pennsylvania club calendars—Decorah, Dubuque, Riverside, and Wilkes-Barre/Pittston—and improved external comparison for varied date formats and multi-show page association.
- v0.9.24: Added the official First Annual Lansing Coin Show, published Cupertino's exact 2027 date, removed Raleigh's expired date, canonicalized Georgia and Whitman duplicates, linked more official event pages, and added an independently reviewed source registry so official evidence counts while third-party directory leads remain queued.

## Jul 15, 2026
- v0.9.23: Rejected invalid, reversed, or implausibly long multi-day date ranges and preserved the correction form's exact visible consent wording in submitted metadata.
- v0.9.22: Canonicalized six more verified duplicate clusters—Tucson, Royal Oak, South St. Paul, Cleveland, Greenhills, and the Texas Numismatic Association—while preserving eight additional legacy URLs as redirects.
- v0.9.21: Fixed multi-day date parsing, added regression coverage, verified Iowa/Omaha and Sioux Falls listings, removed the compromised former TSNS source, corrected a misplaced Iowa record, and merged 15 legacy duplicate URLs into canonical show records with redirects.
- v0.9.20: Added official-source updates for Summer FUN, Fort Lauderdale duplicate records, EAC, PA Tri-State/ONR/Scranton, and Texas TNA records, reducing more TBD listings while preserving duplicate/stale import notes.
- v0.9.19: Applied another verified TBD cleanup batch for AZ, CA, CO, ID, MA, MI, PA, TX, VA, WA, WI, and WV, adding official source URLs, venues, dates where verified, and TBD notes where future dates are not posted.
- v0.9.18: Added per-show correction reporting CTAs/forms for visitor-submitted updates and corrected the Madison County Coin Club source URL while keeping the date TBD until a future public show date is officially posted.
- v0.9.17: Applied a larger existing-listing info sweep across CA, DE, FL, IL, IN, MI, NC, NM, NV, OH, PA, SC, and WA, filling verified dates, venues, organizers, and source URLs while flagging duplicate/stale imports for later cleanup.
- v0.9.16: Added the first verified TBD sweep batch for Fremont CA, Devens MA, and BNA Cheektowaga NY using promoter/club source pages.
- v0.9.15: Verified the Arcadia Coin Show from California Coin Events and added a source-discovery reliability task so launch readiness checks include regional promoter calendars for every TBD listing.
- v0.9.14: Added the next verified NY/MI/IL/NC source batch, including NYINC, Melville, Royal Oak, Raleigh, ILNA, Orland Park, and Peotone source-backed updates.
- v0.9.13: Added the next officially verified nationwide coin-show batch from agent-side PA/FL/CA/OH source review, expanded official source monitoring, and regenerated directory pages.
- v0.9.12: Added optional show/dealer social link rendering, future sponsor banner placeholders, clearer dealer/social submission fields, updated the tools page with the planned private coin and bullion collection app, and expanded the review-only show update report with a source-verification queue.

## Jul 8, 2026
- v0.9.11: Removed the exposed browser-side EspoCRM Lead Capture URL after rotating the Coin Shows capture key; CRM forwarding stays disabled until a server-side Cloudflare Worker bridge is approved.

## Jun 29, 2026
- v0.9.10: Added pre-submit form spam protection that hides the Formspree endpoint from simple bots, blocks honeypot fills, and rejects too-fast submissions before Formspree quota is used.
- v0.9.9: Added third-party directory verification SOP and updated CoinZip discovery to working category URLs with crawl-delay respect.
- v0.9.8: Improved third-party discovery reports to show final redirected URLs and classify NotFound/generic directory pages before review.
- v0.9.7: Added report-only third-party discovery workflow for known CoinZip and CoinShows-USA source URLs from historical README notes.
- v0.9.6: Added report-only external source comparison config, script, and daily workflow for FUN Topics, Pacific Expos LLC, and Michigan Coin Club.
- v0.9.5: Excluded internal prompt/task library folders from the public Jekyll build.
- v0.9.4: Added prompt-library folders and expanded the show-update report into a daily source inventory/URL-check automation with CSV artifacts.
- v0.9.3: Suppressed invalid Event schema for partial/TBD dates, converted valid event dates to ISO 8601, tightened mobile form/card overflow rules, and added a weekly review-only show update report workflow.
- v0.9.2: Added the live Instagram profile link to the contact page and footers.

## Jun 29, 2026
- v0.9.1: Replaced browser favicon/app icons with simplified GPT buffalo-head icon for clearer tab display.

## Apr 29, 2026
- v0.8.2: Blog page + Dealer Directory
  - **Blog** coming soon page at `/blog/` with sign-up CTA and preview of upcoming content topics
  - **Dealer Directory** at `/dealers/` — searchable, filterable directory of coin dealers
    - 16 initial dealers: online bullion dealers, auction houses, brick-and-mortar shops
    - Filter by type: All, Brick & Mortar, Online, Online + Storefront
    - Search by dealer name, city, or state
    - Each listing shows: type badge, specialties, description, website link, "Buys Coins" badge, shipping info
    - Dealer registration CTA for dealers to get listed
    - "How to Choose a Dealer" buying/selling guide with red flags section
  - Data-driven from `_data/dealers.yml`
  - Added "Find a Dealer" and "Blog" to homepage nav bar
  - Added both to sidebar nav on inner pages
- v0.8.1: Navigation overhaul + driving directions fix
  - Homepage nav now has dropdown menus: Find Shows (Browse by State, This Weekend, Major Shows), Tools (Melt Calculator, Sales Tax Guide), Guides (Beginner's Guide, Inherited Coins), Sign Up CTA
  - Dropdowns work on mobile (expand inline in hamburger menu)
  - Sidebar nav (inner pages) now shows: Browse by State, This Weekend, Tools (with children), Guides (with children)
  - Added Tools index page and made melt calc + tax guide sidebar-visible
  - Fixed: Driving Directions button now hidden when show has no venue/address
  - Cleaner nav titles: shortened sidebar labels for readability
- v0.8.0: Major content expansion — 4 new sections, 55+ new pages
  - **State Sales Tax Guide** — main index page with search/filter + 51 individual state pages. Covers bullion/coin exemption status, thresholds, effective dates, tax authority links. Data-driven from `_data/state_tax.yml`.
  - **Get Driving Directions** button on every show detail page (Google Maps link with venue pre-filled) + tax status badge linking to state's tax guide
  - **Beginner's Guide to Coin Shows** — full guide: what to expect, what to bring, how to negotiate, selling tips, etiquette, glossary of 15 numismatic terms, types of shows
  - **Inherited Coin Collection Guide** — step-by-step for "I inherited coins, now what?" Covers: don't clean, sorting, appraisals, understanding value, selling options, tax considerations, common mistakes, silver/gold ID reference
  - **Guides index page** with links to all guides and tools
  - Added Guides and Sales Tax Guide links to homepage footer
  - Added URL path/slug audit task to TODO for WordPress migration prep
- v0.7.7: Changed "Stay in the Loop" to "Stay in the Loupe" — coin collector wordplay (a loupe is the magnifying glass used to examine coins)
- v0.7.6: Show reminder CTA system — "Never Miss a Coin Show" opt-in cards
  - In-grid CTA card on homepage (positioned after first row of show cards)
  - Show-specific reminder CTA on individual show detail pages (pre-fills show name)
  - TCPA-compliant SMS consent checkbox with legal language
  - Phone field dynamically required when SMS checkbox is checked
  - Added SMS and Email Messaging Terms section (Section 9) to Terms of Use
  - Both CTAs link to Terms of Use #sms-terms anchor and Privacy Policy
  - All forms submit through Formspree with "Show Reminder Signup" subject
- v0.7.5: Improved spot ticker "Updated" text contrast — changed from muted gray to light blue-white for readability on hero gradient
- v0.7.4: Reworked forms — quote form subject now "Attendee Wants a Quote", added dealer checkbox toggle in Stay in the Loop section that reveals a dealer registration form (name, business, email, phone, website, specialty, shows attended)
- v0.7.3: Dealer portal inquiry form (Formspree) — name, email, show, interest dropdown, description
- v0.7.2: Construction banner + nav bar sticky together on scroll, filter bar offset adjusted
- v0.7.1: Added construction disclaimer banner + dealer portal CTA section

## Apr 28, 2026
- v0.7.0: Full homepage redesign — Nomads.com-inspired directory layout
  - Custom full-width homepage (no more just-the-docs sidebar on homepage)
  - Navy-to-light-blue gradient hero with search bar and stats
  - Card-based show grid with state filter pills and search
  - Grid/list view toggle
  - Featured major shows section
  - Browse by state grid
  - Info section (what is a coin show + tips for first-timers)
  - Redesigned signup CTA section
  - Mobile-responsive throughout

## Apr 26, 2026
- v0.6.0: Excluded CHANGELOG from public site (was appearing in nav)
- Fixed spot price ticker not loading (DOMContentLoaded + absolute URL)
- Fixed root cause: JS // comments killed by Jekyll line collapse (converted to /* */)
- v0.5.4: Reverted hero map, restored clean homepage

## Apr 17, 2026
- Removed 51 competitor directory links from show website fields
- Added GA4 + Microsoft Clarity analytics tracking
- Added GSC verification meta tag for coinshownearme.com property
- Enriched show data: +26 venues, +11 websites, +1 new show (197 total, 409 pages)
- v0.4.0: Fixed button text visibility + added page footer
- v0.3.0: Fixed sidebar version, button visibility, portal copy
- v0.2.0: Moved version to sidebar nav pane
- v0.1.0: Added version number to sidebar
- Show spot ticker by default + add construction disclaimer

## Apr 16, 2026
- Expanded show directory from 98 to 196 shows (407 total pages)
- Added FAQ schema markup for Google rich results
- SEO hardening: fix sitemap URL, add 404 page, improve internal linking and meta tags
- Fixed melt calculator rendering + added portal landing page and integration CTAs
- Added live spot prices: GitHub Actions hourly fetch + ticker bar + calculator auto-load
- Added gold divider and signup prompt text in launch banner
- Moved signup form into launch banner at top of page
- Connected signup form to Formspree endpoint
- Added email signup form and replaced GitHub issue links
- Fixed show cards rendering as code blocks on homepage
- Fixed logo display and updated launch banner
- Design polish: gold/navy theme, buffalo logo, launch banner
- Pointed site to coinshownearme.com custom domain
- SEO buildout: directory with 244 pages + README show list

## Feb 3, 2026
- Updated README and config

## Dec 6, 2025
- Created widget.html (embeddable coin show widget)
- Created shows.json (show data)
- Created embed-generator.html

## Dec 4, 2025
- Initial project: README, config
