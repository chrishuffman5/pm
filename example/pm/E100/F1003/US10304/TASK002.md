# TASK002 — Flip the repo public
**Story:** US10304
**Effort:** S
**Depends on:** TASK001 (same story)

## Objective

Change the repository visibility to public so the marketplace `source.url` resolves for anyone.

## Files to create / modify
- `.claude-plugin/marketplace.json` — confirm `source.url` points at the public repo URL
- (repo settings) — flip visibility to public via the gh CLI

## Implementation notes
- Use `gh repo edit --visibility public` (with the confirmation flag the CLI requires).
- Ensure GitHub Pages (US10302) remains served after the visibility change.

## Acceptance criteria
- [ ] the repo is public
- [ ] `marketplace.json` `source.url` resolves to the public repo
- [ ] the Pages dashboard is still reachable post-flip

## Out of scope
- Verifying the install flow (TASK003).
