# Listing refresh status

## Last published batch

- Published UTC: **2026-10-26T04:17:21Z** (October 25 Pacific).
- PR: #98.
- Merge: `b4d20eb1aa30c7d555f32fbd0bbb40ae5471ae6d`.
- Successful Pages run: `40268201028`.
- Public feed readback: **216 canonical shows** (previously 208).
- Added: **8 Wisconsin series**; updated: **3 existing records**, including
  Raleigh's 2027 dates/venue and Wisconsin corrections.
- Official evidence: `docs/listing-catchup-2026-10-26-batch-2.md`.
- First batch PR #96 added 11 series and updated 6 existing records; Pages
  `40266952526` succeeded at `2026-10-26T04:03:02Z`. Its evidence remains in
  `docs/listing-catchup-2026-10-26.md`.

## Next reviewed batch (publication not yet verified)

Third interactive batch: 7 new series, 21 changed existing records, 1 duplicate
merged with its URL retained as an alias; proposed directory total **222**.
**35 added dated occurrence-days are not 35 new shows.** Evidence:
`docs/listing-catchup-2026-10-26-batch-3.md`. Publication requires its own merged
SHA, successful Pages run and public readback, not the earlier receipts above.

## Scope still outstanding

The previous publication was September 4: approximately seven weeks of elapsed
listing-maintenance lag before this batch. That is not a claim that every record
was seven weeks wrong. Some already contained correct 2027 dates.

Fresh comparison `2a8e7e9e-0e9b-4d60-b172-31790a558226` ran October 26
05:15:32–05:16:41 UTC against 216 records: 48 exact source requests, 78 explicit
listing mappings, 90 approved-source records outside those mappings, 48 lacking
an approved comparison source. These are coverage categories, not missing-show
counts. Batch 3 expands explicit mappings to 115 of 222 proposed records.
The inactive Phase 2 profile's covered IDs stay synchronized, but its schedule,
network default, request limits and all publication-disable controls are unchanged.

Rendered FUN calendar and a broader official-source review are now reconciled in
`docs/listing-source-review-ledger.md`, with conflicts, unavailable sources and the
next rotation preserved. Empty discovery-detail artifacts and successful report
jobs are still not evidence of complete new-show discovery. Do not label all
listings current while that ledger has unresolved coverage.

## Reviewer scheduler

Daily reviewer definition: `TODO.md`, `r-coin-listing-refresh`, 15:30 UTC, owned
by the existing Pulse supervisor. **First scheduled execution pending evidence.**
Do not replace this state with success until actual runtime and publication/hold
receipts exist. See `docs/listing-refresh-operations.md`.

Workflow registration merged in PR #97 (`84e6bcc6cf3f6aeacbda355f63634cdfb9de49a7`);
the canonical service mirror was safely synchronized through the audited recovery
helper. Schedule parser confirms daily 15:30 UTC. A never-run routine is already
due (`routine-schedule-helper.sh` treats last-run epoch 0 as due); do not explain
an absent receipt solely as waiting for 15:30. No second scheduler was installed.

The existing supervisor's environment lacked the installed native GitHub CLI
directory; repeated shim failures were observed. Added that directory after the
managed wrappers (keeping wrapper policy in place), validated the plist and
reloaded the existing service only after observing an idle window. Its loaded
environment now contains the native path and the same shim resolves CLI 2.92.0.
This is an environment repair, **not proof of routine completion**. A bounded
wrapper dry-run reached cache prewarming but timed out; its result is not a
successful scheduled run. Keep the missing routine receipt as an open gate.
