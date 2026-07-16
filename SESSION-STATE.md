# Session State

**Last updated:** 2026-07-15 17:31 (PDT)
**Session:** v0.9.12 show listing verification pass

## Completed today
- v0.9.12 added optional social link rendering for show detail cards, show listing cards, and dealer cards.
- Added reusable sponsor banner placeholder include and placed it on homepage, show detail pages, dealer directory, and tools page.
- Split dealer signup website/social fields and added a show social-media submission field.
- Updated Tools page copy for the planned private, local-first coin and bullion collection app.
- Expanded the review-only show update report with future/past specific-date counts and a manual source-verification queue CSV.
- Updated visible version from v0.9.11 to v0.9.12 in homepage and sidebar footer, and added CHANGELOG entry.
- Verification: `git diff --check` passed; `ruby -c _scripts/show-update-report.rb` passed; `MAX_URL_CHECKS=0 REQUEST_DELAY_SECONDS=0 ruby _scripts/show-update-report.rb` completed; local `bundle exec jekyll build` blocked because this worktree has no Gemfile/.bundle.
- Committed feature/report changes as `28a5749 Add social links and sponsor placeholders` with no show data edits.
- Started official-source verification and corrected confirmed details for 25 future listings in `_data/shows.yml`.
- Confirmed corrections include Tucson, Gold Coast, Fort Lauderdale, Palm Beach, Greater Atlanta, Metro East, Nashua, Brunswick, North/South Metro, Portland, Sacramento, San Francisco International, Milwaukee, Low Country, Michigan, Ohio, Wisconsin, and West Virginia source-backed entries.

## In progress
- Continue official-source verification for remaining future listings; current uncommitted changes are listing-data corrections only.

## Next up
- Add official social URLs to `_data/shows.yml` / `_data/dealers.yml` only after source verification.
- Add official sources for the 181 listings now queued by the review-only verification report.
- Add real sponsored ad links later with `rel="sponsored nofollow noopener noreferrer"`.
- Re-run verification report after data corrections and commit only confirmed listing fixes.

## Open decisions
- Many listings lack official source URLs, so automated future-show verification will be partial until sources are added.
- Local Jekyll build still needs repo-specific Ruby setup/Gemfile; GitHub Pages remains the likely build gate.
