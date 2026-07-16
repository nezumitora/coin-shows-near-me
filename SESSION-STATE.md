# Session State

**Last updated:** 2026-07-16 00:31 (PDT)
**Session:** nationwide show refresh priority

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
- Committed verified corrections as `c4e6da7 Verify upcoming show listing details`.
- Started nationwide refresh: inventoried current coverage and updated Arkansas State, APNSCC, WNY, and Knoxville listings from source/lead pages.
- Committed first nationwide refresh batch as `5501d58 Start nationwide show refresh`.
- Expanded third-party discovery config from 8 historical sources to 39 CoinZip state category sources plus 2 broken CoinShows-USA evidence URLs; added optional lead-detail CSV extraction.
- Added official-source updates for Great American Coin and Collectibles Show, CSNS Convention, and Cleveland Coin Expo records; added CK/GACCS/Cleveland/CSNS sources to comparison config.
- Added 9 more official/promoter sources to the report-only comparison config and included third-party lead-detail CSV in the scheduled discovery artifact upload.
- Verified PA/CA/OH lead batch from official club pages and added/updated Lehigh County Coin Expo, Sacramento Valley Coin Club Fall Coin Show, and OH-KAN Coin Club Show; regenerated affected state/city/show pages.
- Added v0.9.13 verified agent-side source batch: Florida, Pennsylvania, California, and Ohio source reviews added/updated 14 more show records and expanded official source monitoring to 37 sources.
- Added v0.9.14 NY/MI/IL/NC verified source batch: updated NYINC, Melville, Royal Oak, Raleigh, ILNA, Orland Park, and Peotone records and added their official source monitors.
- Published v0.9.14 live: pushed branch `social-ads-tools-20260715`, merged PR #73 (`b60fb00`), and verified GitHub Pages deployment run `29476634056` completed successfully.

## In progress
- Live site is on v0.9.14; continue remaining unverified leads in the next batch.

## Next up
- Add official social URLs to `_data/shows.yml` / `_data/dealers.yml` only after source verification.
- Add official sources for the 181 listings now queued by the review-only verification report.
- Add real sponsored ad links later with `rel="sponsored nofollow noopener noreferrer"`.
- Next checkpoint should start from merged main after PR #73 if continuing launch-ready work.
- Build source coverage state-by-state and add verified new/current shows in batches.

## Open decisions
- Many listings lack official source URLs, so automated future-show verification will be partial until sources are added.
- Local Jekyll build still needs repo-specific Ruby setup/Gemfile; GitHub Pages remains the likely build gate.
- Third-party directory leads without official organizer confirmation should be marked in verification notes and revisited, not treated as fully official.
