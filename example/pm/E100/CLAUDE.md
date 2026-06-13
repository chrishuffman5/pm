# E100 — Build and open-source the `pm` skill
**Status:** Done
**Last updated:** 2026-06-13

> **You are inside the Rally hierarchy for the `pm` skill's own development.** Design intent is
> in `example/CLAUDE.md`; the cross-feature roadmap is in `pm/PLAN.md`. This file is the **epic
> charter** — it tells an agent dropped into `pm/E100/` what the tree is for and how to navigate it.

## Epic statement

Turn the landfinder `pm` skill into a reusable, open-source Claude Code plugin: a single `pm`
skill that works a Rally-style PM tree (Epic → Feature → User Story → Task) in three modes —
**init** (scaffold a tree), **plan** (refine one), **execute** (build it out with a team of
agents) — backed by self-contained tooling (an HTML tracker generator and a timestamped
status-log helper) and validated by real agent-driven tests.

## Markets / scope

The "product" is the skill. Scope spans four phases: foundation & packaging, the lifecycle
modes, the tooling, and validation & release. Out of scope: any product domain — this tree is
about the skill, not about what the skill is used to build.

## Rally hierarchy & numbering

```
E100/
├── CLAUDE.md            ← this file
├── F1000/               ← Feature
│   ├── CLAUDE.md        ← feature charter
│   ├── US10000/         ← User Story
│   │   ├── CLAUDE.md    ← story context
│   │   ├── TASK001.md   ← Task
│   │   └── …
│   └── …
└── …
```

- Features `F1000`–`F1003`. Stories `US10xyN` for feature `F10xy`. Tasks `TASK001`+ per story.
- Numbering is **additive and permanent** — IDs are referenced as dependencies; never renumber.

## File templates (use exactly these)

### Feature `CLAUDE.md`
```
# F1xxx — <name>
**Phase:** N
**Status:** Not started | In progress | Done
**Depends on:** F1xxx (or "none")
**Last updated:** YYYY-MM-DD

## Purpose
## In scope
## Out of scope
## Acceptance criteria (feature-level)
- [ ] …
## Stories
- US1xxxx — <title> — Status: …
## Key design notes
## Open questions

## Status log
- YYYY-MM-DDTHH:MMZ — Created
- 2026-06-13T18:07Z — Done — all 4 features complete — pm skill built and shipped
```

### Story `CLAUDE.md`
```
# US1xxxx — <title>
**Feature:** F1xxx
**Status:** Not started | In progress | Done
**Model:** claude-sonnet-4-6 | claude-opus-4-8
**Depends on:** US1xxxx (or "none")
**Last updated:** YYYY-MM-DD

## User value
As a <persona>, I want <capability> so that <outcome>.
## Acceptance criteria
- [ ] …
## Tasks
- TASK001 — <title>
## Verification

## Status log
- YYYY-MM-DDTHH:MMZ — Created
```

### Task `TASK[NNN].md`
```
# TASK[NNN] — <title>
**Story:** US1xxxx
**Effort:** S | M | L
**Depends on:** none

## Objective
## Files to create / modify
- `path/to/file` — what changes
## Implementation notes
## Acceptance criteria
- [ ] …
## Out of scope
```

## Working agreement
1. Verify dependencies before claiming a story.
2. Status discipline: change status via `pm/set-status.ps1` (stamps the timestamped `## Status log` + regenerates HTML).
3. One agent per story. Story `Done` ⇔ every task's ACs ticked.
4. The root `CLAUDE.md` is the design north star; if a PM file conflicts, the root wins.
5. Additive, never renumber.
6. Regenerate the HTML tracker (`pm/build-pm-html.ps1`) in the same turn as any `CLAUDE.md` edit.

## Verification (after the tree is populated)
1. Every `F1xxx/` has a `CLAUDE.md`; every `US1xxxx/` has a `CLAUDE.md` and at least `TASK001.md`.
2. Each feature's `## Stories` block enumerates exactly its `US1xxxx/` subfolders.
3. Every story has a `**Model:**` value and a seeded `## Status log`.
4. `index.html` + one `.html` per epic/feature/story exists.

## Status log
- 2026-06-09T14:00Z — Created
- 2026-06-09T15:30Z — In progress — foundation work began
