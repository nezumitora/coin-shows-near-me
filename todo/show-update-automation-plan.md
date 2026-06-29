# Weekly show-update automation plan

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
