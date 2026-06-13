# TASK003 — Grade reports against the filesystem
**Story:** US10301
**Effort:** M
**Depends on:** TASK002 (same story)

## Objective

For each scenario, grade the agent's claimed outcome against the real on-disk result — did it pick
the right mode, and does the tree it left behind match what that mode should have produced?

## Files to create / modify
- `test/RESULTS.md` — record per-scenario grade (mode chosen vs expected, filesystem diff, pass/fail)
- `example/pm/` — reference the canonical templates when checking structural correctness

## Implementation notes
- Grade on two axes: dispatch correctness (right mode) and output correctness (tree matches the
  mode's contract — templates, numbering, status logs).
- A plausible-sounding report that does not match the filesystem is a fail; the filesystem is the
  source of truth.

## Acceptance criteria
- [x] each scenario is graded on both dispatch and output correctness
- [x] grades are derived from the filesystem, not the report's self-claim
- [x] failures name the specific discrepancy

## Out of scope
- Authoring the results document structure beyond the grades (TASK004).
