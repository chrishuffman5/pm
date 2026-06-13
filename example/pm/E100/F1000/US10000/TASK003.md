# TASK003 — Copy SKILL.md + references + scripts into skills/pm/
**Story:** US10000
**Effort:** M
**Depends on:** none

## Objective
Bring the actual skill content into the new repo under `skills/pm/`, establishing this repo as the
authoritative, deployable copy of the `pm` skill.

## Files to create / modify
- `skills/pm/SKILL.md` — the mode-dispatch skill entry point.
- `skills/pm/references/` — `init.md`, `plan.md`, `tree-structure.md`, `worktree.md`.
- `skills/pm/scripts/` — `build-pm-html.ps1`, `set-status.ps1`.

## Implementation notes
- Reference prompts use skill-root-relative paths (`references/…`, `scripts/…`).
- Treat the `skills/` copies here as authoritative over the working copy at
  `C:\Users\chris\.claude\skills\pm`.

## Acceptance criteria
- [x] `skills/pm/SKILL.md` exists with valid front-matter.
- [x] `skills/pm/references/` and `skills/pm/scripts/` contain the expected files.

## Out of scope
- Editing or refining the reference-prompt content (Features F1001/F1002).
