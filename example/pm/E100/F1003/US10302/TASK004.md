# TASK004 — Root redirect + .nojekyll
**Story:** US10302
**Effort:** S
**Depends on:** TASK003 (same story)

## Objective

Make the generated dashboard servable by GitHub Pages: add a root redirect to the example
dashboard and a `.nojekyll` marker so Pages serves the static files verbatim.

## Files to create / modify
- `index.html` — root redirect pointing at `example/pm/index.html`
- `.nojekyll` — disable Jekyll processing so files under-scored/dotted paths serve as-is

## Implementation notes
- A minimal meta-refresh / link redirect at the repo root is enough.
- `.nojekyll` prevents Pages from running the Jekyll pipeline over the static HTML.

## Acceptance criteria
- [ ] a root `index.html` redirects to the example dashboard
- [ ] `.nojekyll` exists at the served root
- [ ] the static HTML is served unmodified (no Jekyll transformation)

## Out of scope
- Turning on the Pages site itself (TASK005).
