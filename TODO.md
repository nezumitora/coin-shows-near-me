# Coin Shows Near Me — TODO

## Pending

- [ ] Merge PR #1 (full site buildout) — waiting on site setup
- [ ] Point coinshownearme.com DNS to GitHub Pages and update _config.yml url
- [ ] Set up Formspree endpoints for all forms (dealer, offers, promoter, attendee) — see _config.yml comments
- [ ] Have a licensed attorney review Terms of Use and Privacy Policy
- [ ] Set up legal@, privacy@, dealers@, promoters@ email addresses at coinshownearme.com

## Backlog (Needs You)

- [ ] Form DBA for coin directory `added:2025-12-24`
- [ ] Install WP Activity Log plugin `added:2026-01-16` `note:needs WP admin access`
- [ ] Sponsor local schools (Capo HS), sports teams for backlinks `added:2026-02-04` `note:someone recommended monthly zoom + sponsorships for link building`
- [ ] Coin bullion tool ideas (research/brainstorm) `added:2025-12-06` `ref:chatgpt > Coins & PM's > coin bullion tool ideas`

## Done (PR #1)

### SEO Buildout (244 pages)
- [x] Extract README show data into _data/shows.yml + _data/states.yml
- [x] Build Jekyll layouts (state, city, show, weekend)
- [x] Build includes (schema.org Event JSON-LD, breadcrumbs, show cards, SEO meta)
- [x] Generate 50 state pages + state index
- [x] Generate 95 city pages
- [x] Generate 98 individual show pages
- [x] Build homepage (target: "coin shows near me")
- [x] Build "coin shows this weekend" page
- [x] Update _config.yml for SEO settings (sitemap, seo-tag plugins)
- [x] Backfill shows.json from full dataset (98 shows for widget)
- [x] Add robots.txt + sitemap reference

### Tools Built
- [x] Melt value calculator & "Get an Offer" lead form — `/tools/melt-value-calculator/`
- [x] Mini coin show finder & lead capture widget — widget.html (updated for 98-show dataset)
- [x] Build scraper tool — show listings — `_scrapers/scrape_shows.py`
- [x] Build scraper tool — dealer listings — `_scrapers/scrape_dealers.py`

### Portals & Platform Features
- [x] Dealer Portal — `/dealers/` — registration, show attendance verification, specialty selection
- [x] Pre-Show Offer System — `/get-offers/` — sellers submit collections to attending dealers with photos
- [x] Attendee Portal — `/attendees/` — collection inventory builder with item-by-item + bulk upload
- [x] Promoter Submission — `/promoters/` — add your show to the directory
- [x] Shared form styles + configurable form handler (Formspree, swappable to WP backend)

### Legal
- [x] Terms of Use — `/legal/terms-of-use/` — comprehensive platform TOS with transaction liability, indemnification, arbitration
- [x] Privacy Policy — `/legal/privacy-policy/` — CCPA/CPRA compliant
- [x] Disclaimer — `/legal/disclaimer/` — transaction, appraisal, listing, dealer verification disclaimers
