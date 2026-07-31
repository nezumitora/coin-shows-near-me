# Session State

**Last updated:** 2026-07-31 15:59 PDT
**Session:** v0.14.0 local review iteration

## Completed today
- Preserved the committed v0.13.0 homepage, filtering, form, address, and local-fixture checkpoint at `f5ff22d`.
- Added a compact dealer-listing CTA above dealer search while retaining the detailed lower CTA.
- Replaced three stacked show-management forms with distinct single-open correction, organizer-verification, and listing-review workflows.
- Verified all three local fixture workflows succeed with zero external submissions on desktop and mobile.
- Fixed mobile overflow, passed all build/tests/data checks, and logged a cautious Ahrefs audit without removal or disavow action.

## In progress
- v0.14.0 is ready for user review at `http://127.0.0.1:4188/`; no code change is pending.

## Next up
- Review `/dealers/` and `/review/test-show/`, then separately continue address, domain-mail, and backlink-audit work.

## Open decisions
- Do not push/deploy, change GSC, disavow links, or alter mail/DNS accounts before separate approval.
