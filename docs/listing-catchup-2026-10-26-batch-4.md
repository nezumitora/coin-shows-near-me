# Official-source catch-up, batch 4 — October 26, 2026 UTC

## Scope and publication gate

Owner requested urgent verified show additions and show-information updates.
This separate interactive batch changes Virginia, California and Idaho records;
the active scheduled reviewer's Nevada correction is not duplicated here.

- **3 new show series, 3 changed existing records, 225 canonical listings.**
- **15 newly recorded dated occurrence-days**, not 15 new shows. Two elapsed
  Vienna October dates are removed from its future list, not declared cancelled.
- Preserve the Southern Idaho canonical show ID and alias; its retired Garden
  City city URL gets a one-hop noindex/canonical redirect to Nampa.
- This document is evidence for a proposed batch, **not a deployment receipt**.
  Require this PR's merge SHA, successful Pages run and public content readback.

## Individually verified evidence

| Record | Change | Official source / exact association |
|---|---|---|
| Richmond Fall Coin & Currency Show, new | November 5–7, 2026, ACCA Shriners Center, 1712 Bellevue Avenue, Richmond, VA 23227 | https://vnaonline.org/2026-calendar/ and its directly linked organizer https://www.richmondcoinclub.com/ announce this exact future edition. Public hours Thursday/Friday 10–6, Saturday 10–5. Not VNA's Fredericksburg convention. |
| Shenandoah Valley Coin & Stamp Show, new | December 4–5, 2026, Weyers Cave Community Center, 682 Weyers Cave Road, Weyers Cave, VA 24486 | Standalone future date-bearing block at https://vnaonline.org/2026-calendar/ explicitly ties dates and venue. Friday noon–5, Saturday 9–5. No Facebook access required or performed. |
| Winchester Coin Club Show, new | December 18, 2026, Friendship Fire Company Bingo Hall, 627 N Pleasant Valley Road, Winchester, VA 22601 | Standalone date-bearing VNA block at https://vnaonline.org/2026-calendar/ gives Friday 9–4 public hours and this exact venue. |
| Sacramento Coin Show | Add February 26–27 and May 30, 2027; retain November 6–7 and December 13, 2026 | http://sacramentocoinshow.com/ explicitly lists these dates at Lions Gate Hotel, 3410 Westover Street, McClellan. Two-day shows Friday 10–5/Saturday 10–4; Sunday shows 10–4. |
| Southern Idaho Coin Club Show | Replace TBD/historical Garden City hotel with May 21–22, 2027, Nampa Civic Center, 311 3rd Street S, Nampa | https://pnna.org/calendar2.html, reached from the official PNNA Southern Idaho report/calendar links, explicitly announces the 70th annual show and future venue. Friday noon–7, Saturday 10–5. Postal code unestablished, left absent. Do not reuse the 2026 Riverside Hotel venue. |
| Vienna Quarterly Coin & Stamp Show | Current next show November 7–8, 2026; add January 30–31, 2027; Vienna Community Center, 120 Cherry St SE, Vienna, VA 22180 | Current organizer https://viennacoinshow.com/, directly linked by VNA, supplies the next-show announcement, calendar and venue. This reviewed official domain is added to the approved-source registry. Prefer organizer evidence over VNA's stale October label. No repair of VNA's literal January year 3037 and no unconfirmed April import. |

All verification is edition-specific as of October 26. No recurrence-generated
dates, invented ZIP codes, new contacts, customer records or private cache bodies.

## Files and reference pattern

- `_data/shows.yml`: extend existing series rather than one record per occurrence;
  new records follow the batch-3 source/date/address evidence pattern.
- `_data/city_redirects.yml`: exact one-hop successor for the same relocated series.
- `_scrapers/external-sources.yml`: add the three VNA show IDs to existing mapping.
- `_scrapers/listing-freshness-phase-2.yml`: synchronize only that mapping's covered
  IDs; all inactive scheduling/network/publication controls remain unchanged.
- `_scrapers/approved-show-sources.yml`: add the directly linked reviewed Vienna
  organizer domain; no shared-host blanket approval or third-party authority.
- Generated city/show/state pages and `shows.json`: existing generator only.
- Existing snapshot/redirect tests: reflect 225 records, newly confirmed Idaho
  dates and the exact Garden City successor, without weakening assertions.

## Holds and remaining coverage

Norfolk and Salem's future dates appear under earlier VNA edition blocks; future
venues remain unconfirmed. Vienna April 2027 is not confirmed by the current
organizer page. Keep these held. Also retain prior FUN/Atlanta/NCNA conflicts,
unavailable calendars, Long Beach public-day splits, the South Dakota September
date conflict, Lehigh County/Valley identity and KVCC venue/date associations.

This batch does not establish nationwide completeness or a missing-show count.
No-source coverage is a separate discovery queue, not evidence that every such
record is wrong. The previous September 4 to October 26 maintenance gap was about
seven weeks, not the age/error of every individual listing.

## Verification

Existing Ruby syntax and all configured Ruby/JavaScript suites; data validator;
generator currentness and whitespace; production Jekyll build in the existing
container image. Initial network-disabled build could not download the configured
remote theme; rerun the normal build with its existing network dependency enabled.
Deployment, canonical redirects, sitemap and public feed remain separate gates.
