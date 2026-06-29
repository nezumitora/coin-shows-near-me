# Data Cleanup Prompts

## Show listing cleanup

```text
Clean and normalize this coin show listing for `_data/shows.yml`.

Rules:
- Do not invent dates, venues, websites, or organizers.
- Keep uncertain dates as `TBD` or a partial date only if that is all the source provides.
- Prefer official organizer/club websites over third-party directories.
- Add a note when the source needs human review.
- Return the updated YAML fields and a short explanation of changes.

Current listing: [YAML]
Source notes: [SOURCE_NOTES]
```
