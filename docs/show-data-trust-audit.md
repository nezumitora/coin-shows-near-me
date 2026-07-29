# Show Data Trust Audit

This is a local, report-only audit for Coin Shows listing quality. It does not
edit `_data/shows.yml`, generated pages, templates, schema, sitemap, indexing
settings, CRM configuration, or outreach systems.

## Run

```bash
ruby _scripts/show-data-trust-audit.rb --as-of 2026-07-29 \
  --inventory-branch main \
  --inventory-commit 250cf6cc0575ef6c07fc29b307feebb860518aad
```

Reports are written outside the repo by default:

```text
${AIDEVOPS_TEMP_DIR:-~/.aidevops/.agent-workspace/tmp}/coin-shows-near-me/show-data-trust-audit/
```

## Categories

- `expired_specific_date` — exact day or date range ended before the audit date. This is advisory only; expired-page indexing decisions remain on hold.
- `ambiguous_partial_date` — month/year values such as `July 2026`; these are not automatically expired.
- `unparseable_date` — date is not TBD, a supported month/year partial, or a supported specific date/range.
- `duplicate_candidate_exact` — same normalized name/city/state; still requires manual evidence review.
- `duplicate_candidate_high-confidence` — likely duplicate based on same city/state and strong title overlap; never auto-merge.
- `duplicate_candidate_low-confidence` — possible duplicate requiring manual review.
- `obsolete_date_in_title` — title contains date-like wording that can become stale.
- `tbd_date_contradiction` — `next_date` is `TBD` while title or notes contain date-like text.
- `missing_or_incomplete_venue` — blank or suspicious venue/location fields.
- `missing_last_verified` — no verification date is recorded; never bulk-invent one.
- `missing_public_source_url` — no public `source_url` or `website` exists; this is separate from confidence because direct organizer confirmation may be strong private evidence.
- `weak_third_party_only_evidence` — third-party lead needs official or direct corroboration.
- `visible_schema_mismatch` — visible date precision/status and current Event schema behavior need later review after the full status matrix is approved.

## CI behavior

Existing data findings are advisory and should not fail CI. Script/runtime errors
and deterministic unit-test failures should fail.
