# US10101 — Init mode: greenfield scaffolder

**Feature:** F1001
**Status:** Done
**Model:** claude-sonnet-4-6
**Depends on:** none
**Last updated:** 2026-06-11

## User value

As someone starting a new project, I want `/pm init <brief>` to turn a design brief into a fully
populated `pm/` tree — `PLAN.md`, the epic charter, the F/US/TASK skeleton, the installed helper
scripts, and a per-story `Model:` assignment — so that I get a self-describing, internally
consistent tree the other two modes can immediately build out or refine.

## Acceptance criteria

- [x] `references/init.md` documents the end-to-end scaffolding procedure: read tree-structure,
  write `PLAN.md`, write the epic charter (templates verbatim), then each feature/story/task.
- [x] Input-gathering is defined: pull epic statement, feature list, rough story breakdown, and
  dependencies from the design brief or by asking — never fabricate domain facts.
- [x] A file-count verification step confirms the tree is complete (markdown counts, every
  story has a charter + TASK001, each `## Stories` block matches its actual folders, HTML mirror exists).

## Tasks

- TASK001 — references/init.md scaffolding workflow
- TASK002 — Input-gathering from a design brief
- TASK003 — The scaffolding procedure (PLAN → charter → F/US/TASK)
- TASK004 — File-count verification step

## Verification

Read `skills/pm/references/init.md`: the input-gathering checklist, the numbered scaffolding
procedure, the model-assignment call-out, and the "Verify the tree" file-count checks all exist
and reference `references/tree-structure.md` as the template source of truth.

## Status log
- 2026-06-10T18:10Z — Created
- 2026-06-11T13:00Z — In progress — drafting the init reference prompt
- 2026-06-11T16:00Z — Done — init mode scaffolder complete
