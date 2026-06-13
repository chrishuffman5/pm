# TASK001 — Read pm/PLAN.md
**Story:** US10203
**Effort:** S
**Depends on:** US10200

## Objective
Have the generator locate and read `pm/PLAN.md` (the cross-feature roadmap) when present, and parse
it through the existing Markdown→HTML renderer, gracefully skipping when the file is absent.

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — load `PLAN.md` from the `-Path` root and render it with the
  same Markdown subset renderer used for node pages.

## Implementation notes
- Resolve `PLAN.md` relative to the `pm/` tree root passed via `-Path`.
- If `PLAN.md` is missing, produce a valid `index.html` with the Roadmap section omitted — no error.

## Acceptance criteria
- [x] When `pm/PLAN.md` exists its Markdown is read and rendered to HTML.
- [x] When it is absent the generator still completes successfully with the section omitted.

## Out of scope
- Placing the rendered output into index.html (TASK002).
