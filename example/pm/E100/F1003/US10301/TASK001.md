# TASK001 — Define 5 dispatch scenarios (init/plan/execute, keyword + inferred)
**Story:** US10301
**Effort:** M
**Depends on:** US10300

## Objective

Pin down five concrete test scenarios that, together, cover all three modes and exercise both the
keyword dispatch path and the harder inferred-intent path.

## Files to create / modify
- `test/SCENARIOS.md` — extend/finalize with the five graded dispatch scenarios and their expected modes
- `test/setup-workspaces.sh` — ensure each scenario has the seed-tree state it requires

## Implementation notes
- At minimum: one init, one plan, one execute via keyword; plus init and execute (or plan) via
  inferred intent with no keyword in the prompt.
- Each scenario states the seed state, the prompt, the expected mode, and the success signal a
  grader checks for.

## Acceptance criteria
- [x] exactly five scenarios are defined covering init / plan / execute
- [x] both keyword and inferred-intent dispatch are represented
- [x] each scenario has an unambiguous expected mode and success signal

## Out of scope
- Running the agents (TASK002) and grading (TASK003).
