# US10202 — Status-log standard + set-status.ps1
**Feature:** F1002
**Status:** Done
**Model:** claude-opus-4-8
**Depends on:** US10200
**Last updated:** 2026-06-12

## User value
As an agent changing a node's status, I want a single helper that records the transition with a
timestamp and regenerates the dashboard so that `Status:`, `Last updated:`, the `## Status log`,
and the HTML can never drift out of sync from a hand-edit.

## Acceptance criteria
- [x] The `## Status log` format is defined: `- <UTC ISO-8601 to the minute> — <Status>[ — <note>]`,
  oldest first, first entry always `Created`.
- [x] `set-status.ps1` rewrites the `Status:` line, bumps `Last updated:`, and appends a timestamped
  log entry to the target `CLAUDE.md` in one atomic call.
- [x] After writing, it re-runs `build-pm-html.ps1` so the HTML reflects the change immediately, and
  the generator parses the log into created/started/done timeline chips.

## Tasks
- TASK001 — Define the ## Status log format
- TASK002 — set-status.ps1 (rewrite Status, bump Last updated, append timestamped log)
- TASK003 — Auto-regenerate HTML after a status change
- TASK004 — Created/started/done timeline chips in the generator
- TASK005 — Add Status log to the templates

## Verification
Run `set-status.ps1` on a story to move it to `In progress` then `Done`: confirm the `Status:` and
`Last updated:` lines update, a correctly formatted UTC log line is appended each time (oldest first),
and the sibling `.html` regenerates with created/started/done chips. The status-log standard and the
chips parser in `build-pm-html.ps1`'s `Get-Meta` agree on the dash/format handling.

## Status log
- 2026-06-10T18:15Z — Created
- 2026-06-12T10:30Z — In progress
- 2026-06-12T14:00Z — Done
