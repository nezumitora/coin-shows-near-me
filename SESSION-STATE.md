# Session State

**Last updated:** 2026-07-30 20:16 (PDT)
**Session:** v0.12.1 reminder-interest safety revision

## Completed today
- v0.12.0 moved spot prices and reminder signup below the search hero and added names/show interests.
- CRM payload mapping now prioritizes explicit first/last names and never infers SMS consent from phone or other consent.
- Improved submit-show location layout and accessible thank-you promotion linking to `https://coinshownearme.com/`.
- Added manually reviewed listing-removal requests plus public-event/privacy guidance.
- User approved v0.12.1: reminder forms are accurate interest lists; mobile/SMS and unrelated reminder opt-ins are removed.
- Updated consent, privacy, terms, design guidance, tests, changelog, and visible version to v0.12.1 in `48c3420`.
- Passed 52 Ruby tests/192 assertions, 6 search tests, data validation, deterministic generation, and whitespace checks.
## In progress
- v0.12.1 is complete and committed locally.
## Next up
- Await separate approval before pushing or preparing a PR.
## Open decisions
- Nothing is pushed or deployed; a full Jekyll build is unavailable locally because the repo has no Gemfile and the cached image lacks `jekyll-remote-theme`.
- Expired-page redirect, canonical, sitemap, and index/noindex policy remains pending external expert feedback.
