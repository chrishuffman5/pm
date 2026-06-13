# TASK002 — Create marketplace.json
**Story:** US10000
**Effort:** S
**Depends on:** TASK001 (same story)

## Objective
Author the single-plugin marketplace catalog so the repo can be added as a marketplace and the
`pm` plugin installed from it.

## Files to create / modify
- `.claude-plugin/marketplace.json` — marketplace metadata plus a `plugins` array with one entry
  for `pm`: its `source` (git URL pointing at the GitHub repo) and a `version` matching
  `plugin.json`.

## Implementation notes
- `source.url` targets `github.com/chrishuffman5/pm.git`; install flow is
  `claude plugin marketplace add chrishuffman5/pm` then `claude plugin install pm@pm`.
- `plugins[0].version` MUST equal `plugin.json`'s `version` — a mismatch makes the marketplace
  advertise a version the installed manifest disagrees with.

## Acceptance criteria
- [x] `marketplace.json` is valid JSON listing exactly one plugin (`pm`).
- [x] `plugins[0].version` matches `plugin.json`'s `version`.

## Out of scope
- Publishing/release mechanics (Feature F1003).
