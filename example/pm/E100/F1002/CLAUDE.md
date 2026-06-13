# F1002 — Tooling & status tracking
**Phase:** 2
**Status:** Done
**Depends on:** F1000
**Last updated:** 2026-06-12

## Purpose
Build the self-contained tooling the PM tree ships with: a static HTML tracker generator
(`build-pm-html.ps1`) that parses the `CLAUDE.md` tree into a dependency-free dashboard, and a
status-log helper (`set-status.ps1`) that makes every status change atomic — rewrite `Status:`,
bump `Last updated:`, append a timestamped `## Status log` entry, and regenerate the HTML in one
call. Round it out by rendering `pm/PLAN.md` into the portfolio page so the roadmap and the live
rollups sit on one dashboard.

## In scope
- `skills/pm/scripts/build-pm-html.ps1` — walks the `pm/E<NNN>` tree, renders the template
  Markdown subset to HTML, rolls up status and acceptance-criteria progress, and emits a
  portfolio `index.html` plus a page per epic/feature/story.
- An offline, dependency-free dark theme for the generated pages.
- `-ProjectName` / `-Lede` parameters so the generator carries no hardcoded branding.
- The `## Status log` format standard and `skills/pm/scripts/set-status.ps1`, which writes it
  atomically and re-runs the generator.
- Created/started/done timeline chips derived from the status log.
- Reading `pm/PLAN.md` and embedding it as the Roadmap section of `index.html`.

## Out of scope
- The lifecycle mode workflows that *call* this tooling (Feature F1001).
- The Epic/Feature/Story/Task templates and numbering the generator parses (Feature F1000).
- Agent-driven validation and the public release (Feature F1003).

## Acceptance criteria (feature-level)
- [x] `build-pm-html.ps1` emits a portfolio `index.html` plus one page per epic/feature/story node.
- [x] `set-status.ps1` stamps a timestamped status-log entry, rewrites `Status:`/`Last updated:`, and regenerates the HTML in one call.
- [x] `pm/PLAN.md` renders into the portfolio page as the Roadmap section.

## Stories
- US10200 — HTML tracker generator (build-pm-html.ps1) — Status: Done
- US10201 — Parameterize generator branding — Status: Done
- US10202 — Status-log standard + set-status.ps1 — Status: Done
- US10203 — PLAN.md → dashboard rendering — Status: Done

## Key design notes
- `CLAUDE.md` is always the single source of truth; the HTML is derived and never hand-edited,
  so the generator can be re-run idempotently at any time.
- The generator and the helper share one contract: the `## Status log` format. `set-status.ps1`
  writes it; `build-pm-html.ps1`'s `Get-Meta` parses it (tolerating `-`, en-, and em-dashes) into
  created/started/done chips. Change one side and the other must follow.
- The tooling is fully offline — no CDN, no JS framework, inline CSS — so a tree clicks through
  from a file share or GitHub Pages with zero install.
- Branding is parameterized (`-ProjectName`, `-Lede`) with sensible fallbacks (repo folder name /
  generic tagline) so the generator is reusable across any project, not just this one.

## Open questions
- None remaining — all resolved during the build (see story notes).

## Status log
- 2026-06-10T18:15Z — Created
- 2026-06-11T10:00Z — In progress
- 2026-06-12T15:00Z — Done
