# TASK002 — Spawn agents with no mode hint
**Story:** US10301
**Effort:** M
**Depends on:** TASK001 (same story)

## Objective

Drive each scenario by spawning a real agent against a fresh seeded workspace, deliberately
withholding the mode keyword so the skill must infer the mode from intent alone.

## Files to create / modify
- `test/setup-workspaces.sh` — invoke per-scenario to provision a workspace before each agent run
- `test/RESULTS.md` — capture each agent invocation (prompt, workspace, raw report)

## Implementation notes
- One isolated workspace per scenario so runs cannot interfere.
- Pass only the natural-language request — no `init`/`plan` token — for the inferred-intent
  scenarios; the keyword scenarios pass the token as the first argument.
- Preserve each agent's full report for grading.

## Acceptance criteria
- [x] each scenario runs in its own fresh workspace
- [x] inferred-intent scenarios pass no mode keyword
- [x] every agent's report is captured for grading

## Out of scope
- Judging correctness (TASK003) and the fix/re-run loop (TASK005).
