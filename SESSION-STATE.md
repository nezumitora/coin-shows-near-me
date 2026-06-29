# Session State

**Last updated:** 2026-06-29 15:20 (PDT)
**Session:** prompt library and show-update automation

## Completed today
- Added Coin Shows Instagram profile link `https://www.instagram.com/coinshowsnearme` to contact page social card, homepage footer, and inner-page footer; bumped visible site version to v0.9.2. Pending build/commit/deploy verification.
- Started v0.9.3 worktree fixes: Event schema now emits only for specific dates and converts valid dates to ISO 8601; mobile form/card overflow CSS tightened; weekly review-only show-update report workflow/script added.
- Started v0.9.4: added prompt-library structure and expanded show-update reporting to daily source inventory/URL checks with CSV artifacts.
- Processed inbox task `2026-06-29_143123_milohiss-automation-schema-mobile-qa.json` into `inbox/processed/` after acting on it.
- Created linked worktree `/Users/milohiss/Git/_worktrees/coin-shows-near-me-favicon-comparison-20260629` on branch `favicon-comparison-20260629`.
- Added two local favicon comparison pages: `/favicon-test-gpt.html` using `assets/images/favicon-test-gpt.png` and `/favicon-test-nano.html` using `assets/images/favicon-test-nano.png`.
- Started local preview server on port `4175`; both test pages return 200 via `http://127.0.0.1:4175/`.
- User chose GPT favicon option. Generated replacement `favicon.ico`, 16/32/48/180/192 PNG assets, added source image `assets/images/favicon-source-gpt-20260629.png`, updated favicon cache-buster, and bumped visible site version to v0.9.1.
- Live verification found homepage has its own favicon links separate from `_includes/head_custom.html`; updated homepage favicon cache-busters too so the homepage browser tab uses the new icon.
- Started safe aidevops setup in linked worktree `coin-shows-near-me-aidevops-20260507`.
- Added aidevops project config and AI-training opt-out attributes.
- Enabled planning, git workflow, code quality, time tracking, beads, SOPS, and security.
- Left database automation off because this is a static Jekyll/GitHub Pages site, not a database-backed app.
- Removed generated local-path helper links and database folders before commit because this is a public repo.
- Clarified `AGENTS.md` SSH guidance so AI agents do not use root/admin SSH.

## In progress
- Verify v0.9.4 automation script and prompt files before commit/push.

## Next up
- Commit/push v0.9.4 after verification.
- Review daily report artifacts, then add approved external comparison sources.
- Continue whole-site mobile QA once a local preview/browser path is available.

## Open decisions
- Need exact external source URLs approved before building comparison scrapers beyond the URLs already stored in `_data/shows.yml`.
- Local `jekyll` command is missing, so full local build preview is not verified yet.
