# US10301 — Agent-driven mode-dispatch tests
**Feature:** F1003
**Status:** Done
**Model:** claude-opus-4-8
**Depends on:** US10300
**Last updated:** 2026-06-13

## User value

As a skill maintainer, I want real agents to invoke `/pm` with no mode hint across a set of
scenarios and have their output graded against the actual filesystem, so that I have evidence the
dispatch logic picks the right mode (init / plan / execute) from intent — not just from keywords.

## Acceptance criteria
- [x] five scenarios cover init / plan / execute across keyword and inferred phrasing
- [x] agents are spawned with no explicit mode hint to test inferred dispatch
- [x] each agent's report is graded against the resulting filesystem state
- [x] `test/RESULTS.md` records the runs, grades, and findings
- [x] findings are fixed (moved-story rule) and the suite re-run clean

## Tasks
- TASK001 — Define 5 dispatch scenarios (init/plan/execute, keyword + inferred)
- TASK002 — Spawn agents with no mode hint
- TASK003 — Grade reports against the filesystem
- TASK004 — Capture results (test/RESULTS.md)
- TASK005 — Fix findings (moved-story rule) and re-run

## Verification

Read `test/RESULTS.md`: all five scenarios dispatched to the intended mode, every agent report
matches the on-disk tree it produced, and the post-fix re-run is green with the moved-story rule
correctly applied.

## Status log
- 2026-06-12T16:10Z — Created
- 2026-06-13T10:30Z — In progress
- 2026-06-13T12:00Z — Done
