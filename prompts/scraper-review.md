# Scraper Review Prompts

## Compare external source to site data

```text
Compare this external coin show source against our current `_data/shows.yml` records.

Rules:
- Do not update the data automatically.
- Report only: missing from our site, possible duplicate, date differs, venue differs, source unavailable, and needs human review.
- Use exact source URL and access date.
- Treat the organizer's official site as stronger evidence than a third-party directory.
- Flag conflicts instead of choosing silently.

Source URL: [URL]
Source extract: [EXTRACT]
Current matching site records: [CURRENT_DATA]
```

## Weekly report review

```text
Review the show update report artifacts and prioritize fixes.

Inputs:
- show-update-report.md
- show-source-inventory.csv
- show-url-checks.csv

Return:
1. Highest-risk listings for user trust.
2. Broken or suspicious source URLs.
3. TBD/partial dates most likely to need updates.
4. Suggested manual-review batch for the next work session.
```
