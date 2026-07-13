# Future date refresh routine

Goal: keep show dates fresh without guessing, copying a third-party directory, or publishing stale Event schema dates.

## Source order

1. Official show/promoter site.
2. Official club or numismatic association site.
3. Venue or convention-center event calendar.
4. Official organizer/club/venue Facebook page or event.
5. State/regional numismatic association calendar.
6. Credible secondary sources only as leads or corroboration.

## Safe publish rules

- Publish a date only when the source gives a year and the date is future as of the review date.
- For recurring rules, compute only near-term future dates when the official source clearly states the rule.
- Keep stable show URLs; log duplicate/imported/date-in-title records for later canonicalization instead of deleting them during a date refresh.
- Change expired or unconfirmed dates to `TBD` rather than guessing.
- Add `source_url`, `last_verified`, `upcoming_dates`, and `verification_notes` when a source confirms dates.

## Report-only checks

- Run `ruby _scripts/show-update-report.rb` before and after data updates.
- Run `ruby _scripts/external-source-compare.rb` for configured high-value sources.
- Review `tmp/show-url-checks.csv` for source failures and stale/blocked domains.
- Keep third-party directory work report-only unless an official or independent source verifies the date.

## Patterns confirmed on 2026-07-13

- Promoter pages with multiple shows work well as high-value sources: Pacific Expos, Rocky Mountain Expos, America’s Coin Shows, CK Shows, BuxMont, and Antique Coins MN.
- State/association calendars are useful for clusters: VNA, Numismatists of Wisconsin, MSNS/Michigan Coin Club, CONA, and GNA.
- Some official sites publish long-range future dates: GNA to 2029, Long Beach to 2027, Denver to 2027, North County Monthly to 2027.
- Facebook-only, blocked, expired, or no-year pages should stay `TBD` or be logged for review.

## Follow-up buckets

- Blank-source imported records: find official sources before publishing dates.
- Duplicate records: map canonical listing vs imported one before renaming/deleting.
- Secondary-only leads: Waco, Cowtown, Cheyenne, and Fremont need official confirmation before publishing expanded dates.
- Stale/compromised domains: log and avoid using them as confirmation until manually reviewed.
