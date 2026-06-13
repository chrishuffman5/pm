# US10104 — Per-story model assignment contract

**Feature:** F1001
**Status:** Done
**Model:** claude-sonnet-4-6
**Depends on:** US10100

**Last updated:** 2026-06-12

## User value

As a PM spawning Workers, I want each story to carry an explicit `Model:` line decided at plan time
so that I don't have to judge story complexity at spawn time — I just read the field and run that
story's Worker on the assigned model (Sonnet by default, Opus for the genuinely hard ones).

## Acceptance criteria

- [x] The story `CLAUDE.md` template carries a `**Model:**` line (`claude-sonnet-4-6` default;
  `claude-opus-4-8` for complex stories), documented in `references/tree-structure.md`.
- [x] A Sonnet/Opus heuristic is documented (Opus for architectural, ambiguous, algorithmic,
  cross-cutting, or security-sensitive stories; Effort S/M/L as a proxy), with bias toward the Sonnet default.
- [x] Execute mode reads the story's `Model:` line and passes it as the Agent tool's `model`
  parameter when spawning that story's Worker (defaulting to Sonnet if absent).

## Tasks

- TASK001 — Add the Model: line to the story template
- TASK002 — Sonnet/Opus selection heuristic
- TASK003 — Execute mode reads Model: when spawning the Worker

## Verification

Read `references/tree-structure.md` (template + "Model assignment" heuristic) and the PM playbook in
`SKILL.md` (step 4c reads `Model:` and passes it to the Agent tool, defaulting to `claude-sonnet-4-6`).
Confirm `init.md` assigns it and `plan.md` re-evaluates it, so the contract is consistent end-to-end.

## Status log
- 2026-06-10T18:10Z — Created
- 2026-06-12T13:10Z — In progress — defining the Model: contract
- 2026-06-12T16:00Z — Done — per-story model assignment contract complete
