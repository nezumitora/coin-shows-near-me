# Session State

**Last updated:** 2026-10-26
**Session:** Kent dealer publication and PNNA rotation after reboot

## Current restart handoff

- Owner approved publishing Kent Coin and Bullion's regular dealer listing and
  complimentary `Featured dealer` placement. This is separate from paid sponsorship
  and claim/verification status. Implementation and verification are recorded in
  `docs/kent-dealer-preview.md`; consult it, not only the show-refresh notes.
- PNNA's owner-supplied clean calendar URL is registered alongside the existing
  mobile calendar. Recurring rotation/holds are recorded in
  `docs/listing-source-review-ledger.md` and `docs/listing-refresh-operations.md`.
- Existing tests, validator, generated currentness, source dry run and production
  Jekyll build passed. Desktop/mobile Kent visual and functional checks passed.
  Published through PR #106, merge `9aa778b660b6ed30ab31ee0bf5d109c3f3c101ad`;
  exact-SHA Pages run `40402864790` succeeded October 26 at 21:18:25 UTC.
  Live directory and representative show-page desktop/mobile captures returned
  HTTP 200, displayed the Kent placement and had no console errors. Live directory
  readback confirms the separate regular listing and approved public contacts.
- The previous listing catch-up published 225 canonical shows; exact receipts are
  in `docs/listing-refresh-status.md`. This Kent/PNNA change does not alter shows.
- Next work after Kent publication: verify reviewer operation after reboot,
  continue remaining nationwide source rotation, and fix empty discovery details.
- The August notes below are historical, not current publication authority or a
  reliable indication of today's live state. Do not restart those completed tasks.

## Historical August 29 owner-review handoff

## Completed today

- Addressed all 19 owner-review notes with implementation, evidence, or an explicit approval boundary. Public directory totals now come from canonical show records, filtered counts explain their browser behavior, and stale `190+` claims were removed.
- Updated the visible version to v0.17.0 and refined navigation, contact/show-submission paths, Major Shows guidance, collector scam guidance, tax-review wording, and the melt calculator's silver, gold, platinum, and palladium labels and calculations.
- Removed the unused Instagram links and kept paid placement/sponsorship absent pending a separately approved placement and disclosure model.
- Kept the Collection Tracker feature survey inside `site.review_mode` only. The local form sends nothing; production retains the existing **Share Feedback** path and the privacy policy identifies survey collection as inactive.
- Expanded official-source comparison coverage safely: only 48 hand-reviewed source groups may be fetched, while 71 listings across 66 existing approved-source URLs are written to a review queue without network requests or data edits. Pacific Expos North County now uses its exact official dates page.
- Preserved the fixed cross-page **Review notes** workflow and editable saved notes. Editing retains the target and original creation time and records a separate update time.
- Passed syntax checks for all Ruby scripts, 86 Ruby tests with 8,388 assertions, 16 JavaScript tests, data validation for 50 states/197 shows, generated-page checks, and a no-network external-source dry run with 79 comparison rows.
- Passed production and review Jekyll builds. Production has 495 sitemap routes and 538 generated HTML files with no review controls or `SESSION-STATE.html`; review controls appear on all 495 sitemap routes.
- Passed desktop and 390-pixel Brave QA across the homepage, Contact, melt calculator, Collection Tracker, sales-tax guide, and Major Shows. No external form submission occurred, production had no review storage/UI, calculator assertions passed, and `/SESSION-STATE.html` returned 404 locally.
- Saved private live and candidate PDF baselines outside Git for the same 542-route desktop/mobile inventory: 1,084 PDFs in each archive. Comparison reports zero missing and zero added results.
- Classified all 24 page/viewport HTTP-status transitions: six city routes and `/submit-show/` improve from 404 to 200; `SESSION-STATE.html` and four internal documentation pages intentionally change from 200 to 404. Public portal, widget, embed-generator, and Creating Collectors routes retain successful status.
- Confirmed the live site currently exposes `SESSION-STATE.html`; the production-form candidate removes it. Deployment remains approval-gated.
- No push, pull request, merge, deployment, publication, survey activation, sponsorship, alias creation, outreach, email, CRM, DNS, GSC, or production-account change occurred.
- Added the durable five-note owner archive in `_data/review_note_archive.yml` and `docs/review-note-archive.md`. The review-only panel now preserves the original note numbering and resolution state, and **Go to change** carries the note ID across routes to scroll and flash the target and numbered pin.
- Rechecked Pacific Expos' exact official North County dates page and home page: neither supports a September 5-6 North County or Buena Park listing. No show date was added. The report-only source comparison remains systematic only across its hand-reviewed registry and retains blind spots for unlisted, unavailable, or incomplete sources.
- Changed the local Collection Tracker survey to state plainly that it sends nowhere, stores nothing remotely, and is inactive in production. Moved the local no-send return before any spam or form handler.
- Added exact-record dealer claim selection and opening behavior, plus a manual show-claim request in the existing exact-record show review flow. Neither action auto-verifies, publishes, or requests identity documents.

## Verification evidence

- Live baseline: captured privately before v0.17.
- Candidate baseline: captured privately for the v0.17 candidate.
- Candidate baseline: 542 routes, 1,084 PDFs, 1,082,782,002 bytes, 10 expected 404 results from five intentionally retired internal routes at two viewports, and one investigated warning inherited from the live sitemap.
- Local review origin: `http://127.0.0.1:4324/`
- Local production-form origin: `http://127.0.0.1:4325/`

## In progress

- Run round-2 tests, production/review builds, and desktop/mobile QA; then package the local owner-review candidate. No merge or deployment is authorized.

## Next up

- Give the owner the fresh local review link and wait for explicit approval.
- After approval only, push/merge/deploy and verify that the live internal documents return 404 while intended public utility routes remain available.
- Promote additional official-source URLs into the fetch registry only in small, manually reviewed batches.

## Open decisions

- Survey activation, sponsorship/paid placement, reminder delivery, dealer offer routing, account registration, collection uploads, portal notifications, and a dedicated show-submission alias remain inactive until separately approved.
- The owner may decide later whether dealer claims should use a modal instead of the accessible in-page exact-record form. No modal has been added.
- Keep the protected EspoCRM bridge, Formspree authentication, directory-expert follow-up, GSC controls, disavow work, CRM migration, advertising response, and mail/DNS administration in their separate workstreams.
