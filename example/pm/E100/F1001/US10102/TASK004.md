# TASK004 — Keep PLAN.md + charters + HTML in step

**Story:** US10102
**Effort:** S
**Depends on:** none

## Objective

Document the "keep the three views in step" discipline in `references/plan.md`: a refinement that
updates one view and not the others leaves the tree lying about itself. Whenever the tree changes,
keep `PLAN.md` ↔ the charters, each feature's `## Stories` list ↔ its actual `US1xxxx/` folders, the
`Last updated:` lines, and the regenerated HTML tracker all consistent in the same turn.

## Files to create / modify

- `skills/pm/references/plan.md` — add the "Keep the three views in step" section and the
  "don't touch status to fake progress" rule.

## Implementation notes

- Re-phasing or adding/removing a feature updates both the `PLAN.md` catalog/graph and the affected
  `CLAUDE.md` files together; regenerate via `pwsh -NoProfile -File pm/build-pm-html.ps1 -Path <repo>/pm`.
- Plan mode reshapes the plan, not execution state — newly-added nodes start `Not started`, dropped
  ones become `Cancelled`; flipping to `In progress`/`Done` is the executor's call.

## Acceptance criteria

- [x] `references/plan.md` requires keeping PLAN.md, the charters, the `## Stories` lists, `Last updated:`, and the HTML tracker in step each turn.
- [x] It states that plan mode must not advance execution status to fake progress.

## Out of scope

- The HTML generator internals (F1002 tooling).
