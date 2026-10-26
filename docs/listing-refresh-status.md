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

## Next reviewed batch (publication not yet verified)

Second interactive batch, October 26 UTC: eight missing Wisconsin show-series
records, Raleigh's announced June 17–19, 2027 date and convention-center move,
Chippewa Valley's upcoming-date cleanup, and Milwaukee's frequency-label fix.
Proposed directory total: 216. Official evidence and occurrence distinctions:
`docs/listing-catchup-2026-10-26-batch-2.md`. Keep the last-published receipt above
until a merged SHA, successful Pages run and public readback establish deployment.

## Scope still outstanding

The previous publication was September 4: approximately seven weeks of elapsed
listing-maintenance lag before this batch. That is not a claim that every record
was seven weeks wrong. Some already contained correct 2027 dates.

Before this batch, the comparison report covered 78 of 197 listings explicitly;
71 approved-source listings awaited reviewed batches and 48 lacked an approved
comparison source. These are historical coverage categories, not missing-show
counts. Recompute against the actual published directory (208 after the first
batch; 216 if the second batch's publication is verified).

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

Workflow registration merged in PR #97 (`84e6bcc6cf3f6aeacbda355f63634cdfb9de49a7`);
the canonical service mirror was safely synchronized through the audited recovery
helper. Schedule parser confirms daily 15:30 UTC, next boundary October 26 at
15:30 UTC. No matching execution receipt was found in the existing local routine
state during this interactive check. No second scheduler was installed.
