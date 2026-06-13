# US10303 — Description-trigger optimization
**Feature:** F1003
**Status:** Not started
**Model:** claude-sonnet-4-6
**Depends on:** US10301
**Last updated:** 2026-06-13

## User value

As a user, I want `/pm` to fire when I describe a PM-tree task in my own words and stay silent when
I don't, so that the skill triggers reliably across all three modes without false positives.

## Acceptance criteria
- [ ] a should/should-not trigger eval set exists
- [ ] an optimization loop measures and improves trigger accuracy
- [ ] the best `description` front-matter is applied to the skill

## Tasks
- TASK001 — Build a should/should-not trigger eval set
- TASK002 — Run the optimization loop
- TASK003 — Apply the best description

## Verification

Against the eval set, the chosen `description` triggers on all should-fire prompts (covering
scaffold/refine/execute phrasings) and on none of the should-not prompts.

## Status log
- 2026-06-12T16:10Z — Created
