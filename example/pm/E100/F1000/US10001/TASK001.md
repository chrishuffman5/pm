# TASK001 — Epic/Feature/Story/Task templates
**Story:** US10001
**Effort:** M
**Depends on:** none

## Objective
Define the four verbatim node templates (Epic, Feature, Story, Task) with exact `**Key:** value`
metadata lines and the standard section headings, so every scaffolded node is uniform and
machine-parseable.

## Files to create / modify
- `skills/pm/references/tree-structure.md` — the four template code blocks.

## Implementation notes
- Metadata lines (`**Status:**`, `**Depends on:**`, etc.) are parsed by the HTML generator and by
  later agents — keep the exact key names and `**Key:** value` shape.
- Tasks carry no `Status:` line; they track progress via acceptance-criteria checkboxes.

## Acceptance criteria
- [x] All four templates appear in `tree-structure.md` with consistent metadata and headings.
- [x] Section headings match what `init` writes and `execute`/`plan` parse.

## Out of scope
- Numbering rules (TASK002) and the status-log/Model additions (TASK004).
