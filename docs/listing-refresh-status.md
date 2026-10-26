# Listing refresh status

## Last published batch

- Published UTC: **2026-10-26T06:11:38Z** (October 25 Pacific).
- PR: #99.
- Merge: `5bdd151f5dbfc03c86f00423621a6905166b93e8`.
- Successful Pages run: `40278289209`, exact merged SHA above.
- Routine public readback October 26, 06:22–06:25 UTC: **222 canonical shows**;
  all seven new IDs and dates present in `shows.json`, all seven canonical show
  routes present in the sitemap, Worcester HTML canonical and ISO date verified.
- Added: **7 series**; changed: **21 existing records**; merged: **1 duplicate**
  with URL retained as alias; added: **35 dated occurrence-days**, not 35 shows.
- Official evidence: `docs/listing-catchup-2026-10-26-batch-3.md`.
- Earlier PR #98 published 8 Wisconsin series and 3 existing-record corrections;
  Pages `40268201028` succeeded at `2026-10-26T04:17:21Z`.
- First batch PR #96 added 11 series and updated 6 existing records; Pages
  `40266952526` succeeded at `2026-10-26T04:03:02Z`. Its evidence remains in
  `docs/listing-catchup-2026-10-26.md`.

## Routine attempt: October 26, 2026 UTC

Started **2026-10-26T06:17:23Z**. Recovered batch 3's completed publication rather
than republishing it. No open PRs at intake; linked worktree starts at remote main.
Last published listing update was approximately 15 minutes old at 06:26 UTC,
not the later/earlier spot-price rebuild. Seven-day escalation is not due.

Latest terminal reporting runs and downloaded artifacts inspected:

| Workflow | Run | UTC start / completion | Result |
|---|---|---|---|
| Show Update Report | 40196689703 | Oct 25 13:14:17 / 13:17:03 | success |
| External Source Comparison | 40198661144 | Oct 25 13:40:10 / 13:41:36 | success |
| Third-Party Discovery | 40199666789 | Oct 25 13:53:14 / 14:00:54 | success |

All are under 48 hours old (about 16–17 hours), but their 197-record snapshots
predate batches 1–3. The comparison made 48 source requests and explicitly mapped
78 records; 71 approved-source records awaited comparison and 48 lacked an approved
source. These historical categories are not current missing-show counts.
Discovery has **zero detail rows** (header-only CSV): discovery remains incomplete.

Next small batch: **0 new series, 1 changed existing record, 0 added occurrence-days**.
Reviewed Nevada CK Shows homepage and linked schedule for the imminent Oct 29–31
Vegas National; dates/venue already correct. Corrected unsupported May/December
frequency wording to Recurring and refreshed only this record's verification.
The linked winter visitor page returns 404; future 2027 dates remain unverified.
Publication pending this batch's own PR/checks/Pages/readback receipt.

## Scope still outstanding

The previous publication was September 4: approximately seven weeks of elapsed
listing-maintenance lag before this batch. That is not a claim that every record
was seven weeks wrong. Some already contained correct 2027 dates.

Fresh comparison `2a8e7e9e-0e9b-4d60-b172-31790a558226` ran October 26
05:15:32–05:16:41 UTC against 216 records: 48 exact source requests, 78 explicit
listing mappings, 90 approved-source records outside those mappings, 48 lacking
an approved comparison source. These are coverage categories, not missing-show
counts. Published batch 3 expands explicit mappings to 115 of 222 records:
**107 records remain outside explicit mappings**; this is not 107 missing shows.
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
