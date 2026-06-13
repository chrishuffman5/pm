# US10002 — Author the triggering description & conventions
**Feature:** F1000
**Status:** Done
**Model:** claude-sonnet-4-6
**Depends on:** US10001
**Last updated:** 2026-06-10

## User value
As a user who types `/pm`, `/pm init`, or `/pm plan`, I want the skill's single `description` to
reliably fire across all three modes' phrasings so that the skill triggers regardless of which
mode I intend, then dispatches internally by the first token.

## Acceptance criteria
- [x] `SKILL.md` front-matter `description` covers scaffold/bootstrap, refine/groom, and
  execute/claim-a-story trigger phrases for all three modes.
- [x] `SKILL.md` follows progressive disclosure: mode dispatch up front, detail deferred to
  `references/*.md`.
- [x] Author block, naming, and the no-`skills`-field convention align with the `domain-expert`
  plugin's shape.

## Tasks
- TASK001 — Write the skill description trigger phrases
- TASK002 — Apply progressive-disclosure structure
- TASK003 — Align with domain-expert plugin conventions

## Verification
The `description` mentions all three modes' vocabulary; `SKILL.md` opens with the mode-pick table
and points at `references/init.md` / `references/plan.md` rather than inlining them; the manifest
and front-matter match the `domain-expert` conventions. The skill triggers on representative
prompts for each mode.

## Status log
- 2026-06-09T15:40Z — Created
- 2026-06-10T09:00Z — In progress
- 2026-06-10T11:00Z — Done
