# Third-Party Coin Show Directory SOP

Goal: use other directories as lead sources without copying their protected content or publishing fake/trap entries.

## Hard rules

- Report-only first: scripts may create review artifacts, not edit `_data/shows.yml`.
- Do not copy descriptions, tables, photos, wording, page structure, or bulk lists from another directory.
- Do not publish a show from a third-party directory unless it is independently verified.
- Respect `robots.txt`, crawl delays, rate limits, and blocked paths.
- Keep third-party findings internal until verified from an official or independent source.
- Public artifacts should avoid reproducing third-party listing titles or descriptions; show source status and lead detail URLs only.

## Verification ladder

Use the highest available source before changing live show data:

1. Official show/promoter website.
2. Official coin club or numismatic association website.
3. Venue event calendar or convention-center listing.
4. Official Facebook page/event from the organizer, club, or venue.
5. State/regional numismatic association calendar.
6. Direct organizer confirmation by phone/email, if needed.
7. Third-party directory only = unverified lead; do not auto-add.

## Fake/trap-entry checks

Before adding a lead from a directory, check for:

- No evidence outside one directory.
- Strange typos, odd capitalization, or awkward date phrasing repeated exactly.
- Venue/date mismatch against the venue calendar.
- Organizer name that has no website, social page, phone, or prior history.
- Multiple directories with the same wording but no official source.
- Newly listed show with no trace in search results or local event calendars.

If two independent third-party sites agree but no official source exists, keep the show as `needs_verification` instead of publishing automatically.

## What the report should show

Each report should include:

- Source provider and original URL.
- Final URL after redirects.
- `robots.txt` / crawl-delay notes when known.
- Review status: `not_found`, `generic_directory`, `needs_parser`, `review_leads`, or `verified_candidate`.
- Candidate lead detail URLs and limited factual hints only; avoid repeating third-party listing copy in bulk.
- Independent verification URL, if found.
- Clear “Milo action needed” summary.

## Current third-party directories in repo data

- CoinZip — high-value lead source; use current category URLs and 10-second crawl delay.
- CoinShows-USA — historical source in repo; current state URLs redirect to a provider 404 page and need updated working URLs before use.

Most other source domains currently in repo data are official clubs, promoters, venues, or associations rather than broad third-party directories.
