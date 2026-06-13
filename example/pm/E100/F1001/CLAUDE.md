# F1001 — Lifecycle modes (init · plan · execute)

**Phase:** 2
**Status:** Done
**Depends on:** F1000
**Last updated:** 2026-06-12

## Purpose

Give the single `pm` skill three modes — **execute** (the default PM/Worker build-out),
**init** (greenfield scaffold of a brand-new tree), and **plan** (refinement of an existing
tree) — plus the first-token dispatch that routes between them and the per-story `Model:`
contract that the executor reads when it spawns a Worker. This is the behavioural heart of the
skill: F1000 packaged a skill that does something; this feature is the *something*.

## In scope

- The **execute**-mode workflow in `SKILL.md`: PM and Worker roles, the one-story-one-worktree
  mechanic, status discipline, and blocker escalation.
- The **init**-mode reference prompt (`references/init.md`): turn a design brief into a populated
  `pm/` tree, including input-gathering, the scaffolding procedure, and file-count verification.
- The **plan**-mode reference prompt (`references/plan.md`): the additive/never-renumber rule, the
  move-a-story-across-features recipe, and keeping `PLAN.md` + charters + HTML in step.
- The **mode dispatch** at the top of `SKILL.md`: the "Pick the mode first" table and the
  inferred-intent rules that route a request to the right mode by its first token.
- The per-story **`Model:` assignment contract**: the story-template field, the Sonnet/Opus
  heuristic, and execute mode reading that field when it spawns the Worker.

## Out of scope

- The packaging/manifest work (F1000) — this feature assumes the skill is already discoverable.
- The HTML generator and `set-status.ps1` internals (F1002 tooling); this feature *uses* them but
  does not build them. `references/worktree.md` is documented here because it is part of the
  execute-mode workflow.
- The validation/release work (later phase).

## Acceptance criteria (feature-level)

- [x] All three modes (execute, init, plan) are documented and self-consistent.
- [x] First-token dispatch routes a request to the correct mode (with inferred-intent fallback).
- [x] A story's `Model:` line is consumed at Worker-spawn time by execute mode.

## Stories

- US10100 — Execute mode: PM/Worker roles & worktree workflow — Status: Done
- US10101 — Init mode: greenfield scaffolder — Status: Done
- US10102 — Plan mode: refinement workflow — Status: Done
- US10103 — Mode dispatch: single skill, first-token routing — Status: Done
- US10104 — Per-story model assignment contract — Status: Done

## Key design notes

- **One skill, three modes — not three skills.** `/pm:init` would be the *plugin:skill*
  invocation convention, making `init` a separate skill. The user wants `/pm`, `/pm init`,
  `/pm plan`, so init/plan are **reference prompts** that `SKILL.md` dispatches to by the first
  token. That choice constrains every story in this feature.
- **`SKILL.md` owns dispatch + execute; `references/` owns the other two modes** so all three
  share the same bundled `scripts/` and `references/tree-structure.md`.
- The **`Model:` contract** spans three modes: `init` assigns it, the story file stores it,
  `execute` reads it at spawn, `plan` re-evaluates it — so US10104 depends on the execute role
  (US10100) existing first.

## Open questions

- None outstanding at close. The init/plan boundary ("reshape vs. build") is resolved by the
  inferred-intent rule in US10103 (ask when genuinely unsure between plan and execute).

## Status log
- 2026-06-10T18:10Z — Created
- 2026-06-11T09:00Z — In progress — lifecycle-mode work began (execute role first)
- 2026-06-12T16:00Z — Done — all three modes + dispatch + Model contract landed
