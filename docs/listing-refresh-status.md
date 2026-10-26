# Listing refresh status

## Last published batch

- Published UTC: **2026-10-26T04:03:02Z** (October 25 Pacific).
- PR: #96.
- Merge: `67def46e98df8a4cc2d547e4c95aa11d1a7d868c`.
- Successful Pages run: `40266952526`.
- Public feed readback: **208 canonical shows** (previously 197).
- Added: **11 show/series records**, all Michigan; updated: **6 existing records**
  in California, Colorado and Michigan. Not eleven single occurrence dates.
- Official evidence: `docs/listing-catchup-2026-10-26.md`.
- Upstream artifacts inspected: comparison run `40198661144` and discovery run
  `40199666789`, October 25 UTC. Original private caches/artifacts are not committed.

## Scope still outstanding

The previous publication was September 4: approximately seven weeks of elapsed
listing-maintenance lag before this batch. That is not a claim that every record
was seven weeks wrong. Some already contained correct 2027 dates.

Before this batch, the comparison report covered 78 of 197 listings explicitly;
71 approved-source listings awaited reviewed batches and 48 lacked an approved
comparison source. These are historical coverage categories, not missing-show
counts. The next report must recompute against 208 records.

Next prioritize Florida's rendered official FUN calendar, remaining California
promoter calendars, then the source coverage queue across other states. The
rendered FUN calendar needs browser review; readable HTML did not expose events.
The discovery run produced no individual-show detail rows: its successful job
status must not be mistaken for a complete inventory of new shows.

## Reviewer scheduler

Daily reviewer definition: `TODO.md`, `r-coin-listing-refresh`, 15:30 UTC, owned
by the existing Pulse supervisor. **First scheduled execution pending evidence.**
Do not replace this state with success until actual runtime and publication/hold
receipts exist. See `docs/listing-refresh-operations.md`.
