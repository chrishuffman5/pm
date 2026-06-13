# US10200 — HTML tracker generator (build-pm-html.ps1)
**Feature:** F1002
**Status:** Done
**Model:** claude-opus-4-8
**Depends on:** none
**Last updated:** 2026-06-11

## User value
As someone working a PM tree, I want a static HTML dashboard generated from the `CLAUDE.md`
files so that I can click through the epic, its features, and their stories — with status and
acceptance-criteria rollups — without installing anything or reading raw Markdown.

## Acceptance criteria
- [x] The generator walks the `pm/E<NNN>` tree and discovers every epic/feature/story node from
  its `CLAUDE.md`, parsing `Status:` and acceptance-criteria checkboxes for rollups.
- [x] It emits a portfolio `index.html` plus one `.html` page per epic, feature, and story,
  each a sibling of its `CLAUDE.md`.
- [x] Pages render the template's Markdown subset (headings, lists, checkboxes, code, emphasis)
  and ship as a self-contained offline dark theme — no external CSS/JS/CDN.

## Tasks
- TASK001 — Walk the pm/E<NNN> tree
- TASK002 — Markdown→HTML for the template subset
- TASK003 — Status + acceptance-criteria rollups
- TASK004 — Per-node pages (epic/feature/story)
- TASK005 — Portfolio index.html
- TASK006 — Offline dark theme/styling

## Verification
Run `pwsh -NoProfile -File pm/build-pm-html.ps1 -Path pm` against a populated tree: confirm an
`index.html` appears at the root and one `.html` sits beside every epic/feature/story `CLAUDE.md`.
Open `index.html` offline (disconnected) and confirm styling, navigation, and rollups render with
no network requests. Story rollups match the ticked-AC counts in the underlying `CLAUDE.md` files.

## Status log
- 2026-06-10T18:15Z — Created
- 2026-06-11T10:00Z — In progress
- 2026-06-11T15:00Z — Done
