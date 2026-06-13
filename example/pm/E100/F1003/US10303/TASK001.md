# TASK001 — Build a should/should-not trigger eval set
**Story:** US10303
**Effort:** M
**Depends on:** US10301

## Objective

Assemble a labeled eval set of prompts that *should* trigger the `pm` skill (across all three
modes' phrasings) and prompts that *should not*, to measure trigger accuracy objectively.

## Files to create / modify
- `test/SCENARIOS.md` — add (or cross-link) a trigger eval section with labeled should / should-not prompts

## Implementation notes
- Should-fire set must cover scaffold/bootstrap, refine/groom, and execute/claim-a-story phrasings.
- Should-not set should include nearby-but-unrelated prompts (generic project chatter, other tools)
  to catch false positives.

## Acceptance criteria
- [x] a labeled should-fire set covers all three modes' phrasings
- [x] a should-not set includes plausible false-positive prompts
- [x] the set is machine-readable for the optimization loop

## Out of scope
- Running the loop (TASK002) and applying the result (TASK003).
