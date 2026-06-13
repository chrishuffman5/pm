# TASK001 — PM playbook (own a Feature, delegate, never code)

**Story:** US10100
**Effort:** M
**Depends on:** none

## Objective

Write the PM role and its step-by-step playbook into `SKILL.md`: a long-running agent that owns one
Feature `F1xxx`, confirms feature-level dependencies, loops over its stories in dependency order
spawning a Worker per story, reviews/merges/tears down each worktree, and owns the Feature's status
fields. A PM coordinates and never writes code.

## Files to create / modify

- `skills/pm/SKILL.md` — add the "PM (Project Manager)" role section and the numbered "PM playbook"
  (confirm ownership → verify deps → set Feature In progress → story loop → set Feature Done).

## Implementation notes

- Make the "a PM that starts coding has lost the plot — spawn a Worker" rule explicit; it's the
  most common failure mode.
- The story loop must pick the next story whose `Depends on:` are all `Done`, and cap concurrency
  (~3 Workers) so the PM's review queue doesn't become the bottleneck.
- Feature `Status:` → `In progress` on first story start, `Done` only when every story is `Done`,
  via `set-status.ps1`.

## Acceptance criteria

- [x] `SKILL.md` defines the PM role as a long-running agent owning one Feature that only delegates.
- [x] The numbered PM playbook covers dependency verification, the per-story spawn/review/merge/tear-down loop, and the Feature status transitions.

## Out of scope

- The exact git commands (TASK003 / `references/worktree.md`).
- How the Worker picks its model (US10104).
