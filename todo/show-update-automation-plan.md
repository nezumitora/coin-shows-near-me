# Show-update automation plan

Goal: keep show listings fresh without blindly overwriting manual edits or publishing unreviewed scraped content.

## Current audit result

- Tracked scheduled workflow found: `.github/workflows/update-spot-prices.yml`.
- No tracked weekly show-scraper/update workflow found in this worktree.
- No tracked scraper script found under `_scripts/` during this pass.

## Safe implementation pattern

1. Run weekly and by manual dispatch.
2. Read current `_data/shows.yml` and source URLs already stored in show data.
3. Rate-limit requests and record source URL, status, and fetch timestamp per listing.
4. Write proposed changes to a branch, artifact, or report only.
5. Summarize added, changed, removed, and failed-to-check shows.
6. Require manual review before merging/publishing.
7. Never submit customer forms, send emails/texts, or change CRM records.

## Recommended first automation milestone

- Create a weekly report-only GitHub Actions workflow that checks existing organizer URLs, flags stale/TBD/partial dates, and opens a review artifact.
- After the report is trustworthy, add source-specific parsers for organizer pages one at a time.

## Implemented in v0.9.3 worktree

- Added `_scripts/show-update-report.rb` to generate a review-only freshness report.
- Added `.github/workflows/show-update-report.yml` to run weekly and on manual dispatch.
- The workflow uploads an artifact only; it does not commit, push, publish, email, text, or submit forms.

## Implemented in v0.9.4 worktree

- Changed the report workflow to run daily because the site is live and accuracy is urgent.
- Expanded the report to check every stored organizer/source URL by default.
- Added source-domain inventory and CSV artifacts so the user can see which sites/listings are being checked.

## Next urgent phase

- Add comparison-only external source configs after exact source URLs are approved.
- Each external source should produce a “missing from our site / differs from our site” report first.
- Do not auto-edit `_data/shows.yml` until reports are trustworthy and updates are manually reviewed.

## Implemented in v0.9.6 worktree

- Added `_scrapers/external-sources.yml` with three report-only sources already present in `_data/shows.yml`: FUN Topics, Pacific Expos LLC, and Michigan Coin Club.
- Added `_scripts/external-source-compare.rb` to fetch those source pages, compare configured show names/dates, and write review artifacts.
- Added `.github/workflows/external-source-comparison.yml` to run the comparison daily and on manual dispatch.

## Implemented in v0.9.7 worktree

- Added `_scrapers/third-party-discovery.yml` for CoinZip and CoinShows-USA URLs already present in `README.md` historical source notes.
- Added `_scripts/third-party-discovery-report.rb` to create report-only third-party discovery artifacts.
- Added `.github/workflows/third-party-discovery.yml` to run the discovery report daily and on manual dispatch.
- Third-party directory findings are leads only; official organizer/club confirmation is required before changing show data.

## Implemented in v0.9.8 worktree

- Improved `_scripts/third-party-discovery-report.rb` to show final redirected URLs and classify source pages as `not_found`, `generic_directory`, `needs_parser`, or `review_leads`.
- Added a “What Milo should check” report section so the artifact is easier to review without coding knowledge.

## Implemented in v0.9.9 worktree

- Added `docs/third-party-directory-sop.md` for safe third-party directory use, fake-entry risk checks, and verification rules.
- Updated CoinZip discovery URLs from dead historical state paths to current working category URLs.
- Changed the scheduled discovery workflow delay to 10 seconds to respect CoinZip `robots.txt` crawl-delay guidance.
