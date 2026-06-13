# TASK002 — Apply progressive-disclosure structure
**Story:** US10002
**Effort:** M
**Depends on:** TASK001 (same story)

## Objective
Structure `SKILL.md` so it leads with mode selection and defers mode detail to `references/*.md`,
keeping the always-loaded skill body small while full instructions load only when needed.

## Files to create / modify
- `skills/pm/SKILL.md` — "Pick the mode first" dispatch table up front; `execute` workflow inline;
  pointers to `references/init.md` and `references/plan.md` for the other modes.

## Implementation notes
- First token → `init` | `plan` | `execute`; infer intent when no keyword is given.
- Reference prompts stay plain (no SKILL.md front-matter) so they aren't discovered as skills.

## Acceptance criteria
- [x] `SKILL.md` opens with the mode-pick dispatch and keeps the body lean.
- [x] `init`/`plan` detail is deferred to `references/*.md` rather than inlined.

## Out of scope
- The contents of `init.md` / `plan.md` (Feature F1001).
