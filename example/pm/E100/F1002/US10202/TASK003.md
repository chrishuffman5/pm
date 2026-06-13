# TASK003 — Auto-regenerate HTML after a status change
**Story:** US10202
**Effort:** S
**Depends on:** TASK002

## Objective
Have `set-status.ps1` invoke `build-pm-html.ps1` after writing the status change so the dashboard
always reflects the latest state — making status update and HTML regen a single atomic operation.

## Files to create / modify
- `skills/pm/scripts/set-status.ps1` — locate and call the sibling `build-pm-html.ps1` against the
  tree root once the `CLAUDE.md` edit succeeds.

## Implementation notes
- Resolve the tree root from the target `CLAUDE.md` path and pass it as `-Path` to the generator.
- Only regenerate after the edit succeeds; surface generator failures rather than swallowing them.

## Acceptance criteria
- [x] A successful status change triggers a generator run with no separate manual step.
- [x] The affected node's `.html` reflects the new status after the call returns.

## Out of scope
- The chip rendering itself (TASK004).
