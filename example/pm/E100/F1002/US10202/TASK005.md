# TASK005 — Add Status log to the templates
**Story:** US10202
**Effort:** S
**Depends on:** TASK001

## Objective
Add a seeded `## Status log` section (with a `Created` first entry) to the Epic, Feature, and Story
`CLAUDE.md` templates so every scaffolded node starts with a valid log that `set-status.ps1` then
appends to.

## Files to create / modify
- `skills/pm/references/tree-structure.md` — add the `## Status log` block to the Feature and Story
  templates (and the epic charter), seeded with a `Created` line.

## Implementation notes
- Place `## Status log` as the final section of each node template.
- Seed it with a single `- YYYY-MM-DDTHH:MMZ — Created` placeholder line.
- Tasks get no status-log section.

## Acceptance criteria
- [x] The Epic/Feature/Story templates each end with a seeded `## Status log` section.
- [x] The seeded entry matches the TASK001 format and is the `Created` transition.

## Out of scope
- The writer/parser behavior (TASK002, TASK004).
