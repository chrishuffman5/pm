# TASK003 — Apply the best description
**Story:** US10303
**Effort:** S
**Depends on:** TASK002 (same story)

## Objective

Apply the winning `description` to the skill's front-matter so the shipped skill triggers reliably
across all three modes.

## Files to create / modify
- `skills/pm/SKILL.md` — set the optimized `description` front-matter (the skill's whole trigger surface)

## Implementation notes
- The single `description` must cover all three modes since mode is chosen inside `SKILL.md` after
  the skill fires.
- Re-run the eval set one final time to confirm the applied description scores as expected.

## Acceptance criteria
- [ ] the optimized description is set in `skills/pm/SKILL.md`
- [ ] it covers scaffold / refine / execute phrasings
- [ ] a final eval run confirms the applied description's accuracy

## Out of scope
- Further wording iterations beyond the chosen winner.
