# Daily reviewed listing updates

## Purpose and authority

On October 26, 2026 UTC the owner requested urgent new-show and show-information
updates, then completion of the operating workflow. Reporting alone is not the
outcome. The daily `r-coin-listing-refresh` routine in `TODO.md` supplies the
missing reviewer/executor after the existing GitHub reporting jobs.

Scope is factual US show discovery, exact dates and public venue information.
Keep official-source verification, existing PR checks and merge gates. Do not
change forms, CRM, mail, consent, design, accounts, services or spending. Do not
enable the old Phase 2 schedule or bypass disabled controls in scraper scripts.

## One scheduler, separate stages

- GitHub Actions already runs Show Update Report, External Source Comparison and
  Third-Party Discovery. These are upstream reports, not publication jobs.
- The shared Pulse supervisor evaluates this registered repository's single
  `## Routines` section. The reviewer is due daily at **15:30 UTC**; missed slots
  are caught up by the scheduler. Do not install another cron/launchd job.
- This reviewer depends on the owner host and its existing authenticated runtime.
  A loaded supervisor does not prove the routine executed or published. Host sleep,
  authentication, model limits and merge/deploy failures must be visible holds.
- Use a linked worktree based on current remote main. Check existing active
  listing work/PRs first; never compete with an interactive owner or duplicate a
  batch. If busy, preserve the pending batch and report the exact hold.

## Execute on every invocation

1. Recover the last listing-update receipt, not a spot-price commit. Inspect the
   latest terminal runs and artifacts of all three reporting workflows. Record
   run IDs and UTC times. Do not re-crawl sources just because a job succeeded.
   If a report is older than 48 hours or failed, report that explicitly; pending
   jobs are not failures. Use existing authorized GitHub access; a broken command
   shim is not proof the installed CLI or authentication is absent.
2. Prioritize new missing shows and events within 30 days, then expired/TBD
   listings and the 31–90 day queue. Rotate through remaining states using a
   persistent coverage ledger; never restart with the same easy sources daily.
   Start with the already-listed official calendars and organizer links. Third-
   party directories supply leads only, not publishable authority.
3. Read source pages for exact show/date association. Shared calendar dates cannot
   be assigned by proximity alone. Expand official event pages, image calendars
   or rendered calendars when necessary using existing tools. Missing parser
   output means unreviewed, not no shows. In particular, an empty
   `third-party-lead-details.csv` must not be reported as a completed discovery
   pass. Deduplicate by show/organizer/venue/series, not just name or date.
4. Add genuinely missing US show/series records; update existing series rather
   than creating one duplicate record per occurrence. Require explicit year,
   dates and source-supported public venue/location. Record only known street/ZIP
   components; leave unknown values absent and flag them. Do not infer organizer
   authority, personal contacts, cancellation, closure or dates from recurrence.
   Preserve canonical URLs and aliases; uncertain identity/duplicate/closure
   questions remain held without blocking unrelated verified updates.
5. Record `source_url`, evidence-specific `last_verified`, explicit ISO
   `upcoming_dates`, readable `next_date` and concise `verification_notes`.
   Never refresh all verification timestamps merely because a page fetched.
   Keep previous confirmed evidence distinguishable from newly reviewed facts.
6. In the worktree, regenerate with `ruby _scripts/generate-pages.rb`. Run the
   configured Ruby and JavaScript checks, data validator, generated currentness,
   whitespace check and existing production Jekyll build. Adjust existing frozen
   dataset expectations only to reflect the reviewed data, never remove checks.
   Inspect the diff for unrelated/generated private material.
7. Commit and open a PR with the evidence, new-series count, changed-record count,
   added occurrence count and holds separately stated. Use normal reviewer and
   merge controls. A draft PR, green test or uploaded report is not completion.
   Publish verified routine-scope updates through the authorized existing merge
   and Pages path; if the runtime/maintainer gate disallows it, report the exact
   approval or execution hold rather than declaring success.
8. Verify the Pages run for the merged SHA, then fetch public `shows.json` and
   representative new/updated pages. Confirm the new IDs, dates, canonical routes
   and sitemap inclusion. A later spot-price rebuild is not a new listing batch.
   Report any deployment/content mismatch before marking the batch published.

## Durable result and escalation

Maintain `docs/listing-refresh-status.md` after each reviewed batch with:

- Actual attempted/completed UTC timestamps and upstream report run IDs.
- Source/state coverage completed, the next states/sources to review, and blocks.
- Distinct new shows, changed existing shows and newly added occurrence dates.
- Exact PR/merge SHA and Pages run; `published`, `held` or `no verified changes`.
- Separate outstanding candidate/coverage counts, never an invented missing-show
  total. Include the age of the last *published listing update*.

Never claim nationwide currency while unreviewed states/sources remain. If no
listing batch publishes for seven days, create/update one deduplicated high-
priority operational issue with the last publication evidence and exact blocker.
Do not create an issue per candidate or notification. Preserve unresolved leads
and continue other safe work. No customer contact or new service is authorized.

## Initial evidence

PR #96 merged `67def46e98df8a4cc2d547e4c95aa11d1a7d868c`; Pages run
`40266952526` completed successfully at `2026-10-26T04:03:02Z`. Public feed
readback confirmed 208 records, the new Kalamazoo ID, Buena Park March 13–14,
2027 and New Baltimore November 15, 2026. This establishes one actual publication,
not proof that the newly registered daily reviewer has run yet.
