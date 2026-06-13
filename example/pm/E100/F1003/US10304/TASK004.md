# TASK004 — Announce / docs
**Story:** US10304
**Effort:** S
**Depends on:** TASK003 (same story)

## Objective

Publish the release-facing documentation and announcement so users can find, install, and
understand the skill, with the live dashboard as the showcase.

## Files to create / modify
- `README.md` — install instructions, the three modes, and a link to the Pages dashboard
- `.claude-plugin/marketplace.json` — confirm listing copy matches the README

## Implementation notes
- Lead with the `marketplace add` + `install pm@pm` commands and the `/pm`, `/pm init`, `/pm plan`
  invocations.
- Link the GitHub Pages example dashboard as the clickable reference shape.

## Acceptance criteria
- [x] the README documents install and all three modes
- [x] the announcement/docs link the live Pages dashboard
- [x] listing copy and README are consistent

## Out of scope
- Any further feature work; this closes the release feature.
