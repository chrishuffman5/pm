# TASK003 — Scenario catalog (test/SCENARIOS.md)
**Story:** US10300
**Effort:** S
**Depends on:** TASK002 (same story)

## Objective

Document the set of invocation scenarios the harness covers — which mode each exercises, the input
phrasing, and the expected outcome — so dispatch tests have a single authoritative checklist.

## Files to create / modify
- `test/SCENARIOS.md` — create the scenario catalog (one row/section per scenario: prompt, mode under test, expected result)

## Implementation notes
- Cover all three modes (init / plan / execute) and both the keyword and the inferred-intent path.
- Each scenario names the seed-tree state it assumes and the observable success signal.
- Keep it readable as a hand-run checklist as well as an agent-readable spec.

## Acceptance criteria
- [x] every scenario lists its prompt, target mode, and expected outcome
- [x] init, plan, and execute are all represented
- [x] both keyword and inferred-intent dispatch are represented

## Out of scope
- Actually running the scenarios and grading them (that is US10301).
