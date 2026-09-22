# GSC remediation: first local fix

## Scope and status

Owner authorized starting local GSC fixes after the September 20 read-only review.
This is not release, GSC-control, indexing-request, or Cloudron authorization.
The separate September 8-12 listing-verification batch remains untouched.
Dashboard handoff remains **forwarded by owner; Dashboard import unconfirmed**.
Do not retry the protected canonical inbox write.

Base: `bd9fb18c88f22cdc593a4a2970770950b1d44963`.
Branch: `feature/auto-20260920-210849`. Work remains local and unpublished;
no push, deployment, or GSC action is authorized.

## Confirmed defect and evidence

- GSC's September 17 snapshot reports the legacy URL
  `/cities/june-25th-27th-countryside-il/` as 404, last crawled September 17.
- The September 20 live review independently confirmed that 404 and a working
  `/cities/countryside-il/` destination.
- Commit `ca2fc50d66f3b70307142f907bfe94af4d8ae07b` (July 29) corrected the
  Greater Chicago Coin, Currency, & Collectibles Show's imported city from
  `June 25th - 27th @ Countryside` to `Countryside`, changing its city slug to
  `countryside-il`. That same commit deleted the legacy city page without a
  replacement redirect. This proves succession; the target is not a guess.
- The September-prefixed Countryside alias is a different URL already handled.

## Local implementation

- Added the exact June-prefixed alias to `_data/city_redirects.yml`, retaining
  all seven existing mappings and documenting the historical source.
- Added `cities/june-25th-27th-countryside-il.md` using the existing generator's
  pattern: immediate HTML refresh, canonical destination, `noindex,follow`,
  explicit destination link, and `sitemap: false`.
- Extended the existing exact-map regression in
  `_scripts/redirect_and_indexing_test.rb` to cover the eighth city alias.
- This is the existing static-host HTML redirect approach, not an HTTP 301.
  It does not change global robots rules, sitemap configuration, show facts,
  or canonical destination pages. Regeneration preserves the new alias.

## Verification

- Ruby syntax check: passed for the changed test file.
- Redirect/indexing suite: 4 tests, 103 assertions, no failures/errors/skips.
- SEO metadata suite: 6 tests, 5,492 assertions, no failures/errors/skips.
- Feed suite: 3 tests, 12 assertions, no failures/errors/skips.
- Data validation: 50 states, 197 shows, 32 show aliases, 8 city redirects.
- Generator: 466 page stubs and 197 feed records; no existing city page changes.
- Diff confirms `_data/shows.yml`, `shows.json`, state/show pages, workflows,
  and scraper configuration unchanged. Whitespace checks passed.
- Changed-file linter completed with exit 0 in a bounded operation after the
  initial short invocation timed out. Available checks are limited: the helper
  warned that Secretlint configuration and Markdownlint were unavailable, and
  flagged the pre-existing oversized melt-calculator file. Do not call this a
  complete lint-toolchain pass.
- A production-form Jekyll 4.2.2 build passed in an existing local container,
  with the source mounted read-only and output written outside the worktree.
- The built alias contains exactly one `noindex,follow`, one immediate refresh,
  and one canonical pointing to `/cities/countryside-il/`.
- The built sitemap excludes the legacy alias and contains the canonical target
  exactly once.
- A Playwright browser visit to the legacy route navigated to the existing
  Countryside page, retained its production canonical, and logged no console
  errors. No dependency or test-infrastructure installation was needed.

## Findings that must not be blindly changed

The snapshot reports 501 indexed and 52 excluded: 3 404, 15 noindex, and 34
crawled-not-indexed. The earlier saved baseline has 2/1/32 exclusions, but no
observation date or indexed total. Do not invent an indexed-growth comparison.

- Westland's redirect is already live; its August 11 GSC 404 is older evidence.
- All 15 pictured noindex show aliases are intentional and lead to nine working
  canonical pages. HTTP success does not prove Google indexed the destinations.
- `/states/{search_term}` is a placeholder, not a page to create or force-index.
- The 34 crawled-not-indexed URLs mix feeds, an intentionally excluded widget,
  retired aliases, and ordinary pages. The supplied example list is incomplete;
  July crawl dates can predate live changes. No blanket indexing fix is justified.
- No Coin clicks/impressions report was supplied. The email screenshot concerns
  a different property and is not evidence of Coin performance changes.

## Continuation and approval boundaries

1. The production-form build and browser redirect verification are complete.
2. Review complete excluded/indexed URL evidence when available before proposing
   changes to useful canonical pages. Do not claim all GSC issues fixed.
3. Keep publication separate. After separately authorized deployment, verify the
   live route before considering any separately authorized GSC follow-up.

This task record is committed with the local implementation. No push, merge,
deployment, GSC action, feature/schedule activation, or Cloudron change occurred.
The live URL remains unfixed until publication.
