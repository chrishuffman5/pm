# TASK001 — "Pick the mode first" table in SKILL.md

**Story:** US10103
**Effort:** S
**Depends on:** none

## Objective

Add the "Pick the mode first" table at the top of `SKILL.md` that maps the first token of the
request to a mode and an action: `init` → read `references/init.md`; `plan` → read
`references/plan.md`; anything else (default) → continue into the execute workflow below.

## Files to create / modify

- `skills/pm/SKILL.md` — add the "Pick the mode first" section with the first-token → mode → action
  table, placed before the execute-mode workflow.

## Implementation notes

- For `init`/`plan`, the directive is explicit: read the matching reference and **don't continue in
  this file**.
- Note that the other two modes live in `references/` so all three share the bundled `scripts/` and
  `references/tree-structure.md`.

## Acceptance criteria

- [x] `SKILL.md` opens with a mode table routing `init` and `plan` to their reference prompts and everything else to execute.
- [x] The table directs init/plan invocations to stop reading SKILL.md and follow the reference file.

## Out of scope

- The keyword-less inference rules (TASK002).
