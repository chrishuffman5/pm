# TASK003 — The scaffolding procedure (PLAN → charter → F/US/TASK)

**Story:** US10101
**Effort:** M
**Depends on:** none

## Objective

Write the numbered scaffolding procedure into `references/init.md`: read tree-structure, write
`pm/PLAN.md`, write the epic charter (templates verbatim), then create each feature charter, each
story charter (with a seeded `## Status log` Created entry and a `Model:` assignment), and at least
`TASK001.md` per story — then install the helper scripts and generate the tracker.

## Files to create / modify

- `skills/pm/references/init.md` — the numbered scaffolding procedure plus the "Model assignment"
  call-out and the "HTML tracker" install/generate step.
- `skills/pm/references/tree-structure.md` — referenced as the source for templates, numbering, and the model heuristic (no edit required here).

## Implementation notes

- Work feature-by-feature so a partially-built tree stays internally consistent.
- Each feature/story/epic charter gets a `## Status log` seeded with a single
  `- <UTC timestamp> — Created` line at scaffold time.
- Default each story to `claude-sonnet-4-6`; bump to `claude-opus-4-8` per the heuristic, and list
  the Opus bumps when reporting.

## Acceptance criteria

- [x] `references/init.md` gives the ordered procedure (tree-structure → PLAN.md → epic charter → features → stories+tasks → scripts/HTML).
- [x] It specifies the seeded `## Status log` Created entry and per-story `Model:` assignment during scaffolding.

## Out of scope

- The closing file-count verification (TASK004).
