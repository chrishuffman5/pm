# TASK004 — Gitignore run outputs
**Story:** US10300
**Effort:** S
**Depends on:** TASK001 (same story)

## Objective

Ensure transient harness outputs — workspaces, generated trees, run logs — never get committed, so
running the suite leaves the repo clean.

## Files to create / modify
- `.gitignore` — add ignore patterns for the harness's workspace/output directories
- `test/setup-workspaces.sh` — confirm outputs land under an ignored path

## Implementation notes
- Prefer writing runtime outputs under a single ignored directory so one pattern covers them.
- Verify with `git status --porcelain` being empty after a full run.

## Acceptance criteria
- [x] harness run outputs are matched by `.gitignore`
- [x] `git status` is clean after a harness run
- [x] no fixture/workspace artifacts are tracked by git

## Out of scope
- The contents of the seed tree (TASK002).
