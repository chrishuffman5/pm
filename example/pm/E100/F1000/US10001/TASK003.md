# TASK003 — Working agreement
**Story:** US10001
**Effort:** S
**Depends on:** TASK001 (same story)

## Objective
Capture the operating rules every agent follows when working the tree — dependency verification,
status discipline, one-agent-per-story, the Done definition, root-CLAUDE.md precedence, and the
additive rule — so behavior is consistent across agents and sessions.

## Files to create / modify
- `skills/pm/references/tree-structure.md` — the "Working agreement" section (also written into
  the epic charter at scaffold time).

## Implementation notes
- "Story is Done ⇔ every task's acceptance criteria are ticked" is the load-bearing rule.
- Status changes go through `set-status.ps1`, not hand edits.

## Acceptance criteria
- [x] The working agreement enumerates the dependency, status, ownership, Done, and additive rules.
- [x] It is phrased to be copied verbatim into the epic charter.

## Out of scope
- The status-log format spec (TASK004).
