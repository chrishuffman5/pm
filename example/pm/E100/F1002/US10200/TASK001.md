# TASK001 — Walk the pm/E<NNN> tree
**Story:** US10200
**Effort:** M
**Depends on:** none

## Objective
Discover every node in a PM tree by walking the `pm/` folder: locate the epic charter(s) under
`E<NNN>/CLAUDE.md`, each feature `F1xxx/CLAUDE.md`, and each story `US1xxxx/CLAUDE.md`, building the
parent/child model the rest of the generator renders from.

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — tree-walk that enumerates epic/feature/story `CLAUDE.md`
  files and assembles them into an in-memory hierarchy.

## Implementation notes
- Recurse from the `-Path` root; identify node type by folder-name pattern (`E<NNN>`, `F1xxx`,
  `US1xxxx`) rather than depth alone.
- Read each node's `CLAUDE.md` once and cache its parsed metadata for the rollup/render passes.
- Skip generated `.html` files and the helper scripts; tasks are `.md` files surfaced inside their
  story page, not separate nodes.

## Acceptance criteria
- [x] Every epic, feature, and story folder with a `CLAUDE.md` is discovered and placed under its
  correct parent in the hierarchy.
- [x] Folders without a `CLAUDE.md` and non-node files are ignored without error.

## Out of scope
- Rendering, rollups, and styling (later tasks in this story).
