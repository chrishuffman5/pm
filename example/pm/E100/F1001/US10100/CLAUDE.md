# US10100 — Execute mode: PM/Worker roles & worktree workflow

**Feature:** F1001
**Status:** Done
**Model:** claude-sonnet-4-6
**Depends on:** none
**Last updated:** 2026-06-11

## User value

As an engineer driving a populated PM tree, I want a clear runtime workflow — a PM agent that
only delegates and Worker agents that each own one story in their own git worktree — so that
multiple stories build out in parallel without stepping on each other and status stays honest.

## Acceptance criteria

- [x] `SKILL.md` documents the two roles: a long-running PM that owns a Feature and only
  delegates, and short-lived Workers that each own one Story end-to-end.
- [x] The "one story = one worktree = one branch" mechanic is spelled out, with `references/worktree.md`
  carrying the exact create / sync / push / merge / tear-down git commands.
- [x] Status discipline is defined: Story/Feature `Status:` transitions go through `set-status.ps1`,
  and blocker escalation has a documented `## Blocker` section + `Blocked` status path.

## Tasks

- TASK001 — PM playbook (own a Feature, delegate, never code)
- TASK002 — Worker playbook (own one Story, work in a worktree, tick ACs as you go)
- TASK003 — references/worktree.md: per-story git commands
- TASK004 — Status discipline through set-status.ps1
- TASK005 — Blocker escalation procedure

## Verification

Read `skills/pm/SKILL.md`: the PM and Worker playbooks, the worktree mechanic, the status-discipline
contract, and the blocker-escalation section all exist and agree with `references/worktree.md`. A PM
never codes; a Worker never grabs a second story.

## Status log
- 2026-06-10T18:10Z — Created
- 2026-06-11T09:00Z — In progress — drafting PM/Worker playbooks
- 2026-06-11T12:00Z — Done — execute-mode workflow complete
