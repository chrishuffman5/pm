# TASK006 — Offline dark theme/styling
**Story:** US10200
**Effort:** S
**Depends on:** TASK004, TASK005

## Objective
Give all generated pages a polished, dependency-free dark theme: inline CSS for the layout, status
badges, completion bars, checkboxes, and code blocks, so the dashboard looks finished and works fully
offline.

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — inline `<style>` block shared by every emitted page; no
  external stylesheets, fonts, or scripts.

## Implementation notes
- Embed all CSS inline in each page so a single `.html` file is self-sufficient from a file share
  or GitHub Pages.
- Use system font stack and CSS-only progress bars/badges — no web fonts, no CDN, no JS framework.
- Keep status colors consistent with the badges from TASK003.

## Acceptance criteria
- [x] Every generated page renders with the dark theme and zero external network requests.
- [x] Status badges, completion bars, and checkboxes are visually styled and consistent across pages.

## Out of scope
- Timeline chips from the status log (US10202).
