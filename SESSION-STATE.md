# Session State

**Last updated:** 2026-07-31 10:58 PDT
**Session:** v0.12.1 GSC URL evidence checkpoint

## Completed today
- Preserved local-only v0.12.1 and recorded the reusable directory-expert guidance in `621a8ec`.
- GSC 404 validation failed with two URLs: `/cities/westland-mi/` crawled 2026-07-24 and `/states/{search_term}` crawled 2026-07-12.
- The placeholder was removed on 2026-07-18 after its last crawl; do not restart validation until the remaining URL fix is deployed.
- Westland was deleted after the verified show moved to Warren; `/cities/warren-mi/` is the clear successor and needs a redirect.
- A parity audit found `shows.json` substantially stale: 197 YAML records, 199 JSON records, 30 missing IDs, 32 extra IDs, and 164 core-field mismatches.

## In progress
- Collecting noindex, 403, and redirect GSC examples; no validation or live indexing change has been started.

## Next up
- Capture noindex examples, then implement/test the Westland redirect and a deterministic `shows.json` sync fix separately.

## Open decisions
- Nothing is pushed or deployed; GSC validation waits for verified deployment.
