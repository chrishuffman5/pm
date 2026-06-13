# TASK003 — Generate the HTML tracker
**Story:** US10302
**Effort:** S
**Depends on:** TASK002 (same story)

## Objective

Render the scaffolded example tree to its static HTML dashboard using the skill's own generator, so
the example ships with a clickable mirror of every node.

## Files to create / modify
- `example/pm/index.html` — generated portfolio dashboard (embeds PLAN.md)
- `example/pm/E100/**/*.html` — generated epic/feature/story pages beside each CLAUDE.md

## Implementation notes
- Run `build-pm-html.ps1 -Path example/pm -ProjectName "pm — Claude Code skill"`.
- Confirm status rollups and created/started/done chips reflect the seeded status logs.

## Acceptance criteria
- [x] `example/pm/index.html` is generated and embeds the roadmap
- [x] one HTML page exists per epic/feature/story node
- [x] status rollups match the tree's CLAUDE.md statuses

## Out of scope
- Configuring Pages to serve these files (TASK004/TASK005).
