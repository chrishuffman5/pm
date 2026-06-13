# US10201 — Parameterize generator branding
**Feature:** F1002
**Status:** Done
**Model:** claude-sonnet-4-6
**Depends on:** US10200
**Last updated:** 2026-06-12

## User value
As a user running the generator on my own project, I want the title and subtitle to reflect my
project rather than hardcoded branding so that the dashboard reads as mine and the generator is
reusable across any repo, not just the one it was first written in.

## Acceptance criteria
- [x] `build-pm-html.ps1` accepts `-ProjectName` and `-Lede` parameters that set the brand/title
  and the portfolio subtitle across all generated pages.
- [x] When `-ProjectName` is omitted it defaults to the repo (target) folder name; `-Lede` falls
  back to a generic tagline.
- [x] No project-specific branding strings remain hardcoded anywhere in the generator.

## Tasks
- TASK001 — Add -ProjectName / -Lede params
- TASK002 — Default ProjectName to the repo folder name
- TASK003 — Remove hardcoded project branding

## Verification
Run the generator with `-ProjectName "Acme"` and `-Lede "roadmap"` and confirm both appear across
`index.html` and the node pages. Run it again with no branding params and confirm the title falls
back to the `pm` parent folder name and a generic subtitle. Grep the script for any leftover
hardcoded project name — there should be none.

## Status log
- 2026-06-10T18:15Z — Created
- 2026-06-12T09:00Z — In progress
- 2026-06-12T10:30Z — Done
