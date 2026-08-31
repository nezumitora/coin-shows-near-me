# Listing freshness Phase 2 local review

## Decision summary

Phase 2 is implemented locally as a review-only stack on draft PR #84. It is
not ready to prepare draft listing updates and it does not authorize a schedule.

The first live bounded run produced:

- 12 official promoter, organizer, club, or association source groups.
- 23 covered canonical listings.
- 5 rows where the generic matcher observed the current value.
- 18 rows retained for human review.
- 12 manually defined live quality baselines, covering every selected source.
- 7 baselines matched and 5 known-current baselines were missed.
- 0 false change proposals.
- 6 of 6 controlled safety outcomes passed.
- 0 automatic actions.
- 0 live listing edits, merges, deletions, cancellations, or publications.

This is a useful fail-closed result: the system avoids unsafe changes, but its
generic name/date association is not yet reliable enough for an approval-gated
draft-update phase.

## Selected official sources

| Source key | Authority | Covered listings | First-run result |
|---|---|---:|---|
| `pacific-expos-north-county` | Official organizer date page | 1 | Current value observed |
| `rocky-mountain-expos` | Official promoter page | 1 | Current value observed |
| `vna-calendar` | Official state association calendar | 3 | Redirect recorded and stopped |
| `numismatists-of-wisconsin-calendar` | Official regional association calendar | 3 | Name/date association gap |
| `cona-events` | Official association event source | 3 | Redirect recorded and stopped |
| `buxmont-coin-shows` | Official promoter source | 2 | Source-path/parser gap |
| `antique-coins-mn` | Official organizer page | 2 | Parser/content gap |
| `georgia-numismatic-association` | Official association show page | 1 | Name/date association gap |
| `ck-shows` | Official promoter source | 1 | Source-path/parser gap |
| `central-states-numismatic-society` | Official association convention page | 1 | Date-context conflict retained for review |
| `long-beach-expo` | Official show site | 1 | Redirect recorded and stopped |
| `michigan-state-numismatic-society-events` | Official association local-show calendar | 4 | Three current values observed; one stale identity gap |

Source URLs, source types, and covered canonical IDs are validated against
`_scrapers/external-sources.yml`. The Phase 2 profile does not introduce a
third-party directory as authority.

## Local review package

After the bounded comparison and report commands run, inspect:

- `tmp/listing-freshness-phase-2-draft.md`
- `tmp/listing-freshness-phase-2-draft.csv`
- `tmp/listing-freshness-phase-2-quality.csv`
- `tmp/listing-freshness-phase-2-review-queue.csv`
- `tmp/listing-freshness-phase-2-duplicates.csv`

The full facts CSV preserves the canonical current value, any source-observed
current value, raw candidate dates, fetch status/time, redirect target,
confidence, conflict reason, and human action. `proposed_value` remains blank
unless one exact change is supported. The first live run produced no exact
safe change proposal.

## Safety evidence

The controlled cases use synthetic IDs and reserved `.invalid` URLs. They prove
that a date difference remains review-only, a redirect is recorded but not
followed, a duplicate is not merged, a partial date is queued, explicit
cancellation evidence still requires review, and a failed source is not treated
as cancellation.

The inactive schedule design records the requested cadence tiers but contains
no workflow and no cron. Existing workflows are unchanged.

## Next approval decision

Recommended: approve one more **report-only** hardening pass limited to the
three observed redirect targets and the five known-current parser/source-path
misses. Do not approve draft listing updates or schedule activation yet.

That pass should be considered successful only if it reduces the five false
negatives without creating a false date-change or cancellation proposal. Any
source URL replacement must remain separately reviewable, and every listing
change must continue to require human approval.
