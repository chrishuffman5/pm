# TASK001 — Design the meta example (this tree)
**Story:** US10302
**Effort:** M
**Depends on:** US10301

## Objective

Design the worked example: model the skill's own development as a single-epic PM tree, mapping the
real build phases (foundation & packaging, lifecycle modes, tooling, validation & release) to
features and stories.

## Files to create / modify
- `example/CLAUDE.md` — describe the example's intent and what it demonstrates
- `example/pm/` — plan the epic/feature/story breakdown the scaffold will instantiate

## Implementation notes
- The "product" managed here is the skill itself; statuses must be real (most Done, release still
  In progress) so the dashboard shows honest partial completion.
- Phase the features to match the actual history so the tree is credible documentation.

## Acceptance criteria
- [x] the example is designed as the skill's own build journey
- [x] features/stories map to the real build phases with realistic statuses
- [x] the design follows the canonical numbering and templates

## Out of scope
- Writing the actual files (TASK002) and rendering (TASK003).
