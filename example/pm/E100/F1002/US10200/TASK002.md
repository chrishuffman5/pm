# TASK002 — Markdown→HTML for the template subset
**Story:** US10200
**Effort:** M
**Depends on:** TASK001

## Objective
Convert the Markdown subset the `CLAUDE.md` templates actually use into HTML — headings, ordered
and unordered lists, task-list checkboxes, fenced code blocks, inline code, bold/italic, and links
— without pulling in any external Markdown library.

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — a small in-script Markdown renderer covering the template
  subset and HTML-escaping raw text.

## Implementation notes
- Cover exactly what the templates produce; do not aim for full CommonMark.
- Render `- [ ]` / `- [x]` as styled checkbox list items (consumed by the rollups in TASK003).
- HTML-escape content before applying inline formatting so code and angle brackets render literally.

## Acceptance criteria
- [x] Headings, lists, checkboxes, fenced/inline code, emphasis, and links from a template
  `CLAUDE.md` render correctly.
- [x] Raw text is HTML-escaped so no source character breaks the page.

## Out of scope
- The status-log chip parsing (US10202) and PLAN.md rendering (US10203).
