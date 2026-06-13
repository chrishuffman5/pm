# TASK001 — Workspace setup script (test/setup-workspaces.sh)
**Story:** US10300
**Effort:** M
**Depends on:** none

## Objective

Write a shell script that provisions a clean, disposable workspace for a test run — a fresh temp
directory with the `pm` skill available — so each scenario starts from a known-empty state.

## Files to create / modify
- `test/setup-workspaces.sh` — create the workspace bootstrap script (mktemp dir, copy/symlink the skill, print the workspace path)

## Implementation notes
- POSIX `sh`; use `mktemp -d` for isolation so parallel runs never collide.
- Make the skill reachable from the workspace the way a consumer repo would see it.
- Idempotent and safe to re-run; emit the created path so callers can `cd` into it.

## Acceptance criteria
- [x] running the script yields a fresh, isolated workspace directory
- [x] the script prints the workspace path for the caller
- [x] re-running produces a new, non-colliding workspace

## Out of scope
- Seeding the tree contents (TASK002) and the scenario list (TASK003).
