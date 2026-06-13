# US10001 — Define the Rally hierarchy & file templates
**Feature:** F1000
**Status:** Done
**Model:** claude-opus-4-8
**Depends on:** none
**Last updated:** 2026-06-09

## User value
As an agent dropped into a PM tree, I want one canonical reference that fixes the Epic/Feature/
Story/Task templates, the numbering scheme, and the working agreement so that every node I read
or write is internally consistent and parseable by later tooling.

## Acceptance criteria
- [x] `references/tree-structure.md` defines verbatim templates for Epic, Feature, Story, and Task.
- [x] The numbering scheme is specified as additive, permanent, per-feature century blocks
  (`F10xy` → `US10xyN` → `TASK001+`).
- [x] Templates include the `**Model:**` field and a `## Status log` section with the timestamped
  history standard, plus a written working agreement.

## Tasks
- TASK001 — Epic/Feature/Story/Task templates
- TASK002 — Numbering scheme (per-feature century blocks)
- TASK003 — Working agreement
- TASK004 — Add Status log + Model fields to templates
- TASK005 — Write references/tree-structure.md master reference

## Verification
`references/tree-structure.md` renders the four templates with exact `**Key:** value` metadata
lines, documents the numbering rule and model heuristic, and is the only place templates are
defined (no duplicate copies). The `init`/`execute` modes can scaffold and parse a tree purely
from this contract.

## Status log
- 2026-06-09T15:40Z — Created
- 2026-06-09T17:05Z — In progress
- 2026-06-09T20:00Z — Done
