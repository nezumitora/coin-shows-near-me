# Coin Shows Near Me — TODO

## Pending

- [ ] Merge PR #1 (SEO buildout + tools) — waiting on site setup
- [ ] Point coinshownearme.com DNS to GitHub Pages and update _config.yml url

## Backlog (Needs You)

- [ ] Form DBA for coin directory `added:2025-12-24`
- [ ] Install WP Activity Log plugin `added:2026-01-16` `note:needs WP admin access`
- [ ] Sponsor local schools (Capo HS), sports teams for backlinks `added:2026-02-04` `note:someone recommended monthly zoom + sponsorships for link building`
- [ ] Coin bullion tool ideas (research/brainstorm) `added:2025-12-06` `ref:chatgpt > Coins & PM's > coin bullion tool ideas`

## Done (PR #1)

### SEO Buildout
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
- [x] Melt value calculator & "Get an Offer" lead form `added:2025-12-06` — `/tools/melt-value-calculator/`
- [x] Mini coin show finder & lead capture widget `added:2025-12-06` — widget.html (updated for 98-show dataset)
- [x] Build scraper tool — show listings `added:2025-12-24` — `_scrapers/scrape_shows.py`
- [x] Build scraper tool — dealer listings `added:2025-12-24` — `_scrapers/scrape_dealers.py`
