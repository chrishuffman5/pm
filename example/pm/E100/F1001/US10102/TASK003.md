# TASK003 — Moving-a-story-across-features recipe

**Story:** US10102
**Effort:** M
**Depends on:** none

## Objective

Document the "move a story to a different feature (and split a feature)" recipe in
`references/plan.md`: the new *feature* gets the next free `F1xxx`, but a moved *story* keeps its
original `US1xxxx` ID — renumbering it is exactly what breaks `Depends on:` references. A moved story
whose ID no longer matches its parent's century block is expected and correct.

## Files to create / modify

- `skills/pm/references/plan.md` — add the "Moving a story to a different feature" subsection with
  the numbered recipe (git mv → update `Feature:` → fix `## Stories` lists → reconcile `Depends on:` → new stories get fresh IDs).

## Implementation notes

- The ID-encodes-parent convention is only a *birth-time* convenience, not an invariant to rewrite
  later.
- Anything that depended on the moved story still uses its unchanged ID (no edit needed); only
  brand-new stories created during the split draw fresh IDs from the new feature's block.
- Note the move in the moved story's `## Status log` / the feature charters so the reshape is traceable.

## Acceptance criteria

- [x] `references/plan.md` documents the move recipe with the "keep the original US1xxxx ID" rule and rationale.
- [x] The numbered steps cover folder move, `Feature:` update, both `## Stories` lists, and `Depends on:` reconciliation.

## Out of scope

- The general additive rule (TASK002) and the three-views sync (TASK004).
