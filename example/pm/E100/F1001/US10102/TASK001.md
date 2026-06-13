# TASK001 — references/plan.md refinement workflow

**Story:** US10102
**Effort:** M
**Depends on:** none

## Objective

Author `references/plan.md` as the `plan`-mode reference prompt: frame it as the planning session
between scaffolding and execution that reshapes an existing tree (split stories, repair deps,
re-phase, sharpen ACs, re-evaluate models), and ground the agent in the tree as the source of truth
before any change.

## Files to create / modify

- `skills/pm/references/plan.md` — the plan reference prompt: framing, the "ground yourself first"
  step (read `PLAN.md`, epic charter, in-scope files), and the "what a refinement session covers" menu.

## Implementation notes

- The mode changes *plans*, not product code — if you find yourself implementing a task, you've
  crossed into execution (the default mode).
- Use the seeded charter's templates when adding/editing nodes; if the tree contradicts the root
  `CLAUDE.md`, the root wins — surface the conflict.

## Acceptance criteria

- [x] `references/plan.md` exists and frames plan mode as reshaping an existing tree, not writing code.
- [x] It documents the "ground yourself first" step and the menu of refinement activities.

## Out of scope

- The never-renumber rule (TASK002), move recipe (TASK003), and three-views sync (TASK004).
