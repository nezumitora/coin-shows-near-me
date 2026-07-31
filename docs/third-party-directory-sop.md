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

## Listing lifecycle guidance

This section records the directory-operator guidance received on 2026-07-31. Reuse the decision pattern for future event directories, but adapt the fields and verification sources to the industry.

### Recurring event series

- Keep one stable, indexable URL for the series when credible evidence shows the event continues.
- Update the same page when a new date is confirmed instead of creating a new date-specific URL.
- If the last date passed and the next date is not confirmed, label the page clearly as a past event awaiting its next date.
- Keep a visible date history when it helps users and organizers understand the series.
- Do not invent the next date from words such as `annual`, `monthly`, or `first annual`; verify the recurrence rule or next occurrence.

### One-time, renamed, duplicate, or cancelled events

- Keep an old page when it still has useful historical information, meaningful links, or a genuine successor.
- Use a permanent redirect only when there is a clear equivalent destination, such as a duplicate or renamed canonical listing.
- Use a real 404 or 410 for a thin, inaccurate, permanently removed page with no replacement.
- Never redirect unrelated expired listings to the homepage merely to avoid a 404; that is confusing and can be treated as a soft 404.
- Remove retired URLs from internal links and sitemaps after the intended status is verified.

## Organizer verification and outreach

Offer useful verification before asking for a backlink:

1. Ask the organizer to confirm the show name, date, venue, address, organizer identity, official URL, and preferred contact method.
2. Record the source and verification date without publishing private contact details.
3. Apply a visible verification state only after the evidence standard is met.
4. Give the organizer a simple correction/update path.
5. After delivering a useful, accurate listing, optionally invite the organizer to share or link to it.

Do not make verification contingent on a backlink, payment, or promotional commitment.

## Dealer onboarding and monetization sequence

1. Start with free dealer registration or profile claiming to learn what dealers actually value.
2. Measure profile claims, updates, show associations, referral interest, and organizer/dealer feedback.
3. Test a limited founding-dealer package only after repeated demand is visible.
4. State exactly what a paid package includes; never imply ranking, verification, or editorial preference can be bought.
5. Keep verification criteria independent from sponsorship or payment status.

## Operating priority

Accurate data and direct organizer relationships come before new scrapers, portals, or monetization tools. Build automation only after the manual workflow exposes a repeated bottleneck that can be tested safely.
