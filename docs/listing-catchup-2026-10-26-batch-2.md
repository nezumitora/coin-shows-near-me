# Official-source catch-up: second batch, October 26, 2026 UTC

## Reviewed changes

Eight new Wisconsin show-series records, three changed existing records, and
216 total directory records after regeneration (previously 208).

The eight new series have nine explicitly dated occurrences because Madison
has two dates. Raleigh adds one three-day occurrence to an existing series.
These are not ten additional distinct shows; the eight new series are the
distinct-directory additions. Chippewa Valley's completed September occurrence
is removed from upcoming dates, while its already-recorded May date is retained.

## Primary evidence

Read-only official source checks on October 26, 2026 UTC:

- <http://www.numismatistsofwisconsin.com/showcalendar.html> explicitly publishes:
  - Wisconsin Coin Expos: February 21, 2027, Oshkosh Convention Center.
  - Madison Coin Club: November 29, 2026 and February 28, 2027, Marriott West,
    Middleton. One series, not a separate record per occurrence.
  - Sheboygan Coin Club: March 14, 2027, Emil Mazey Hall.
  - Waukesha Coin Club: March 14, 2027, New Berlin Ale House, New Berlin.
  - Fox Valley Coin Club: March 21, 2027, Hilton Paper Valley Hotel, Appleton.
  - South Shore Coin Club: April 11, 2027, American Legion Post 434, Oak Creek.
  - Wisconsin Valley Coin Club: April 18, 2027, Holiday Inn, Rothschild.
  - Barron County Coin Club: June 12, 2027, Cedar Mall, Rice Lake.
  - Chippewa Valley: May 2, 2027, Best Western Plus, Eau Claire.
  - Milwaukee Numismatic Society: November 8, 2026, Brookfield; correct the
    misleading October frequency label without inventing a new date.
- <https://www.raleighcoinclub.org/expo> explicitly announces June 17–19, 2027,
  a Whitman Brands / Raleigh Coin Club partnership, and the move from the old
  fairgrounds venue to Raleigh Convention Center, 500 S. Salisbury Street.
  Preserve the existing Raleigh series and canonical URL.

Oshkosh is not the existing NOW State Convention in Green Bay. Venue cities
are used for the New Berlin, Oak Creek and Rothschild records even where the
calendar headline names a nearby city. No recurrence-generated dates, private
contacts, third-party-only leads, or new organizer/profile promises are added.

## Verification and limits

Regenerate with `ruby _scripts/generate-pages.rb`, run the existing Ruby and
JavaScript suites, and validate with `ruby _scripts/validate-data.rb` and
`git diff --check`. Frozen dataset totals reflect 216 records: 119 scheduled
and 97 date-not-confirmed at the existing September 4 test boundary.

This batch closes eight specific missing-series gaps and one newly announced
Raleigh date/venue gap. It is not a nationwide completeness estimate. Report
publication only after merge, successful Pages deployment and public feed
readback. The daily reviewer routine's first execution is a separate receipt.
