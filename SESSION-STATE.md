# Session State

**Last updated:** 2026-07-17 07:52 (PDT)
**Session:** v0.9.25 next official-source batch

## Completed today
- PR #76 merged as `06ad815`; Pages run `29553467436` succeeded and live v0.9.24 plus redirects were verified.
- v0.9.25 added four official future shows: Decorah, Dubuque Tri-State, Riverside Old Capitol, and Wilkes-Barre/Pittston.
- External comparison now handles varied date formats and ties dates to the nearest configured show name on shared calendars.
- Report: `total=198`, `aliases=25`, `future_specific=115`, `past_specific=0`, `tbd=80`, `missing_url=48`, `queued=87`, `source_urls=150`.
- Validation passed: 34 Ruby assertions, syntax, YAML, aliases/IDs, 450-page generation, 79-row source comparison, diff check, and final audit.
## In progress
- v0.9.25 commits `187922a` and `4fdb38b` are pushed; draft PR #77 is mergeable and awaits separate merge/deploy approval.

## Next up
- Review and approve PR #77 separately before merge/deploy; GitHub Pages will be the final build gate.
- Continue the 87-item review queue later; new verified shows increased coverage but did not change the queue count.
## Open decisions
- GitHub Pages remains the final Jekyll build gate because the repo has no Gemfile.
- Third-party leads stay unverified until an official source is approved separately.
