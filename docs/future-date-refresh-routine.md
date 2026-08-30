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
- For a credible recurring series, keep the canonical page indexable, preserve date history, and label it as a past event awaiting the next confirmed date.
- Do not emit scheduled Event schema for a date that has already passed or for a `TBD` listing.
- Redirect only a duplicate, renamed page, or other URL with a clear equivalent destination; never redirect unrelated expired events to the homepage.
- For a permanently removed one-time event with no useful history or successor, remove it from internal links and the sitemap and return a genuine 404 or 410.

## Report-only checks

- Run `ruby _scripts/show-update-report.rb` before and after data updates.
- Run `ruby _scripts/external-source-compare.rb` for configured high-value sources.
- Review `tmp/show-url-checks.csv` for source failures and stale/blocked domains.
- Keep third-party directory work report-only unless an official or independent source verifies the date.

## Listing freshness MVP

The first automation phase converts canonical show metadata and the existing
approved-source comparison CSV into a structured review queue. It performs no
network requests and has no code path that edits `_data/shows.yml`.

Run it after an approved-source comparison:

```bash
LISTING_FRESHNESS_AS_OF=2026-08-30 \
  ruby _scripts/listing-freshness-report.rb
```

It writes five local artifacts under `tmp/`:

- `listing-freshness-report.md` — readable coverage, risk, pilot, cadence, and gap summary.
- `listing-review-queue.csv` — one policy classification per canonical listing.
- `listing-proposed-facts.csv` — source facts compared with current values, including confidence and conflict reasons.
- `listing-pilot-quality.csv` — expected versus actual outcomes for the manually reviewed source pilot.
- `listing-duplicate-candidates.csv` — possible duplicates for review, never automatic merges.

The baseline cadence is every 2-3 days for events within 30 days, weekly for
events 31-90 days away, and monthly beyond 90 days. The 21-day, 7-day, and
2-day milestones can move a review earlier. Past listings enter a weekly stale
queue. TBD and partial-date listings enter a monthly unconfirmed queue; the
proposed fortnightly in-season rule remains inactive until season metadata is
defined.

Review the pilot-quality CSV first, then source conflicts, then the highest-risk
due listings. A failed fetch is source-health evidence, not cancellation
evidence. A third-party source is always lead-only. Every output row sets
`automatic_action` to `none`.

The current two-source pilot confirms only that two unchanged official-source
cases are classified correctly. Before expanding the pilot, adding a workflow,
or preparing any data change, the owner must review the sample report and
approve the next bounded phase. A cron, listing edit, merge, deletion,
publication, outreach message, form submission, or CRM write requires separate
approval.

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
