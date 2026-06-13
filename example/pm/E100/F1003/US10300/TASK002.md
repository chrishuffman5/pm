# TASK002 — Seed-tree builder
**Story:** US10300
**Effort:** M
**Depends on:** TASK001 (same story)

## Objective

Produce a known-good seed `pm/` tree inside a workspace — a small epic/feature/story/task skeleton
with valid templates and status logs — so dispatch tests have a realistic tree to read and mutate.

## Files to create / modify
- `test/setup-workspaces.sh` — extend with a seed-tree builder (or add a helper it calls) that writes a minimal valid `pm/` fixture
- `example/pm/` — reference the canonical templates/layout when shaping the seed

## Implementation notes
- Mirror the templates and numbering in `skills/pm/references/tree-structure.md` so the fixture is
  indistinguishable from a real `init`-scaffolded tree.
- Keep it small (one feature, a couple of stories) but include at least one story with several tasks
  so execute-mode tests have something to claim.
- Seed valid `## Status log` lines so status-parsing paths are exercised.

## Acceptance criteria
- [x] the builder writes a structurally valid `pm/` tree into a workspace
- [x] the seed tree matches the canonical templates and numbering scheme
- [x] at least one story carries multiple tasks and a seeded status log

## Out of scope
- Generating the HTML mirror; tests invoke `build-pm-html.ps1` themselves when needed.
