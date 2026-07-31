# Session State

**Last updated:** 2026-07-31 14:02 PDT
**Session:** v0.12.2 local review recovery

## Completed today
- Classified current GSC evidence and added seven evidence-backed one-hop city redirects, including Westland→Warren and malformed Creating Collectors→Tucson.
- Corrected Tucson Coin and Currency Expo from its official organizer site and registered the source.
- Made `shows.json` deterministic from 197 YAML records and kept `widget.html` published but noindex.
- Added redirect, feed-parity, indexing, and data-correction regression tests; final local validation passes.
- Recovered the user review checkpoint and confirmed the older v0.9.35 Long Beach and FUN corrections are present equivalently in this branch.

## In progress
- Resume user visual review using the healthy localhost preview; the current rendered preview is v0.12.0, not final v0.12.2.

## Next up
- Review the homepage, submit-show workflow, organizer verification, Long Beach listing, and FUN listing before preparing a current v0.12.2 preview.

## Open decisions
- User explicitly denied deployment; nothing may be pushed/deployed and no GSC control may change before review and separate approval.
