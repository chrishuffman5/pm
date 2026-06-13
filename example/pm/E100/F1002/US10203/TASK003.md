# TASK003 — Relocate PLAN.md into pm/
**Story:** US10203
**Effort:** S
**Depends on:** TASK001

## Objective
Move `PLAN.md` to live under `pm/` so the entire tree — roadmap, helper scripts, generated
dashboard, and the epic tree — is self-contained in one folder, matching the canonical layout.

## Files to create / modify
- `pm/PLAN.md` — the roadmap, relocated under the `pm/` tree root (from any prior repo-root location).
- `skills/pm/references/tree-structure.md` — confirm the layout shows `PLAN.md` inside `pm/`.

## Implementation notes
- The generator reads `PLAN.md` from the `pm/` root (TASK001), so its home must be there.
- Update any references that pointed at a repo-root `PLAN.md`.

## Acceptance criteria
- [x] `PLAN.md` resides under `pm/`, not at the repo root.
- [x] The generator finds and renders it from the new location.

## Out of scope
- The rendering logic itself (TASK001, TASK002).
