# US10203 — PLAN.md → dashboard rendering
**Feature:** F1002
**Status:** Done
**Model:** claude-sonnet-4-6
**Depends on:** US10200
**Last updated:** 2026-06-12

## User value
As someone scanning the portfolio dashboard, I want the cross-feature roadmap from `PLAN.md`
embedded right on the index page so that I can read the phase/dependency narrative and the live
status rollups in one place instead of opening a separate Markdown file.

## Acceptance criteria
- [x] `build-pm-html.ps1` reads `pm/PLAN.md` when present and renders its Markdown into the page.
- [x] The rendered roadmap appears as a dedicated Roadmap section of `index.html`.
- [x] `PLAN.md` lives inside `pm/` (relocated there) so the whole tree, scripts, and roadmap are
  self-contained under one folder.

## Tasks
- TASK001 — Read pm/PLAN.md
- TASK002 — Render it as the Roadmap section of index.html
- TASK003 — Relocate PLAN.md into pm/

## Verification
With a `pm/PLAN.md` present, run the generator and confirm `index.html` contains a Roadmap section
rendering the PLAN content. Remove/rename `PLAN.md` and confirm the generator still produces a valid
`index.html` (section omitted, no error). Confirm `PLAN.md` resides under `pm/`, not at the repo root.

## Status log
- 2026-06-10T18:15Z — Created
- 2026-06-12T14:00Z — In progress
- 2026-06-12T15:00Z — Done
