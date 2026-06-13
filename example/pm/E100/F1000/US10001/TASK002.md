# TASK002 — Numbering scheme (per-feature century blocks)
**Story:** US10001
**Effort:** M
**Depends on:** TASK001 (same story)

## Objective
Specify the additive, permanent ID scheme that lets stories be referenced as dependencies without
ever renumbering: epics `E<NNN>`, features `F1xxx`, stories encoded by parent feature, tasks
restarting per story.

## Files to create / modify
- `skills/pm/references/tree-structure.md` — the "Numbering scheme" section.

## Implementation notes
- Story IDs encode the parent feature: `F10xy` → `US10xyN` (e.g. `F1004` → `US10400`, `US10401`).
- Tasks restart at `TASK001` inside each story folder.
- State the rule plainly: numbering is additive and permanent — never renumber, only append.

## Acceptance criteria
- [x] The per-feature century-block mapping is documented with worked examples.
- [x] The "additive, never renumber" rule is stated explicitly.

## Out of scope
- The working agreement that operationalizes the rule (TASK003).
