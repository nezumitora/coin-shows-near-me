# Session State

**Last updated:** 2026-08-25 09:03 PDT
**Session:** Ahrefs local repairs, directory date integrity, dealer privacy, and WCAG contrast

## Completed today

- Preserved the accepted unpublished Ahrefs, indexing, metadata, asset, weekend-copy, and image-alt repairs on the existing feature branch.
- Normalized all 197 show records against confirmed ISO dates. As of August 24, 2026, the shared classifier reports 102 scheduled, 84 date-not-confirmed, and 11 past-recurring records; no record is labeled as an ended show without an explicit flag.
- Applied one shared range/status implementation to homepage cards, show/state/city cards, This Weekend, major shows, the widget, listing review, and Event schema. The weekend filter uses Saturday/Sunday overlap and does not infer dates from recurrence prose.
- Added the explicit future-date Event schema guard, advanced all confirmed `next_date` values that had passed, and retained the frozen August 22-23 weekend regression.
- Applied the approved reminder and listing-review wording, accessible reminder-field names, and manual dealer claim/verification distinctions.
- Gated dealer public contacts behind voluntary-publication or source-verification evidence. Removed seller-contact and offer-request intake from the widget, melt calculator, and dormant portal, and reconciled privacy, terms, and disclaimer wording with the inactive service.
- Expanded the deterministic public show feed with only the non-sensitive confirmed-date fields required by the widget.
- Passed 84 Ruby tests, 16 JavaScript tests, data/feed validation, a production Jekyll build, generated-page/schema checks, desktop/mobile browser assertions, and an HTTP audit of all 495 sitemap URLs. The accessibility helper reported no errors; its sole homepage warning is the intentionally hidden spam-trap field.
- Corrected verified WCAG AA failures in normal gold links, white-on-gold controls, state and dealer badges, state counts, action buttons, and light/dark footer text. The dark brand gold is now `#7a5700`; `DESIGN.md` records the accessible usage rule.
- Passed Lighthouse 13.0.3 color-contrast audits with zero failures on 14 representative pages, including the homepage, weekend page, two show pages, dealer directory, portal, calculator, widget, embed generator, blog, 404 page, sales-tax index, and a state tax guide.
- Re-ran 84 Ruby tests with 8,310 assertions, 16 JavaScript tests, data validation, whitespace checks, and the production Jekyll build after the final contrast changes.
- Saved the core implementation in local commit `0b24059`, its prior preview record in `53dab93`, and the WCAG repair in `f5ae130`; refreshed the verified preview at `http://localhost:3313`.
- No push, pull request, merge, deployment, production/GSC change, Ahrefs rerun, outreach, email, or DNS change occurred.

## In progress

- None.

## Next up

- Review the final local preview and wait for explicit approval before any push, pull request, deployment, or production verification.
- Build the protected server-side EspoCRM bridge with append-only evidence records and accepted-date revalidation.
- Manually migrate dealer public contacts only after reviewing voluntary-publication or public-source evidence.

## Open decisions

- Reminder delivery, dealer offer routing, account registration, collection uploads, and portal notifications remain inactive until their operating, privacy, security, and legal controls receive separate approval.
- Do not send the directory-expert follow-up, change GSC controls, disavow links, or alter production/mail/DNS accounts before separate approval.
