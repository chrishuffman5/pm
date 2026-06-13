# TASK004 — Cross-reference wording (/pm init, /pm plan)

**Story:** US10103
**Effort:** S
**Depends on:** none

## Objective

Make the cross-references between modes consistent and correct everywhere they appear: `SKILL.md`'s
"The other modes" section and the reference prompts all describe invocation as `/pm`, `/pm init`,
`/pm plan` (the keyword as the first argument to the one skill) — never `/pm:init`, which would
imply a separate skill.

## Files to create / modify

- `skills/pm/SKILL.md` — the "The other modes" section pointing at `references/init.md` and `references/plan.md` with `/pm init` / `/pm plan` wording.
- `skills/pm/references/init.md` — the "After init — the other modes" cross-references use the same wording.
- `skills/pm/references/plan.md` — the "The other modes" cross-references use the same wording.

## Implementation notes

- Each mode's doc should point at the other two with a one-line description so an agent can hop
  between them.
- Keep the wording identical across the three files so there's no drift about how the skill is invoked.

## Acceptance criteria

- [x] `SKILL.md` and both reference prompts cross-reference the modes as `/pm`, `/pm init`, `/pm plan` (never `/pm:init`).
- [x] Each mode doc points at the other two reference prompts consistently.

## Out of scope

- The dispatch table/inference content (TASK001 / TASK002).
