# TASK005 — Portfolio index.html
**Story:** US10200
**Effort:** S
**Depends on:** TASK003, TASK004

## Objective
Generate the portfolio `pm/index.html`: the top-level dashboard listing every epic with an overall
completion bar and links into each epic page, serving as the single status indicator across the whole
tree.

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — `index.html` emission at the `pm/` root aggregating all
  epics and the overall completion bar.

## Implementation notes
- Show the overall ticked/total AC rollup across all epics as the headline progress bar.
- Link each listed epic to its `E<NNN>.html` page.
- Leave a slot for the Roadmap section that US10203 fills from `PLAN.md`.

## Acceptance criteria
- [x] `pm/index.html` is generated at the tree root listing all epics with an overall completion bar.
- [x] Each epic entry links to its epic page.

## Out of scope
- Embedding PLAN.md (US10203) and final theme polish (TASK006).
