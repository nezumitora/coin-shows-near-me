# Future coin show date review — 2026-07-13

Status: open
Priority: high

## Completed in this pass

- Removed expired `next_date` values from public upcoming displays by changing past dates to `TBD` in `_data/shows.yml` and `shows.json`.
- Kept Event schema from emitting stale past `startDate` values by removing those past specific dates from `next_date`.
- Verified and updated official future dates from organizer pages:
  - Pacific Expos LLC: Buena Park Coin Show — September 12-13, 2026 (`https://pacificexposllc.com/`).
  - Florida United Numismatists: FUN Convention — January 7-10, 2027 (`http://www.funtopics.com/`).
  - Florida United Numismatists: Summer FUN changed to `TBD` because the official site still only described the now-expired July 9-11, 2026 show and did not publish a later Summer FUN date.
- Follow-up broad refresh on 2026-07-13 verified and updated 53 existing show records from official/promoter/club/association pages, including multi-date source patterns for Pacific Expos, Long Beach Expo, Rocky Mountain Expos, GNA, MSNS, VNA, BuxMont, Antique Coins MN, Numismatists of Wisconsin, and other official sources.
- Captured repeatable scheduled-routine guidance in `docs/future-date-refresh-routine.md`.

## Review issues to resolve before publishing more dates

- Review listings changed from expired dates to `TBD` and add future dates only when confirmed by organizer, club, venue, or association pages.
- Review partial month-only dates still in the data, especially `July 2026`, because a month-only value may be current, stale, or incomplete depending on the actual day.
- Review duplicate/imported listings whose show name contains a date but whose `next_date` is `TBD`; do not convert the name text into a published date unless the date is independently verified.
- Review the Michigan State Numismatic Society listings. The official convention page lists November 20-22, 2026 in Warren and a future April 9-11, 2027 Spring Convention, but existing local listings have spring-specific or mismatched city/venue details. Update only after mapping the correct canonical listing.
- Review duplicate/imported records updated with official dates but still carrying awkward date-specific names, including Whitman Baltimore, GNA duplicate, Indiana State duplicate, national/Gettysburg duplicate, and Twin Cities/South St. Paul monthly duplicates.
- Review secondary-only leads that were intentionally not expanded in live data without official confirmation: Waco Coin Show, Cowtown Coin Show, Cheyenne Coin Expo, and Fremont Coin Club Show.
- Review source failures or stale/no-year official pages before publishing dates: TNA/Texas Numismatics, Raleigh Money Expo, IMEX, TSNS, PNNA Spring Convention, NCNA, Red River Valley, Nebraska Numismatic Association, Omaha Coin Club, Garden State, Watchung Hills, Rochester RNA, Oklahoma ONA, Kansas Numismatic Association, Louisville/LKSNA, Bay State, Maryland State Numismatic Association, and blocked Facebook-only sources.
- Review records where official data implies venue/city mismatch before making non-date edits, especially Nashua, Michigan local shows, PNNA, Numismatists of Wisconsin annual show, and Shreveport/Ark-La-Tex naming.

## Verification/report artifacts

- `tmp/show-update-report.md`
- `tmp/show-source-inventory.csv`
- `tmp/show-url-checks.csv`
- `tmp/external-source-comparison.md`
- `tmp/external-source-comparison.csv`

## Suggested routine

- Keep scheduled reports review-only.
- Respect robots.txt and crawl-delay rules.
- Use official show/organizer/club/venue pages as the source of truth.
- Use third-party directories only as lead discovery, not as auto-publish sources.
- Open review tasks for conflicts or missing official confirmation.
