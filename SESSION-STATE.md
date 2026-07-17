# Session State

**Last updated:** 2026-07-16 16:36 (PDT)
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
- Started v0.9.15 reliability fix after Arcadia CA source gap: verified Arcadia from California Coin Events, added the official source monitor, and added a launch-readiness task to discover regional promoter calendars for every TBD listing.
- Published v0.9.15 live: PR #74 merged (`64af18b`), and GitHub Pages deployment run `29477945711` completed successfully.
- Added v0.9.16 first TBD sweep batch: updated Fremont CA, Devens MA, and BNA Cheektowaga NY from promoter/club source pages and bumped visible version.
- Verification: `git diff --check` passed; `_data/shows.yml` YAML parsed; `ruby -c _scripts/show-update-report.rb` passed; `MAX_URL_CHECKS=0 REQUEST_DELAY_SECONDS=0 ruby _scripts/show-update-report.rb` completed with TBD count reduced from 118 to 115.
- Started v0.9.17 larger existing-listing info sweep: applied verified source-backed updates for CA/DE/FL/IL/IN/MI/NC/NM/NV/OH/PA/SC/WA records and marked duplicate/stale imports for later canonicalization.
- Verification: `git diff --check` passed; `_data/shows.yml` YAML parsed; `ruby -c _scripts/show-update-report.rb` passed; `MAX_URL_CHECKS=0 REQUEST_DELAY_SECONDS=0 ruby _scripts/show-update-report.rb` completed with TBD count reduced from 115 to 106 and missing source URLs reduced from 94 to 79.
- Started v0.9.18: added show-correction CTA/forms on show pages/cards and corrected Madison County Coin Club source URL to `http://mccc.anaclubs.org/`; no future public show date found, so next date remains TBD.
- Verification: `git diff --check` passed; `_data/shows.yml` YAML parsed; `ruby -c _scripts/show-update-report.rb` passed; `MAX_URL_CHECKS=0 REQUEST_DELAY_SECONDS=0 ruby _scripts/show-update-report.rb` completed.
- Checkpoint saved with local commits ahead of origin: `95d2c31` v0.9.16 TBD source batch, `86ab19f` v0.9.17 larger info sweep, `e17e327` v0.9.18 show correction reporting.
- Started v0.9.19: applied next verified TBD cleanup batch for AZ, CA, CO, ID, MA, MI, PA, TX, VA, WA, WI, and WV; added official source URLs, source types, venues, dates where verified, and explicit TBD notes for records with only past/undated official sources.
- Started v0.9.20: added official-source updates for Summer FUN, Fort Lauderdale duplicate records, EAC, PA Tri-State/ONR/Scranton, and Texas TNA records while preserving duplicate/stale import notes.
- Verification: `git diff --check` passed; `_data/shows.yml` YAML parsed; `ruby -c _scripts/show-update-report.rb` passed; report completed with TBD count reduced to 85 and source URLs increased to 153.
- Checkpoint saved after commit `349d997` (`Reduce remaining TBD show listings`); branch is ahead of origin with local-only v0.9.16-v0.9.20 work and untracked generated `tmp/` report artifacts.
- v0.9.21 fixed multi-day date-range parsing in the review report and added regression tests; future-specific classification increased from 67 to 123 and the verification queue dropped from 157 to 107 without changing show facts.
- Verification: parser tests passed (5 runs, 5 assertions); Ruby syntax and `git diff --check` passed; report now identifies only one genuinely past specific date.
- Expanded v0.9.21 with official Iowa association and AMA promoter updates: exact INA Convention and Sioux Falls dates, Fort Dodge source history, corrected Waterloo/Cedar Falls from an invalid Massachusetts import, and verified remaining Omaha monthly dates.
- Removed the former TSNS domain because it now serves unrelated gambling content, and changed IMEX's unsupported October 2026 placeholder to TBD after the official page still showed only 2025.
- Added canonical alias redirects and merged Omaha, Van Nuys, Fort Lauderdale, Southern Idaho, and Tri-State duplicate/date-instance records; directory now has 201 canonical listings plus 15 preserved legacy redirects.
- Final report: `specific=118`, `future_specific=117`, `past_specific=1`, `partial=3`, `tbd=80`, `missing_url=59`, `queued=99`, `source_urls=142`.
- v0.9.22 merged six additional source-confirmed duplicate clusters for Tucson, Royal Oak, South St. Paul, Cleveland, Greenhills, and TNA while retaining their old URLs as redirects.
- v0.9.22 report: `total=195`, `aliases=23`, `specific=112`, `future_specific=111`, `past_specific=1`, `partial=3`, `tbd=80`, `missing_url=56`, `queued=96`, `source_urls=139`.
- Checkpoint saved for the complete v0.9.22 local batch; only generated `tmp/` reports remain untracked.

## In progress
- v0.9.22 report/source/canonicalization work is verified locally; the user authorized a branch push and pull request for review.

## Next up
- Add official social URLs to `_data/shows.yml` / `_data/dealers.yml` only after source verification.
- Add official sources or explicit no-future-date evidence for the 96 listings now queued by the review-only verification report.
- Add real sponsored ad links later with `rel="sponsored nofollow noopener noreferrer"`.
- Next checkpoint should start from merged main after PR #73 if continuing launch-ready work.
- Build source coverage state-by-state and add verified new/current shows in batches.

## Open decisions
- Many listings lack official source URLs, so automated future-show verification will be partial until sources are added.
- Local Jekyll build still needs repo-specific Ruby setup/Gemfile; GitHub Pages remains the likely build gate.
- Third-party directory leads without official organizer confirmation should be marked in verification notes and revisited, not treated as fully official.
