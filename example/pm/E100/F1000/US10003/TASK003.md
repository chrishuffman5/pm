# TASK003 — Push and verify
**Story:** US10003
**Effort:** S
**Depends on:** TASK001 (same story) ; TASK002 (same story)

## Objective
Push the initial commit to the private remote and confirm the tree landed intact.

## Files to create / modify
- (remote) — `git push -u origin <default-branch>`; verify via `gh repo view` / remote browse.

## Implementation notes
- Set upstream on first push so later pushes are bare `git push`.
- Verify the remote default branch shows the full plugin layout and the repo is private.

## Acceptance criteria
- [x] The initial commit is pushed to `origin` with upstream tracking set.
- [x] The remote shows the complete tree and is confirmed private.

## Out of scope
- Cutting a versioned/public release (Feature F1003).
