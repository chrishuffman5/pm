# TASK002 — Worker playbook (own one Story, work in a worktree, tick ACs as you go)

**Story:** US10100
**Effort:** M
**Depends on:** none

## Objective

Write the Worker role and playbook into `SKILL.md`: a single-purpose agent that owns exactly one
Story `US1xxxx`, works in a dedicated git worktree, reads the story `CLAUDE.md` + every `TASK*.md`,
verifies story dependencies, executes tasks in order ticking acceptance criteria as each is
satisfied, and sets the story `Status:` to `Done` only when every task's ACs are ticked.

## Files to create / modify

- `skills/pm/SKILL.md` — add the "Worker" role section and the numbered "Worker playbook"
  (handoff → verify deps → set up worktree → set In progress → per-task implement+tick → set Done → push + report).

## Implementation notes

- Emphasize ticking checkboxes (`- [ ]` → `- [x]`) *as each is satisfied*, not in a batch — a
  crashed Worker must leave an honest record of what's actually done.
- "One Worker, one Story": a Worker never grabs a second story; if scope grows, surface it.
- The Worker reports back to the PM on completion (branch, worktree path, summary) and exits.

## Acceptance criteria

- [x] `SKILL.md` defines the Worker role as owning exactly one Story end-to-end in its own worktree.
- [x] The numbered Worker playbook covers dependency verification, in-order task execution with incremental AC ticking, and the Done → push → report sequence.

## Out of scope

- The worktree git commands themselves (TASK003).
- Blocker handling (TASK005).
