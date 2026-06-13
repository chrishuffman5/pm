# TASK002 — Render it as the Roadmap section of index.html
**Story:** US10203
**Effort:** S
**Depends on:** TASK001

## Objective
Embed the rendered `PLAN.md` as a dedicated Roadmap section of the portfolio `index.html`, sitting
alongside the epic list and overall completion bar so the roadmap and live rollups share one page.

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — insert the rendered PLAN HTML into the `index.html`
  Roadmap slot left open by US10200's TASK005.

## Implementation notes
- Wrap the rendered content in a clearly labeled "Roadmap" section using the shared theme styles.
- Keep the section consistent with the rest of the portfolio page layout.

## Acceptance criteria
- [x] `index.html` contains a Roadmap section rendering the `PLAN.md` content.
- [x] The section is styled consistently with the rest of the portfolio page.

## Out of scope
- Relocating PLAN.md (TASK003).
