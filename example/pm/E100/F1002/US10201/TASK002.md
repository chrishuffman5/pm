# TASK002 — Default ProjectName to the repo folder name
**Story:** US10201
**Effort:** S
**Depends on:** TASK001

## Objective
Make the branding params optional: when `-ProjectName` is omitted, default it to the name of the
repo/parent folder of the `pm/` tree; when `-Lede` is omitted, fall back to a generic tagline.

## Files to create / modify
- `skills/pm/scripts/build-pm-html.ps1` — fallback logic deriving `ProjectName` from the parent
  directory of `-Path` and a default `Lede` string.

## Implementation notes
- Resolve the parent folder name of the `pm/` directory passed via `-Path` for the default brand.
- Keep the fallback purely local — no environment or git lookups required.

## Acceptance criteria
- [x] Omitting `-ProjectName` yields the repo/parent folder name as the title.
- [x] Omitting `-Lede` yields a sensible generic subtitle.

## Out of scope
- Removing leftover hardcoded branding (TASK003).
