# Listing refresh status

## Latest routine attempt — October 26, 2026 evening UTC

Started **2026-10-26T21:28:21Z**. No overlapping listing PR or tracked edits in
the recent listing worktrees at intake; badge PR #100 is unrelated. Linked
worktree based on remote main `e2c61cbce246dae6a8fbd81cfe43dc19823180d9`.

| Latest terminal workflow | Run | UTC start / completion | Result |
|---|---|---|---|
| Show Update Report | 40347873502 | Oct 26 15:17:31 / 15:20:49 | success |
| External Source Comparison | 40355409768 | Oct 26 16:03:34 / 16:05:15 | success |
| Third-Party Discovery | 40357588318 | Oct 26 16:16:54 / 16:25:03 | success |

Downloaded and inspected all three artifacts. Reports are about 5–6 hours old,
not stale (>48h). Comparison `527cd114-7069-434a-a8a4-8d07a82a1679` covered
225 records: 118 explicitly mapped, 59 approved-source records awaiting reviewed
comparison, 48 lacking an approved source; 55 exact source requests. These are
coverage categories, not missing-show counts. Discovery detail CSV remains
header-only (**zero reviewed detail rows**); discovery remains incomplete.

Recovered last show publication PR #102 / Pages 40281994373, approximately
14h39m old at intake. Dealer-only PR #106 and receipt deployment 40403777106 do
not count as a newer show batch. Public feed still contains 225 records and the
prior Whitman dates. Seven-day no-publication escalation is not due.

Reviewed next queued source: Whitman, Maryland. **0 new series, 1 changed existing
record, 0 added occurrence-days**. Kept Nov 12–14, 2026; replaced broken official
source link, added explicitly supported street/ZIP and corrected unsupported
three-times-yearly frequency to Recurring. Preserved ID, canonical route and alias.
No Nov 11 dealer-only date or future Baltimore date added. Source page scan flagged
an emoji Unicode-escape pattern; extracted event facts only, no embedded instructions.

One separate official DC show candidate remains held for unsupported DC routing/
state validation; exact source, dates, venue and implementation blocker are in
`docs/listing-source-review-ledger.md`. This is not a nationwide missing-show total.
Next rotation: Pennsylvania Lehigh County/Valley identity, then West Virginia KVCC
date/venue blocks and South Dakota Midwest spring/fall identity; preserve PNNA's
three-calendar rotation and existing identity/tentative-date holds.

Batch publication/checks/readback pending its own receipt; no publication claimed yet.

## Last published batch

- Published UTC: **2026-10-26T06:49:40Z**; PR **#102**, interactive batch 4.
- Merge: `5ed8c21f1b6ec212e024e718047c3289aa0dac5a`.
- Successful exact-SHA Pages run: **40281994373**.
- Public feed readback: **225 canonical listings**; all three new Virginia IDs,
  Sacramento's explicit 2027 additions, Vienna's November/January dates and
  Southern Idaho's Nampa venue and May 2027 dates verified.
- Added **3 series**, changed **3 existing records**, added **15 dated
  occurrence-days**, not 15 new shows. Evidence:
  `docs/listing-catchup-2026-10-26-batch-4.md`.
- Independent rendered browser checks passed for all three new Virginia pages,
  Southern Idaho and Vienna; dates, venues, HTTP 200 and canonical routes verified.
  Garden City redirects to Nampa with legacy noindex/canonical; all three new
  Virginia routes appear once in the public sitemap. No observed console/page errors.
- Existing Ruby/JavaScript suites, validator, generator currentness, whitespace,
  local production Jekyll container build and PR CI passed. The first local build
  deliberately disabled networking and could not obtain the configured remote
  theme; the normal network-enabled build then passed without code/config changes.
- Catch-up totals across batches 1–4: **29 added series**, one duplicate merged
  with its URL preserved, **197 → 225 canonical listings**. Existing-record
  change counts are per batch and must not be summed as distinct shows.

## First automatic publication

- Published UTC: **2026-10-26T06:40:56Z**; PR **#101**.
- Merge: `79f0892b100944aa9a9a82c02301c6a116bb7777`.
- Successful exact-SHA production Jekyll/Pages run: **40281151764**.
- Result: **published**. New series **0**; changed existing records **1**;
  added occurrence-days **0**. Vegas National Oct 29–31, 2026 retained; unsupported
  May/December frequency corrected to Recurring; only this record reverified.
- Public readback completed before **2026-10-26T06:43:26Z**: entire `shows.json`
  equals the reviewed generated 222-record feed. Vegas National HTML contains
  the confirmed dates, October 26 verification date, Recurring label and correct
  canonical route; sitemap includes its route. No deployment/content mismatch.
- Local checks: 27 Ruby syntax checks, all 11 Ruby suites, all 16 JavaScript tests,
  validator, regenerated-currentness and whitespace passed. Host required UTF-8
  selection; no test expectations changed. Local Jekyll unavailable; existing
  production Jekyll build completed successfully in the exact-SHA Pages run.

## Recovered publication: batch 3

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

Started **2026-10-26T06:17:23Z**; execution and readback completed by
**2026-10-26T06:43:26Z**. Recovered batch 3's completed publication rather than
republishing it. No open PRs at intake; linked worktree started at remote main.
Last published listing update was approximately 2.5 minutes old at completion,
based on PR #101's deployment, not a spot-price rebuild. Seven-day escalation is
not due. No overlapping listing PR appeared; concurrent badge PR #100 is unrelated.

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

Published routine batch: **0 new series, 1 changed existing record, 0 added occurrence-days**.
Reviewed Nevada CK Shows homepage and linked schedule for the imminent Oct 29–31
Vegas National; dates/venue already correct. Corrected unsupported May/December
frequency wording to Recurring and refreshed only this record's verification.
The linked winter visitor page returns 404; future 2027 dates remain unverified.
Publication verified through PR #101, Pages 40281151764 and exact public readback
above. Subsequent interactive batch 4 completed the supported Virginia additions,
Sacramento dates and Southern Idaho move. Remaining source rotation and precise
holds are in `docs/listing-source-review-ledger.md`; do not restart completed work.

## Scope still outstanding

The pre-catch-up publication was September 4: approximately seven weeks of elapsed
listing-maintenance lag before the October catch-up. That is not a claim that every record
was seven weeks wrong. Some already contained correct 2027 dates.

Fresh comparison `2a8e7e9e-0e9b-4d60-b172-31790a558226` ran October 26
05:15:32–05:16:41 UTC against 216 records: 48 exact source requests, 78 explicit
listing mappings, 90 approved-source records outside those mappings, 48 lacking
an approved comparison source. These are coverage categories, not missing-show
counts. Published batch 3 expanded explicit mappings to 115 of 222 records;
batch 4's checked registry now maps **118 of 225 records**:
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
by the existing Pulse supervisor. **First due-run dispatch and successful terminal
execution are verified.** Scheduler state recorded an attempt at
**2026-10-26T06:14:41Z**, Pulse lifecycle recorded runtime launch at **06:15:02Z**,
and routine state recorded **success / last_run 2026-10-26T06:50:32Z**. This
never-run catch-up invocation produced PR #101 and its verified public deployment;
it was not a manually triggered replacement job or merely a reporting artifact.
It proves the due-run publication path, not future reliability or a separate
15:30 timer firing. Host availability, authentication, model limits and merge gates
remain operational dependencies. See `docs/listing-refresh-operations.md`.

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
The environment repair alone was not proof of routine completion. A bounded
wrapper dry-run timed out during cache prewarming; that is not a successful run.
The later actual Pulse dispatch, successful terminal state and PR #101 deployment
above close the first-run evidence gate. No second scheduler was installed.
