# US10304 — Publish public repo + marketplace listing
**Feature:** F1003
**Status:** Not started
**Model:** claude-sonnet-4-6
**Depends on:** US10302, US10303
**Last updated:** 2026-06-13

## User value

As a Claude Code user, I want to install the `pm` skill from a public marketplace with a couple of
commands, so that I can adopt it without cloning or hand-wiring anything.

## Acceptance criteria
- [ ] a final review and cleanup pass is complete
- [ ] the repo is flipped public
- [ ] the marketplace install path is verified end-to-end
- [ ] the release is announced / documented

## Tasks
- TASK001 — Final review & cleanup
- TASK002 — Flip the repo public
- TASK003 — Verify marketplace install
- TASK004 — Announce / docs

## Verification

`claude plugin marketplace add chrishuffman5/pm` followed by `claude plugin install pm@pm` succeeds
from a clean machine, the skill loads, and the announcement/docs point at the public repo.

## Status log
- 2026-06-12T16:10Z — Created
