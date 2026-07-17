# Session State

**Last updated:** 2026-07-17 08:25 (PDT)
**Session:** v0.9.26 pull-request checks

## Completed today
- PR #76 merged as `06ad815`; Pages run `29553467436` succeeded and live v0.9.24 plus redirects were verified.
- v0.9.25 added four official future shows: Decorah, Dubuque Tri-State, Riverside Old Capitol, and Wilkes-Barre/Pittston.
- External comparison now handles varied date formats and ties dates to the nearest configured show name on shared calendars.
- v0.9.26 adds automatic PR checks for Ruby tests/syntax, data/page invariants, generated-page drift, and whitespace.
- Data inventory validation removed 15 stale generated city pages left by earlier listing cleanup.
- Report: `total=198`, `aliases=25`, `future_specific=115`, `past_specific=0`, `tbd=80`, `missing_url=48`, `queued=87`, `source_urls=150`.
- Validation passed: 34 Ruby assertions, syntax, 50-state/198-show/25-alias invariants, 450-page generation, and diff checks.
## In progress
- Commit and push v0.9.26 to draft PR #77, then confirm its new automated check passes.

## Next up
- Review and approve PR #77 separately after checks pass; GitHub Pages remains the final deployment gate.
- Continue the 87-item review queue later; new verified shows increased coverage but did not change the queue count.
## Open decisions
- GitHub Pages remains the final Jekyll build gate because the repo has no Gemfile.
- Third-party leads stay unverified until an official source is approved separately.
