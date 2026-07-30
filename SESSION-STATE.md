# Session State

**Last updated:** 2026-07-30 11:20 (PDT)
**Session:** v0.12.0 reminders, organizer forms, and listing review

## Completed today
- v0.12.0 moved spot prices and reminder signup below the search hero, added names/show interests and separate optional SMS consent.
- CRM payload mapping now prioritizes explicit first/last names and never infers SMS consent from phone or other consent.
- Improved submit-show location layout and accessible thank-you promotion linking to `https://coinshownearme.com/`.
- Added manually reviewed listing-removal requests plus public-event/privacy guidance.
- Checkpointed implementation as `355c287` and layout polish as `4da8258`; nothing pushed or deployed.
- Passed 50 Ruby tests/162 assertions, 6 search tests, data validation, deterministic generation, Jekyll build, localhost checks, and visual QA.
## In progress
- v0.12.0 is complete locally; review pages at `http://127.0.0.1:4187/`, `/submit-show/`, and `/shows/local-review-test-coin-show/`.
## Next up
- Await visual review; prepare a PR only after separate push approval.
## Open decisions
- PR #82 still requires a separate merge decision; v0.12.0 remains local until push approval.
- Expired-page redirect, canonical, sitemap, and index/noindex policy remains pending external expert feedback.
