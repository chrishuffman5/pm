# US10000 — Extract the pm skill into a plugin repo
**Feature:** F1000
**Status:** Done
**Model:** claude-sonnet-4-6
**Depends on:** none
**Last updated:** 2026-06-09

## User value
As a Claude Code user, I want the `pm` skill packaged as a self-contained plugin repo so that
I can install it from a marketplace and use it in any project, instead of it living only inside
the landfinder codebase.

## Acceptance criteria
- [x] `.claude-plugin/plugin.json` exists, validates, and carries name/version/author with no
  `skills` field (convention-based discovery).
- [x] `.claude-plugin/marketplace.json` lists the single `pm` plugin with a matching version.
- [x] `skills/pm/` contains `SKILL.md`, `references/`, and `scripts/` copied from the source skill.
- [x] Repo root has `LICENSE`, `README.md`, and a `CLAUDE.md` describing the repo's purpose.

## Tasks
- TASK001 — Create .claude-plugin/plugin.json
- TASK002 — Create marketplace.json
- TASK003 — Copy SKILL.md + references + scripts into skills/pm/
- TASK004 — Add LICENSE, README, repo CLAUDE.md

## Verification
`plugin.json` and `marketplace.json` parse as JSON and report the same version; `skills/pm/SKILL.md`
opens with valid front-matter; the four root files exist. Loading the plugin locally surfaces the
`pm` skill in a fresh Claude Code session.

## Status log
- 2026-06-09T15:40Z — Created
- 2026-06-09T15:45Z — In progress
- 2026-06-09T17:00Z — Done
