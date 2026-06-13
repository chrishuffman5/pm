# TASK001 — Final review & cleanup
**Story:** US10304
**Effort:** M
**Depends on:** US10302, US10303

## Objective

Do a pre-release sweep: confirm the manifests, versions, and docs are consistent and that no
test/scratch artifacts remain before the repo goes public.

## Files to create / modify
- `.claude-plugin/plugin.json` — verify metadata and `version`
- `.claude-plugin/marketplace.json` — verify catalog entry and matching `version`
- `test/` — confirm only intended fixtures/docs are tracked; run outputs are gitignored

## Implementation notes
- The version appears in both `plugin.json` and `marketplace.json` and the two must match.
- Confirm author/homepage/repository URLs follow the `domain-expert` plugin's shape.

## Acceptance criteria
- [ ] `version` matches across `plugin.json` and `marketplace.json`
- [ ] no scratch/test run artifacts are tracked by git
- [ ] manifest URLs and metadata are correct for a public listing

## Out of scope
- Actually flipping visibility (TASK002).
