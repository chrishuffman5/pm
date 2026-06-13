# TASK002 — Run the optimization loop
**Story:** US10303
**Effort:** M
**Depends on:** TASK001 (same story)

## Objective

Iterate candidate `description` strings against the eval set, scoring each on should-fire recall
and should-not precision, to find the wording that maximizes correct triggering.

## Files to create / modify
- `test/RESULTS.md` — record candidate descriptions and their trigger scores
- `skills/pm/SKILL.md` — staging ground for candidate `description` front-matter during the loop

## Implementation notes
- Use the skill-creator's description-optimization approach: vary the description, re-evaluate the
  eval set, keep the best-scoring candidate.
- Track both false negatives (missed triggers) and false positives (spurious triggers).

## Acceptance criteria
- [x] candidate descriptions are scored against the full eval set
- [x] both recall and precision are measured per candidate
- [x] the best-scoring candidate is identified and recorded

## Out of scope
- Committing the winner into the skill (TASK003).
