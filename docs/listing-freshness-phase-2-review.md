# Listing freshness Phase 2 local review

## Decision summary

Phase 2 and its Phase 2B hardening pass are implemented locally as a review-only
stack on draft PR #84. The result is safer and more accurate, but it is still
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

The Phase 2B rerun improved the same fixed batch without changing a listing:

| Measurement | First run | Phase 2B rerun |
|---|---:|---:|
| Current values observed | 5 | 15 |
| Rows retained for human review | 18 | 8 |
| Live baselines matching expectations | 7 of 12 | 11 of 12 |
| Known-current false negatives | 5 | 1 |
| False change proposals | 0 | 0 |
| Controlled safety outcomes | 6 of 6 | 6 of 6 |
| Automatic actions | 0 | 0 |

All 13 approved source paths returned `200`. The extra path is the second exact
BuxMont show page. The rerun used one request per exact source/path, at least a
one-second delay, and followed no redirects.

## Selected official sources

| Source key | Authority | First run | Phase 2B result |
|---|---|---|---|
| `pacific-expos-north-county` | Official organizer date page | Current value observed | Current value observed |
| `rocky-mountain-expos` | Official promoter page | Current value observed | Current value observed |
| `vna-calendar` | Official state association calendar | Redirect recorded and stopped | Reviewed same-host target returned `200`; representative baseline matched |
| `numismatists-of-wisconsin-calendar` | Official regional association calendar | Name/date association gap | All three current values observed with literal aliases |
| `cona-events` | Official association event source | Redirect recorded and stopped | Reviewed same-host target returned `200`; split date-range baseline matched |
| `buxmont-coin-shows` | Official promoter source | Source-path/parser gap | Both exact per-show pages matched explicit recurring rules |
| `antique-coins-mn` | Official organizer page | Parser/content gap | North Metro matched; South St. Paul remains in review |
| `georgia-numismatic-association` | Official association show page | Name/date association gap | Current value observed with a literal source alias |
| `ck-shows` | Official promoter source | Source-path/parser gap | Exact schedule path returned `200`; structural name/date association remains unresolved |
| `central-states-numismatic-society` | Official association convention page | Date-context conflict | Expected conflict retained for review |
| `long-beach-expo` | Official show site | Redirect recorded and stopped | Reviewed same-host target returned `200`; exact current value observed |
| `michigan-state-numismatic-society-events` | Official association local-show calendar | Three current values observed; one stale identity gap | Result unchanged |

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

The Phase 2B comparison uses `request_url` to distinguish the unchanged registry
URL from an approved exact same-host review target. Its full facts CSV also
records whether evidence came from an exact date or an explicit recurring rule.
The before/after package for the hardening pass is written with the
`listing-freshness-phase-2b-before` and `listing-freshness-phase-2b-after`
prefixes under `tmp/`.

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

## Phase 2B redirect and parser decision

The three redirect targets were accepted only as exact same-host review paths
after a no-follow check recorded the redirect and a separate target request
returned `200`. The authoritative registry URLs were not changed.

Parser hardening is limited to literal per-listing aliases, explicit calendar
year context, exact split range endpoints, explicit nth-weekday statements on
exact per-show pages, one bounded 200-character North Metro association, and
whole-page exact-date matching only for an exact single-event page. The global
160-character name/date threshold remains unchanged.

CK Shows remains deliberately unresolved. Its official schedule exposes the
target title and yearless date in a multi-event layout, but the stripped text
does not preserve a reliable structural association. Increasing the generic
distance or treating the whole multi-event page as one event would force a
match, so the row stays fail-closed.

## Next approval decision

Recommendation: keep the system **report-only**. Phase 2B reduced five
known-current false negatives to one without a false proposal, but eight live
rows still require human review and the readiness gate remains false. Do not
approve draft listing updates, schedule activation, merge, deployment, or
publication from this evidence.
