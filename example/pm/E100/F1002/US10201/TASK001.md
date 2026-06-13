# TASK001 — Add -ProjectName / -Lede params
**Story:** US10201
**Effort:** S
**Depends on:** US10200

## Objective
Add `-ProjectName` and `-Lede` parameters to the generator and thread them through to the rendered
title (brand shown across all pages) and the portfolio subtitle.

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — declare the two `param()` entries and substitute them into
  the page `<title>`/header and the `index.html` subtitle.

## Implementation notes
- `-ProjectName` sets the brand/title used on every page; `-Lede` sets the one-line portfolio subtitle.
- HTML-escape both values before inserting them into the markup.

## Acceptance criteria
- [x] Passing `-ProjectName` changes the title/brand across all generated pages.
- [x] Passing `-Lede` changes the portfolio subtitle on `index.html`.

## Out of scope
- Fallback defaults (TASK002).
