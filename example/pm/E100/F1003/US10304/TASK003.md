# TASK003 — Verify marketplace install
**Story:** US10304
**Effort:** S
**Depends on:** TASK002 (same story)

## Objective

Confirm the published plugin installs cleanly via the documented marketplace commands from a clean
environment.

## Files to create / modify
- `.claude-plugin/marketplace.json` — referenced to confirm the install identifiers match the docs

## Implementation notes
- Run `claude plugin marketplace add chrishuffman5/pm` then `claude plugin install pm@pm`.
- Verify the `pm` skill is discovered and loads in a fresh Claude Code session (changes take effect
  next session, not the running one).

## Acceptance criteria
- [ ] `marketplace add` + `install pm@pm` succeed from a clean machine
- [ ] the `pm` skill loads and is invocable as `/pm`
- [ ] the installed manifest version matches the marketplace listing

## Out of scope
- Announcement and docs (TASK004).
