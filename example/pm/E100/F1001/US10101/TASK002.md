# TASK002 — Input-gathering from a design brief

**Story:** US10101
**Effort:** S
**Depends on:** none

## Objective

Document the "before you scaffold: gather the inputs" step in `references/init.md`: a PM tree is a
decomposition of a design, so the design comes first. Pull the epic statement, feature list, rough
per-feature story breakdown, and dependencies from the repo's root `CLAUDE.md`, an existing brief,
or by asking — and never invent domain facts to fill gaps.

## Files to create / modify

- `skills/pm/references/init.md` — add the input-gathering checklist and the "don't fabricate;
  capture genuine unknowns as open questions" rule.

## Implementation notes

- If the user only has a vague idea, propose a feature breakdown and confirm it before writing files.
- A confidently-wrong tree is worse than an honestly-incomplete one because later agents build on it
  — so unclear scope becomes an open question in the feature charter, not invented ACs.

## Acceptance criteria

- [x] `references/init.md` lists the four inputs (epic statement, feature list, story breakdown, dependencies) and their sources.
- [x] It states the rule to capture genuine uncertainty as open questions rather than fabricating content.

## Out of scope

- The procedure that consumes these inputs (TASK003).
