# Session State

**Last updated:** 2026-07-31 12:36 PDT
**Session:** v0.12.2 local GSC repair

## Completed today
- Classified current GSC evidence: two old 404s, no current 403/redirect category, one intentional noindex alias, and 32 crawled-not-indexed URLs.
- Added seven evidence-backed one-hop city redirects, including Westland→Warren and malformed Creating Collectors→Tucson.
- Corrected Tucson Coin and Currency Expo from its official organizer site and registered the source.
- Made `shows.json` deterministic from 197 YAML records and kept `widget.html` published but noindex.
- Added redirect, feed-parity, indexing, and data-correction regression tests; final local validation passes.

## In progress
- No active code work; awaiting explicit push/deployment approval.

## Next up
- Await explicit approval before any push/deployment; after verified production, resubmit the sitemap and restart only the failed 404 validation.

## Open decisions
- Full local Jekyll build is unavailable; nothing is pushed/deployed and no GSC control has changed.
