# TASK005 — Fix findings (moved-story rule) and re-run
**Story:** US10301
**Effort:** M
**Depends on:** TASK004 (same story)

## Objective

Act on the grading findings — chiefly the moved-story rule the plan-mode scenario surfaced — fix
the skill content, then re-run the full scenario set to confirm the suite is green.

## Files to create / modify
- `skills/pm/references/plan.md` — clarify/repair the moved-story (additive, never-renumber) rule
- `skills/pm/references/tree-structure.md` — keep the rule statement consistent if referenced there
- `test/RESULTS.md` — append the clean re-run results

## Implementation notes
- The moved-story finding: relocating a story must stay additive (new ID, dependencies repointed)
  rather than renumbering in place; make the reference prompt unambiguous about this.
- Re-run all five scenarios against fresh workspaces after the fix; the suite must be green.

## Acceptance criteria
- [x] the moved-story rule is corrected in the skill references
- [x] the full scenario set is re-run after the fix
- [x] the re-run passes and is recorded in `test/RESULTS.md`

## Out of scope
- New scenarios beyond the five (additive future work, not this task).
