# TASK001 — Write the skill description trigger phrases
**Story:** US10002
**Effort:** M
**Depends on:** none

## Objective
Write the `pm` skill's single front-matter `description` so it fires across all three modes'
vocabularies — the description is the skill's whole trigger surface.

## Files to create / modify
- `skills/pm/SKILL.md` — the front-matter `description`.

## Implementation notes
- Cover scaffold/bootstrap/init phrasing, refine/groom/plan phrasing, and execute/claim-a-story
  phrasing so the skill triggers regardless of intended mode.
- The actual mode is chosen inside `SKILL.md` by the first token; the description just has to fire.

## Acceptance criteria
- [x] The `description` includes trigger phrases for init, plan, and execute modes.
- [x] It is a single description covering all three (not three separate skills).

## Out of scope
- The progressive-disclosure body structure (TASK002).
