# Session State

**Last updated:** 2026-07-30 19:42 (PDT)
**Session:** v0.12.0 reminders, organizer forms, and listing review

## Completed today
- v0.12.0 moved spot prices and reminder signup below the search hero, added names/show interests and separate optional SMS consent.
- CRM payload mapping now prioritizes explicit first/last names and never infers SMS consent from phone or other consent.
- Improved submit-show location layout and accessible thank-you promotion linking to `https://coinshownearme.com/`.
- Added manually reviewed listing-removal requests plus public-event/privacy guidance.
- Checkpointed implementation as `355c287` and layout polish as `4da8258`; nothing pushed or deployed.
- Passed 50 Ruby tests/162 assertions, 6 search tests, data validation, deterministic generation, Jekyll build, localhost checks, and visual QA.
- Direct review reconfirmed the Missouri listing facts from the cited official MNS page and expired HICOMO source.
## In progress
- Publication review found that reminder forms promise email/SMS delivery while the current Formspree path only sends an internal notification and dashboard policy says no production reminder or SMS automation is approved.
## Next up
- Decide whether to publish accurate interest-capture wording or first build and approve real reminder delivery; prepare a PR only after separate push approval.
## Open decisions
- PR #82 is already merged; v0.12.0 remains local until push approval and the reminder-delivery mismatch is resolved.
- Expired-page redirect, canonical, sitemap, and index/noindex policy remains pending external expert feedback.
