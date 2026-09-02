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

The report enforces a fail-closed local output sandbox. All five artifacts must
be direct files under `tmp/`; path escapes, nested output directories, duplicate
destinations, input-file collisions, non-regular files, and symbolic links are
rejected. Each artifact is written atomically with owner-only permissions so a
failed run cannot replace a complete report with partial output. The entire
`tmp/` directory is also excluded from site builds, preventing local review
artifacts from entering published pages.

Every comparison row must also match the current canonical show ID, name, and
date, and each source/show pair must be unique. If listing data changed after
the comparison was generated, the report stops and requires a fresh comparison
instead of presenting stale evidence as current.

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

The live pilot confirms only that two unchanged official-source cases are
classified correctly. Two synthetic hardening fixtures then exercise one
confirmed date-change outcome and one 503 source-failure outcome. They use
reserved `.invalid` URLs and synthetic show IDs, never enter the canonical risk
queue, and always retain `automatic_action: none`.

The report also groups review rows by cause. Date differences distinguish a
single different candidate, a current value the matcher failed to associate,
multi-date page ambiguity, and a TBD listing with candidates. Availability
reviews distinguish redirects, blocked access, missing paths, server errors,
and transport errors. Identity/parser conflicts distinguish pages with
unassociated dates from pages with no extracted dates.

Before expanding the live pilot, adding a workflow, or preparing any data
change, the owner must review the sample report and approve the next bounded
phase. A cron, listing edit, merge, deletion, publication, outreach message,
form submission, or CRM write requires separate approval.

## Phase 2 bounded source review

The owner-approved Phase 2 implementation now uses the merged and security-
hardened Phase 1 foundation. It selects 12 existing official source groups
covering 23 canonical listings through
`_scrapers/listing-freshness-phase-2.yml`. Source URLs and types remain in the
existing approved registry; the profile records authority, coverage, source
tier, generic check method, page shape, inactive cadence, request constraints,
redirect handling, and fail-closed behavior.

Run the bounded comparison and package locally:

```bash
SOURCE_COMPARISON_ALLOW_NETWORK=1 \
  LISTING_FRESHNESS_PROFILE_PATH=_scrapers/listing-freshness-phase-2.yml \
  LISTING_FRESHNESS_AS_OF=2026-08-31 \
  REQUEST_DELAY_SECONDS=1.0 \
  ruby _scripts/external-source-compare.rb

LISTING_FRESHNESS_AS_OF=2026-08-31 \
  ruby _scripts/listing-freshness-phase-2-report.rb
```

The package writes five ignored artifacts under `tmp/`: a Markdown review,
full current-versus-proposed facts, live/controlled quality measurements, the
prioritized selected-listing queue, and duplicate evidence. Live official
source observations are labeled separately from six synthetic safety cases:
date change, redirect, duplicate, partial date, explicit cancellation evidence,
and source failure.

Network access is off by default when a Phase 2 profile is selected and must be
enabled explicitly for a bounded manual profile run. The comparison rejects
non-finite or negative delays, enforces the profile's one-second minimum, limits
each response body to 2 MiB, makes at most one request per exact approved source
path, and follows no redirects. HTTPS registry URLs cannot be downgraded to
HTTP. Extracted candidate years are limited to one year before through five
years after the classification year, so implausible source text cannot become a
proposed date.

The comparison and Phase 2 package use the same fail-closed direct-`tmp/`
output sandbox as Phase 1: destinations must be unique regular files, symbolic
links and input collisions are rejected, and writes are atomic with owner-only
permissions. Imported comparison rows must retain the canonical show ID, name,
and date, and each source/show pair must be unique. CSV cells beginning with a
spreadsheet formula marker are neutralized. Equal-distance name matches on
multi-event pages are treated as ambiguous rather than selected by input order.

`_scrapers/listing-freshness-phase-2-schedule.yml` is design-only. It has no
workflow file, no cron, no manual dispatch, and `enabled: false`. No existing
workflow consumes it. The Phase 2 report validates those conditions before it
writes a package, including that every publication control remains exactly
`false`.

The first live run on 2026-08-31 selected 12 source groups and 23 rows. Five
rows matched current values, 18 stayed in human review, five known-current
baselines were missed by the generic matcher, no false change proposal was
created, and all six controlled safety cases passed. The readiness gate is
therefore false.

### Phase 2B report-only hardening

The approved Phase 2B pass keeps registry URLs authoritative while allowing an
exact same-host `request_url` in the profile. It validates every override and
records registry and requested URLs separately in the comparison CSV. A source
can use more than one exact page, but each source/path is requested at most once
per run and redirects are never followed.

Per-listing rules remain narrow:

- Literal title aliases can account for official wording without fuzzy names.
- An explicit calendar year can validate yearless dates only on the reviewed
  source.
- A source-specific name/date distance is capped at 320 characters; the current
  profile uses 200 only for the observed North Metro layout and leaves the
  global 160-character threshold unchanged.
- Explicit nth-weekday rules require an exact per-listing page, literal source
  wording, and a canonical date that already satisfies the rule. They do not
  generate or propose dates.
- Whole-page exact-date matching requires an exact per-listing request path and
  a source profile marked as a single-event page.
- A range written as two complete dated endpoints can match only when both
  endpoints and years exactly agree with the canonical range.

The Phase 2B rerun observed 15 current values and retained eight rows for human
review. Eleven of 12 live baselines matched, reducing known-current false
negatives from five to one. All six controlled cases still passed, with zero
false proposals and zero automatic actions. The remaining CK Shows baseline is
fail-closed because its multi-event layout does not preserve a reliable
name/date association in stripped text. Draft listing updates and schedule
activation remain premature, and the readiness gate remains false.

The post-hardening run on 2026-09-02 reproduced the Phase 2B result: all 13
approved paths returned `200`, 15 current values were observed, eight rows
remained in human review, 11 of 12 baselines matched, all six controlled cases
passed, and automatic actions remained zero. An implausible `3037` value found
in source prose was discarded by the candidate-year bound. The readiness gate
remained false.

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
