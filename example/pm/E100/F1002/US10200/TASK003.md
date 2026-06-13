# TASK003 — Status + acceptance-criteria rollups
**Story:** US10200
**Effort:** M
**Depends on:** TASK001, TASK002

## Objective
Compute progress rollups from the parsed tree: each node's `Status:`, and the count of ticked vs.
total acceptance-criteria checkboxes, aggregated up from stories to features to the epic so each
page shows how complete its subtree is.

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — `Get-Meta`-style parsing of `**Status:**` and AC
  checkbox counting, plus aggregation of child rollups into parent completion bars.

## Implementation notes
- Count `- [x]` as done and `- [ ]` as open within each node's `## Acceptance criteria` section.
- Roll story counts up into feature totals and feature totals up into the epic/portfolio bar.
- Map `Status:` values (`Not started` / `In progress` / `Done`) to a consistent badge per node.

## Acceptance criteria
- [x] Each node reports a correct ticked/total AC count and a status badge.
- [x] Feature and epic completion bars equal the aggregate of their descendants.

## Out of scope
- Visual styling of the bars/badges (TASK006).
