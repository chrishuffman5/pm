# TASK004 — Capture results (test/RESULTS.md)
**Story:** US10301
**Effort:** S
**Depends on:** TASK003 (same story)

## Objective

Consolidate the runs and grades into a single readable results document that serves as the
validation evidence for the dispatch logic.

## Files to create / modify
- `test/RESULTS.md` — finalize: scenario table, per-scenario grades, findings, and the re-run summary

## Implementation notes
- One row per scenario with expected mode, observed mode, output verdict, and notes.
- Call out findings explicitly so TASK005 has a concrete fix list.
- Include both the initial run and the post-fix re-run so the document tells the whole story.

## Acceptance criteria
- [x] `test/RESULTS.md` summarizes all five scenarios with grades
- [x] findings are listed distinctly from passing results
- [x] both the initial and re-run outcomes are recorded

## Out of scope
- Implementing the fixes (TASK005).
