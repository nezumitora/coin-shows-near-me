# Session State

**Last updated:** 2026-05-07 18:00 PT
**Session:** guardrail cleanup

## Completed today
- Started safe aidevops setup in linked worktree `coin-shows-near-me-aidevops-20260507`.
- Added aidevops project config and AI-training opt-out attributes.
- Enabled planning, git workflow, code quality, time tracking, beads, SOPS, and security.
- Left database automation off because this is a static Jekyll/GitHub Pages site, not a database-backed app.
- Removed generated local-path helper links and database folders before commit because this is a public repo.
- Clarified `AGENTS.md` SSH guidance so AI agents do not use root/admin SSH.

## In progress
- Guardrail fix committed locally; push/merge only with explicit approval.

## Next up
- Review the pending Instagram inbox item manually if it becomes relevant to Coin Shows content or strategy.

## Open decisions
- SOPS is enabled for future encrypted configs, but local `sops`/`age` tools still need setup before use.
