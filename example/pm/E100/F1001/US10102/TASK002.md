# TASK002 — Additive / never-renumber cardinal rule

**Story:** US10102
**Effort:** S
**Depends on:** none

## Objective

Document the cardinal rule of refinement in `references/plan.md`: IDs (`F1xxx`, `US1xxxx`,
`TASK[NNN]`) are referenced as dependencies all over the tree, so refinement is **additive, never
destructive** — add with the next free ID, never renumber to "tidy up", and mark dropped work
`Cancelled` rather than deleting it.

## Files to create / modify

- `skills/pm/references/plan.md` — add "The cardinal rule: additive, never destructive" section
  (next-free-ID for additions, split-keeps-original-ID, `Cancelled` via `set-status.ps1`).

## Implementation notes

- New nodes are written from the seeded charter templates, including a `## Status log` seeded with a
  `Created` line, just like `pm init`.
- Dropping work uses `set-status.ps1 -Status "Cancelled" -Note "<why>"` so the cancellation is
  timestamped, rather than deleting the folder (unless the user confirms and nothing depends on it).

## Acceptance criteria

- [x] `references/plan.md` states the additive/never-renumber rule and explains why (dependency references break).
- [x] It documents marking dropped work `Cancelled` via set-status.ps1 instead of deleting.

## Out of scope

- The cross-feature move recipe (TASK003).
