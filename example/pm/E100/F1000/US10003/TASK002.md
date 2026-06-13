# TASK002 — gh repo create (private)
**Story:** US10003
**Effort:** S
**Depends on:** TASK001 (same story)

## Objective
Create a private GitHub repository for the plugin and wire it up as the local repo's `origin`
remote.

## Files to create / modify
- (remote) — `gh repo create chrishuffman5/pm --private` and set `origin`.

## Implementation notes
- Private first; the public release and marketplace listing come later (Feature F1003).
- The remote URL must match `marketplace.json`'s `source.url` (`github.com/chrishuffman5/pm.git`).

## Acceptance criteria
- [x] A private GitHub repo exists for the plugin.
- [x] `origin` points at that repo.

## Out of scope
- Pushing and verification (TASK003).
