# TASK003 — references/worktree.md: per-story git commands

**Story:** US10100
**Effort:** S
**Depends on:** none

## Objective

Author `references/worktree.md` — the exact git commands behind the "one story = one worktree =
one branch" mechanic: the naming convention, and the create / sync-with-main / push / fast-forward
merge / tear-down sequences, plus edge cases. `SKILL.md` explains *why*; this file is the *how*.

## Files to create / modify

- `skills/pm/references/worktree.md` — naming convention (`us1xxxx-<slug>` branch,
  `../landfinder-us1xxxx` sibling path), create/sync/push/merge/teardown commands, listing & cleanup, edge cases.

## Implementation notes

- Branch off the **latest** `origin/main` with `git worktree add -b`; sibling-directory pattern
  keeps the main worktree clean for the PM and makes orphan detection easy via `git worktree list`.
- Prefer `git merge --ff-only` so the PM tree's history reads linearly; document the rebase fallback
  when history diverged.
- Tear down with `git worktree remove` + `git branch -d` (safe delete) + remote branch delete.

## Acceptance criteria

- [x] `references/worktree.md` documents the branch/worktree naming convention.
- [x] It gives the full create → sync → push → ff-only merge → tear-down command sequence with cross-platform path notes.

## Out of scope

- The PM/Worker prose that references these commands (TASK001 / TASK002).
