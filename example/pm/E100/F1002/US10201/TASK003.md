# TASK003 — Remove hardcoded project branding
**Story:** US10201
**Effort:** S
**Depends on:** TASK001, TASK002

## Objective
Strip every hardcoded project-specific name or tagline out of the generator so the only source of
branding is the `-ProjectName`/`-Lede` params (with their fallbacks).

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — replace any literal project/brand strings with references
  to the parameters.

## Implementation notes
- Grep the script for the original project name and any embedded taglines; route them all through
  the params.
- Confirm a run with no branding args produces generic, project-neutral output.

## Acceptance criteria
- [x] No hardcoded project name or tagline remains in the generator source.
- [x] A run with default params produces project-neutral branding.

## Out of scope
- Theme/layout changes (US10200).
