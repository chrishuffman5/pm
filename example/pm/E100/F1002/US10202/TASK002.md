# TASK002 — set-status.ps1 (rewrite Status, bump Last updated, append timestamped log)
**Story:** US10202
**Effort:** M
**Depends on:** TASK001

## Objective
Write `set-status.ps1`: given a target `CLAUDE.md` and a new status, atomically rewrite the
`**Status:**` line, bump `**Last updated:**`, and append a correctly formatted timestamped entry to
the `## Status log` — so the three fields can never drift from a hand-edit.

## Files to create / modify
- `skills/pm/scripts/set-status.ps1` — the status-change helper (params for the target file, new
  status, and an optional note).

## Implementation notes
- Stamp the log entry with the current UTC time to the minute, matching the TASK001 format.
- Accept an optional note appended after the status.
- Rewrite in place; preserve the rest of the file untouched.

## Acceptance criteria
- [x] Running the helper rewrites `Status:`, bumps `Last updated:`, and appends one well-formed log line.
- [x] An optional note is recorded on the appended entry when supplied.

## Out of scope
- HTML regeneration (TASK003) and the generator's chip rendering (TASK004).
