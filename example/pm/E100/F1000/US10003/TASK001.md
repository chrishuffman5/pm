# TASK001 — git init + initial commit
**Story:** US10003
**Effort:** S
**Depends on:** US10000

## Objective
Place the assembled plugin repo under version control with a clean initial commit capturing the
full layout (manifests, `skills/pm/`, root housekeeping files).

## Files to create / modify
- `.gitignore` — ignore generated/local artifacts as needed.
- (repo) — `git init`, stage all, create the initial commit.

## Implementation notes
- Commit only after US10000's files exist so the initial commit is the complete foundation.
- Keep generated HTML out of the commit if it is build output, or include it intentionally.

## Acceptance criteria
- [x] The repo is a git repo with an initial commit.
- [x] The commit includes the manifests, `skills/pm/`, and root files.

## Out of scope
- Creating the remote (TASK002) and pushing (TASK003).
