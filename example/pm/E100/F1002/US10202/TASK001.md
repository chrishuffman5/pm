# TASK001 — Define the ## Status log format
**Story:** US10202
**Effort:** S
**Depends on:** US10200

## Objective
Specify the `## Status log` standard that every epic/feature/story `CLAUDE.md` carries: one line per
transition, oldest first, in a fixed, sortable, machine-parseable shape that both `set-status.ps1`
writes and `build-pm-html.ps1` reads.

## Files to create / modify
- `skills/pm/references/tree-structure.md` — document the format, the always-`Created`-first rule,
  and the optional per-transition note as the canonical standard.

## Implementation notes
- Format: `- <UTC ISO-8601 timestamp to the minute> — <Status> [— <optional note>]`.
- UTC + `Z` keeps entries unambiguous and sortable across agents in different time zones.
- Tasks carry no status log — they track progress via AC checkboxes only.

## Acceptance criteria
- [x] The status-log format, ordering, and first-entry rule are written into the master reference.
- [x] The note field is documented as the per-transition "why" record.

## Out of scope
- The writer (TASK002) and the chip parser (TASK004).
