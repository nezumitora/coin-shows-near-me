# Official-source catch-up, batch 3 — October 26, 2026 UTC

## Scope and delivery

Owner requested continued official-calendar review, verified publication and an
operating workflow check. This batch contains **7 new series, 21 changed existing
records, and 1 duplicate merged through an alias**, giving **222 canonical shows**.
There are **35 newly recorded dated occurrence-days**, not 35 new shows. Some
changes only refresh stale `next_date` labels for dates already in the public feed.

Do not call this nationwide completeness. See the coverage/hold ledger below.
Publication requires the merged SHA, successful Pages run and public readback;
passing these local checks alone is not a deployment receipt.

## Newly added series

| Series | Explicit dates | Official evidence |
|---|---|---|
| Wasatch Winter | Jan 29–30, 2027, Sandy | http://www.utahcoinshows.com/ |
| Northern Utah | Apr 9–10, 2027, Ogden | http://www.utahcoinshows.com/ |
| Salt Lake Coin & Token | Jun 11–12, 2027, Sandy | http://www.utahcoinshows.com/ |
| Colorado Money Show | Jan 29–30 and Aug 6–7, 2027, Golden | https://fortcollinscoinclub.com/upcoming-shows/ |
| Greater Worcester | Nov 8 and Dec 13, 2026, Auburn | https://ebwpromotions.com/events/ and its directly linked show page |
| Salem Coin & Stamp | Dec 19–20, 2026, Rickreall, Oregon | https://www.pnna.org/wp/events/event-calendar/ |
| Olympia Coin Club | Jan 30, 2027, Lacey | https://www.pnna.org/wp/events/event-calendar/ |

Known venues are recorded; missing street/ZIP components are not invented.
Worcester's venue is supported by
https://ebwpromotions.com/greater-worcester-coin-show/ .

## Significant existing-record corrections

- FUN calendar event-specific links: Gold Coast and Central Florida First Sunday
  gain Dec 6, 2026 and Jan 3, 2027; Coinacopia gains Dec 5, 2026. Fort Lauderdale
  Nov 15/Dec 20 and Palm Beach Nov 22/Dec 27 were already present. Preserve older
  venue evidence separately from this date review. Source:
  http://www.funtopics.com/calendar.html .
- http://www.funtopics.com/summer-fun.html confirms Jul 15–17, 2027. Its 2028/2029
  announcements are tentative: removed those six days from confirmed dates.
- https://www.csns.org/convention advertises public bourse Apr 22–24, 2027;
  Apr 21 is a wider convention date, not confirmed public bourse admission.
- https://www.wilmingtoncoinclub.org/wilmington-coin-show announces Jan 14–16,
  2027, New Castle, Nur Shrine Temple.
- https://ebwpromotions.com/events/ and directly linked show pages confirm Nashua
  Nov 15/Dec 20 in Hollis, correct its street number to 19 S. Depot St, and name
  Devens Common Center rather than the old venue label. Devens future dates were
  already present; no location move is inferred from the name correction.
- https://www.pnna.org/wp/events/spring/ and
  https://www.pnna.org/wp/events/next-pnna-coin-show/ announce Apr 2–4, 2027,
  Portland Holiday Inn Columbia Riverfront. Corrected PNNA's state from WA to OR
  without changing its canonical show URL. The retired `/cities/wa/` placeholder
  redirects to Portland. Do not carry forward 2026 public/dealer hours.
- PNNA calendar confirms Greater Tacoma Nov 28, 2026 and Wilsonville Dec 13, 2026.
- Fort Collins official page explicitly prints Dec 5–6, **2027**, Lincoln Center,
  Fort Collins. Preserve its printed year rather than guessing 2026.
- Albuquerque's duplicate records had the identical fall source, dates and
  organizer. Retain the detailed Great Southwest canonical record; old generic
  show URL redirects. Official fall and
  https://albuquerquecoinclub.com/spring-coin-show/ support Nov 13–15, 2026 and
  Apr 16–18, 2027 at Marriott Pyramid North. Conflicting spring vendor-setup
  wording does not override the advertised public range.
- BuxMont flyer, Antique Coins, Cleveland and ILNA rechecks support the existing
  remaining 2026 dates. Advanced only reviewed stale display labels; no recurrence
  rollover or 2027 monthly dates were invented.

## Review coverage and holds

Fresh full-registry comparison `2a8e7e9e-0e9b-4d60-b172-31790a558226` ran
05:15:32–05:16:41 UTC, making 48 exact source requests against the then-216-record
directory. Parser name/date misses are review flags, not missing-show evidence.
The expanded report registry explicitly maps **115 of 222** proposed records;
this is comparison coverage, not a count of current/correct listings. Raw cache
and fetched bodies remain private/uncommitted. Detailed review progress and next
sources are in `docs/listing-source-review-ledger.md`.

Keep ambiguous announcements held without blocking verified unrelated updates:
Atlanta December text/flyer conflict; NCNA detailed 2027 schedule conflict; FUN
Fort Myers/Silver Sands grid vs event-detail dates; South Brevard/Seminole missing
public venue evidence; Boeing/Kent identity; PAN future-year venue; token-society
meeting classification. Canadian and stamp-only events are outside this batch.

## Verification

Regenerate pages/feed, run the configured Ruby/JS suites, validator, generated
currentness/whitespace and existing production Jekyll build. Dataset snapshot
expectations reflect new records, explicit dates and duplicate removal; checks
are retained. Deployment/public readback remains a separate gate.
