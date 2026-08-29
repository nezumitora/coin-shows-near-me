# Session State

**Last updated:** 2026-08-29 10:07 PDT
**Session:** Contact actions and Semi-style local review owner preview

## Completed today

- Added the review-only overlay boundary to the bespoke homepage head and verified that all 495 local sitemap pages include the private review controls.
- Matched the Semi Repair owner-review sequence: **Review notes** opens the all-page panel, **Add a note** enables exact-area crosshair selection, and the selected area opens a nearby dialog with explicit Cancel and Save note controls.
- Hardened **Review notes** as an unmistakable floating navy/gold control: 170×56 pixels and 20 pixels from the desktop bottom-right; 158×52 pixels and 12 pixels from the mobile bottom-right. It remains fixed and clickable while scrolling.
- Added local saved-note editing: every note card has an accessible **Edit** action, the existing dialog preloads the note without changing its target or original timestamp, and successful saves add an optional validated update timestamp to browser-only storage and copied notes.
- Passed Brave QA for panel controls, normal pre-capture interaction, crosshair selection, viewport-clamped dialog placement, visible Save note styling, saving, pins, cross-page persistence, Refresh, Show pin, Copy all notes, Delete, Clear, and 390-pixel overflow.
- Saved the current owner-review implementation in local commits `90aaf1f` and `51d403a`; the cache-busted preview is `http://127.0.0.1:4323/?review=51d403a` and returns HTTP 200.
- Codified the reusable workflow for future sites, apps, dashboards, landing pages, ads, and visual galleries in local command-center commit `6415300`, and queued guidance for the Marketing Content Engine and Business Dashboard agents.
- Made the Contact page's error-report and dealer-listing actions clickable, preselected the allowlisted error-report reason, and restored the primary CTA to accessible Coin navy/gold styling.
- Added a local-only review-notes overlay that is enabled only with `_config.review.yml`, stores up to 100 notes in browser localStorage, and is excluded from the production Jekyll output.
- Routed general, advertising, legal, and privacy questions to their verified Coin mailbox aliases without changing forms, Formspree, CRM, Turnstile, analytics, DNS, or mail infrastructure.
- Passed the repository Ruby and JavaScript test suites, data validation, generated-page drift check, and production/review Jekyll builds. Production output contains no review interface, storage key, or capture code.
- Preserved the accepted unpublished Ahrefs, indexing, metadata, asset, weekend-copy, and image-alt repairs on the existing feature branch.
- Normalized all 197 show records against confirmed ISO dates. As of August 24, 2026, the shared classifier reports 102 scheduled, 84 date-not-confirmed, and 11 past-recurring records; no record is labeled as an ended show without an explicit flag.
- Applied one shared range/status implementation to homepage cards, show/state/city cards, This Weekend, major shows, the widget, listing review, and Event schema. The weekend filter uses Saturday/Sunday overlap and does not infer dates from recurrence prose.
- Added the explicit future-date Event schema guard, advanced all confirmed `next_date` values that had passed, and retained the frozen August 22-23 weekend regression.
- Applied the approved reminder and listing-review wording, accessible reminder-field names, and manual dealer claim/verification distinctions.
- Gated dealer public contacts behind voluntary-publication or source-verification evidence. Removed seller-contact and offer-request intake from the widget, melt calculator, and dormant portal, and reconciled privacy, terms, and disclaimer wording with the inactive service.
- Expanded the deterministic public show feed with only the non-sensitive confirmed-date fields required by the widget.
- Passed 84 Ruby tests, 16 JavaScript tests, data/feed validation, a production Jekyll build, generated-page/schema checks, desktop/mobile browser assertions, and an HTTP audit of all 495 sitemap URLs. The accessibility helper reported no errors; its sole homepage warning is the intentionally hidden spam-trap field.
- Saved the implementation in local commit `0b24059` and refreshed the verified preview at `http://localhost:3313`.
- No push, pull request, merge, deployment, production/GSC change, Ahrefs rerun, outreach, email, or DNS change occurred.

## In progress

- Owner review of the floating Review notes control, feedback workflow, contact actions, branded CTA, and legal/privacy routing wording.

## Next up

- Wait for explicit approval before any push, pull request, deployment, or production verification of the email-routing update.
- Build the protected server-side EspoCRM bridge with append-only evidence records and accepted-date revalidation.
- Manually migrate dealer public contacts only after reviewing voluntary-publication or public-source evidence.

## Open decisions

- Reminder delivery, dealer offer routing, account registration, collection uploads, and portal notifications remain inactive until their operating, privacy, security, and legal controls receive separate approval.
- Do not send the directory-expert follow-up, change GSC controls, disavow links, or alter production/mail/DNS accounts before separate approval.
