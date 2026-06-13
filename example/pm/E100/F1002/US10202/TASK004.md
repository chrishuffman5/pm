# TASK004 — Created/started/done timeline chips in the generator
**Story:** US10202
**Effort:** M
**Depends on:** TASK001

## Objective
Teach `build-pm-html.ps1` to parse the `## Status log` and render created/started/done timeline
chips on each node page, plus surface the full log in the page body.

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — `Get-Meta` status-log parsing into chips (Created /
  In progress / Done timestamps) and full-log rendering.

## Implementation notes
- Tolerate `-`, en-dash, and em-dash separators when parsing each log line (writers may vary).
- Derive the "started" chip from the first `In progress` entry and "done" from the `Done` entry.
- Keep the parser in lockstep with the format defined in TASK001 / written by set-status.ps1.

## Acceptance criteria
- [x] Each node page shows created/started/done chips derived from its status log.
- [x] The full status log renders in the page body; mixed dash styles parse correctly.

## Out of scope
- Writing log entries (TASK002) — this task only reads them.
