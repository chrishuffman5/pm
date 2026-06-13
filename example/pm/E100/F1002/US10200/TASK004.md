# TASK004 — Per-node pages (epic/feature/story)
**Story:** US10200
**Effort:** M
**Depends on:** TASK002, TASK003

## Objective
Emit one HTML page per epic, feature, and story node — a sibling of its `CLAUDE.md` with the same
basename (`E100.html`, `F1xxx.html`, `US1xxxx.html`) — showing the rendered body, the status badge,
the AC rollup, and navigation to parent and child nodes.

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — per-node page emission writing each `.html` beside its
  `CLAUDE.md`, with breadcrumb/child links between levels.

## Implementation notes
- Story pages also surface their `TASK[NNN].md` files inline (tasks are not mirrored to their own
  HTML pages).
- Use the basename of the node folder for the output file so links are stable.
- Overwrite existing generated pages idempotently on every run.

## Acceptance criteria
- [x] One `.html` page is written beside every epic/feature/story `CLAUDE.md` with the matching basename.
- [x] Each page links to its parent and to its child nodes (and a story lists its tasks).

## Out of scope
- The portfolio `index.html` (TASK005) and theme/styling (TASK006).
