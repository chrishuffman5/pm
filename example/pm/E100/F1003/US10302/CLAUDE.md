# US10302 — Example project + GitHub Pages dashboard
**Feature:** F1003
**Status:** In progress
**Model:** claude-sonnet-4-6
**Depends on:** US10301
**Last updated:** 2026-06-13

## User value

As a prospective user, I want to click through a finished `pm` tree on a public dashboard without
installing anything, so that I can see the exact shape, templates, and status discipline the skill
produces before I adopt it.

## Acceptance criteria
- [x] a meta example is designed: the skill's own build journey as a PM tree
- [x] `example/pm/` is scaffolded via init mode following the canonical templates
- [x] the HTML tracker is generated for the example tree
- [ ] a root redirect and `.nojekyll` are in place for Pages serving
- [ ] GitHub Pages is enabled and serving the dashboard live

## Tasks
- TASK001 — Design the meta example (this tree)
- TASK002 — Scaffold example/pm via init mode
- TASK003 — Generate the HTML tracker
- TASK004 — Root redirect + .nojekyll
- TASK005 — Enable GitHub Pages via gh CLI

## Verification

The example tree mirrors the real build phases and renders correctly; once Pages is live, the
published URL serves `example/pm/index.html` and every node page loads without a build step.

## Status log
- 2026-06-12T16:10Z — Created
- 2026-06-13T13:00Z — In progress
