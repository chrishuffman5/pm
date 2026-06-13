# TASK002 — Scaffold example/pm via init mode
**Story:** US10302
**Effort:** L
**Depends on:** TASK001 (same story)

## Objective

Run init mode to scaffold the designed tree into `example/pm/` — `PLAN.md`, the epic charter, the
feature/story/task skeleton, the installed helper scripts, and per-story model assignments.

## Files to create / modify
- `example/pm/PLAN.md` — cross-feature roadmap for the example epic
- `example/pm/E100/` — epic charter plus the feature/story/task tree
- `example/pm/build-pm-html.ps1`, `example/pm/set-status.ps1` — the helper scripts installed by init

## Implementation notes
- Use init mode rather than hand-writing, so the example is a faithful demonstration of the skill's
  own output.
- Follow `skills/pm/references/tree-structure.md` templates and numbering exactly; seed valid
  `## Status log` lines and `**Model:**` assignments.

## Acceptance criteria
- [x] `example/pm/` contains a complete, valid tree (PLAN, charters, stories, tasks)
- [x] the two helper scripts are installed into `example/pm/`
- [x] every story has a `**Model:**` line and a seeded status log

## Out of scope
- HTML generation (TASK003) and Pages serving setup (TASK004/TASK005).
