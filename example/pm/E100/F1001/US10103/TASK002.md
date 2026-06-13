# TASK002 — Inferred-intent rules for keyword-less requests

**Story:** US10103
**Effort:** M
**Depends on:** none

## Objective

Document how to infer the mode when the request carries no explicit `init`/`plan` keyword: a tree
that doesn't exist yet → init; reshaping a tree that does exist with no coding → plan; building the
tree out → execute. When genuinely unsure between plan and execute, ask.

## Files to create / modify

- `skills/pm/SKILL.md` — add the inferred-intent paragraph right after the mode table, including the
  "treat the rest of the input as that mode's brief" note when a keyword is present.

## Implementation notes

- This is the judgment-heavy part of dispatch (hence the story runs on Opus): the boundaries between
  "no tree" / "reshape" / "build out" must be unambiguous enough that an agent routes consistently.
- Reinforce that a `pm` invocation landing with no `pm/E<NNN>/` tree should go to init first.

## Acceptance criteria

- [x] `SKILL.md` documents the no-keyword inference rules (no tree → init; reshape → plan; build out → execute).
- [x] It instructs the agent to ask when genuinely unsure between plan and execute.

## Out of scope

- The reference-prompt collapse (TASK003) and cross-reference wording (TASK004).
