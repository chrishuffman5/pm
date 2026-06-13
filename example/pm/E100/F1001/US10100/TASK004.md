# TASK004 — Status discipline through set-status.ps1

**Story:** US10100
**Effort:** S
**Depends on:** none

## Objective

Document the status-discipline contract in `SKILL.md`: which fields move when, and the rule that
every `Status:` transition goes through `set-status.ps1` (never a hand-edit) so that `Status:`,
`Last updated:`, the timestamped `## Status log` entry, and the HTML tracker all move together and
can't drift.

## Files to create / modify

- `skills/pm/SKILL.md` — add the "Status discipline — the contract" section: the field/when table,
  the set-status.ps1 invocation, the `## Status log` accumulation rule, and the HTML-sync note.

## Implementation notes

- Distinguish status changes (route through `set-status.ps1`) from non-status edits like ticking
  ACs or editing the body (edit directly, then run `build-pm-html.ps1`).
- Note `-Note` records the *why* of each transition and `-NoHtml` on all-but-the-last when making
  several changes in a row.
- Explain *why* it matters: a stale or premature `Status:` misleads downstream agents about what
  they can depend on.

## Acceptance criteria

- [x] `SKILL.md` documents which Story/Feature/`Last updated:` fields move when.
- [x] It mandates routing status changes through `set-status.ps1` and explains why hand-editing causes drift.

## Out of scope

- The implementation of `set-status.ps1` itself (F1002 tooling).
