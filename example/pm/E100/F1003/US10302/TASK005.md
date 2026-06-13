# TASK005 — Enable GitHub Pages via gh CLI
**Story:** US10302
**Effort:** S
**Depends on:** TASK004 (same story)

## Objective

Turn on GitHub Pages for the repo via the `gh` CLI and confirm the published dashboard is reachable.

## Files to create / modify
- `.claude-plugin/` — not modified; referenced only to confirm repo/homepage URLs align with the Pages URL

## Implementation notes
- Use `gh api`/`gh` to enable Pages from the chosen branch/path.
- Verify the live URL serves the redirect and the example dashboard once propagation completes.

## Acceptance criteria
- [ ] GitHub Pages is enabled for the repo via the gh CLI
- [ ] the published URL serves the dashboard (redirect resolves to the example tree)
- [ ] node pages load without a build step

## Out of scope
- Generating the HTML (TASK003) and the redirect/.nojekyll files (TASK004).
