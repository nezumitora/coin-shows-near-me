# Session State

**Last updated:** 2026-08-29 13:30 PDT
**Session:** Coin v0.17.0 owner-review candidate and private all-page visual baseline

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

## Verification evidence

- Live baseline: `/Users/milohiss/.aidevops/.agent-workspace/work/site-visual-baselines/coinshownearme-com-coin-live-before-v017-2026-08-29T19-22-05-003Z`
- Candidate baseline: `/Users/milohiss/.aidevops/.agent-workspace/work/site-visual-baselines/127-0-0-1-coin-local-candidate-v017-2026-08-29T19-55-37-948Z`
- Candidate baseline: 542 routes, 1,084 PDFs, 1,082,782,002 bytes, 10 expected 404 results from five intentionally retired internal routes at two viewports, and one investigated warning inherited from the live sitemap.
- Local review origin: `http://127.0.0.1:4324/`
- Local production-form origin: `http://127.0.0.1:4325/`

## In progress

- Local commit packaging and owner review of the v0.17.0 candidate. No technical build or QA blocker remains.

## Next up

- Give the owner the fresh local review link and wait for explicit approval.
- After approval only, push/merge/deploy and verify that the live internal documents return 404 while intended public utility routes remain available.
- Promote additional official-source URLs into the fetch registry only in small, manually reviewed batches.

## Open decisions

- Survey activation, sponsorship/paid placement, reminder delivery, dealer offer routing, account registration, collection uploads, portal notifications, and a dedicated show-submission alias remain inactive until separately approved.
- Keep the protected EspoCRM bridge, Formspree authentication, directory-expert follow-up, GSC controls, disavow work, CRM migration, advertising response, and mail/DNS administration in their separate workstreams.
