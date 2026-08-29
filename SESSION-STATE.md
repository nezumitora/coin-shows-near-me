# Session State

**Last updated:** 2026-08-28 23:44 PDT
**Session:** Contact actions and direct local review owner preview

## Completed today

- Changed local review-note capture to open directly on right-click or Control-click, retaining the crosshair action as the touchscreen fallback.
- Made the Contact page's error-report and dealer-listing actions clickable, preselected the allowlisted error-report reason, and restored the primary CTA to accessible Coin navy/gold styling.
- Added a local-only review-notes overlay that is enabled only with `_config.review.yml`, stores up to 100 notes in browser localStorage, and is excluded from the production Jekyll output.
- Routed general, advertising, legal, and privacy questions to their verified Coin mailbox aliases without changing forms, Formspree, CRM, Turnstile, analytics, DNS, or mail infrastructure.
- Passed the repository Ruby and JavaScript test suites, data validation, generated-page drift check, and a production Jekyll build. The isolated local owner preview is available at `http://localhost:4323`.
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

- Owner review of the contact actions, branded CTA, local review overlay, and legal/privacy routing wording.

## Next up

- Wait for explicit approval before any push, pull request, deployment, or production verification of the email-routing update.
- Build the protected server-side EspoCRM bridge with append-only evidence records and accepted-date revalidation.
- Manually migrate dealer public contacts only after reviewing voluntary-publication or public-source evidence.

## Open decisions

- Reminder delivery, dealer offer routing, account registration, collection uploads, and portal notifications remain inactive until their operating, privacy, security, and legal controls receive separate approval.
- Do not send the directory-expert follow-up, change GSC controls, disavow links, or alter production/mail/DNS accounts before separate approval.
