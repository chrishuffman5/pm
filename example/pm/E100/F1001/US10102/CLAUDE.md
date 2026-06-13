# US10102 — Plan mode: refinement workflow

**Feature:** F1001
**Status:** Done
**Model:** claude-sonnet-4-6
**Depends on:** none
**Last updated:** 2026-06-11

## User value

As a human grooming an existing tree between execution passes, I want `/pm plan` to safely reshape
it — split oversized stories, repair dependencies, re-phase, sharpen ACs, re-evaluate models —
without ever renumbering an ID, so that the plan improves while every `Depends on:` reference
stays valid.

## Acceptance criteria

- [x] `references/plan.md` documents the refinement workflow and grounds the agent in the tree as
  the source of truth (`PLAN.md`, epic charter, in-scope files) before changing anything.
- [x] The additive / never-renumber cardinal rule is stated, including marking dropped work
  `Cancelled` rather than deleting it.
- [x] A "move a story across features" recipe and the "keep `PLAN.md` + charters + HTML in step"
  discipline are both documented so the three views never drift.

## Tasks

- TASK001 — references/plan.md refinement workflow
- TASK002 — Additive / never-renumber cardinal rule
- TASK003 — Moving-a-story-across-features recipe
- TASK004 — Keep PLAN.md + charters + HTML in step

## Verification

Read `skills/pm/references/plan.md`: the ground-yourself-first step, the additive/never-renumber
rule, the move-a-story recipe (keep the original `US1xxxx` ID), and the three-views-in-step section
all exist. Confirm the mode explicitly refuses to advance execution status or write product code.

## Status log
- 2026-06-10T18:10Z — Created
- 2026-06-11T16:10Z — In progress — drafting the plan reference prompt
- 2026-06-11T18:00Z — Done — plan mode refinement workflow complete
