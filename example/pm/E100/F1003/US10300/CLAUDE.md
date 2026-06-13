# US10300 — Skill-invocation test harness
**Feature:** F1003
**Status:** Done
**Model:** claude-sonnet-4-6
**Depends on:** none
**Last updated:** 2026-06-13

## User value

As a skill maintainer, I want a repeatable harness that spins up disposable workspaces with seeded
PM trees and a documented scenario list, so that I can exercise the `pm` skill end-to-end without
hand-building fixtures or polluting the repo each time.

## Acceptance criteria
- [x] `test/setup-workspaces.sh` creates a clean, throwaway workspace on demand
- [x] a seed-tree builder produces a known-good `pm/` fixture inside a workspace
- [x] `test/SCENARIOS.md` enumerates the invocation scenarios the harness covers
- [x] workspace run outputs are gitignored so runs never dirty the repo

## Tasks
- TASK001 — Workspace setup script (test/setup-workspaces.sh)
- TASK002 — Seed-tree builder
- TASK003 — Scenario catalog (test/SCENARIOS.md)
- TASK004 — Gitignore run outputs

## Verification

Run `test/setup-workspaces.sh`, confirm it produces an isolated workspace with a seeded `pm/`
tree, that every scenario in `test/SCENARIOS.md` has a workspace it can run against, and that
`git status` stays clean after a run (outputs ignored).

## Status log
- 2026-06-12T16:10Z — Created
- 2026-06-13T09:00Z — In progress
- 2026-06-13T10:30Z — Done
