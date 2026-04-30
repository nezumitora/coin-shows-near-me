# CHANGELOG — Coin Shows Near Me (coinshownearme.com)

## Apr 29, 2026
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
