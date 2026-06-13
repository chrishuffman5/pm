# TASK004 — Add Status log + Model fields to templates
**Story:** US10001
**Effort:** M
**Depends on:** TASK001 (same story)

## Objective
Extend the Feature/Story/Task templates with the timestamped `## Status log` standard and the
story-level `**Model:**` field, plus the heuristic for choosing the model.

## Files to create / modify
- `skills/pm/references/tree-structure.md` — add the `## Status log` section + format spec, the
  `**Model:**` line to the story template, and the "Model assignment" heuristic.

## Implementation notes
- Status-log format: `- <UTC ISO-8601 to the minute> — <Status>[ — <note>]`, oldest first, first
  entry always `Created`.
- `**Model:**` defaults to `claude-sonnet-4-6`; bump to `claude-opus-4-8` for architectural,
  ambiguous, algorithmic, cross-cutting, or security-sensitive stories.

## Acceptance criteria
- [x] The status-log format and "first entry is Created" rule are specified.
- [x] The story template carries `**Model:**` and the model-assignment heuristic is documented.

## Out of scope
- The `set-status.ps1` and `build-pm-html.ps1` implementations (Feature F1002).
