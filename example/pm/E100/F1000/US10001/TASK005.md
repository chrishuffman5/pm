# TASK005 — Write references/tree-structure.md master reference
**Story:** US10001
**Effort:** L
**Depends on:** TASK001 (same story) ; TASK002 (same story) ; TASK003 (same story) ; TASK004 (same story)

## Objective
Assemble the directory layout, numbering, templates, model heuristic, status-log standard,
working agreement, HTML-tracker structure, and file-count verification into one coherent
`tree-structure.md` — the canonical contract every later mode and agent depends on.

## Files to create / modify
- `skills/pm/references/tree-structure.md` — the complete master reference document.

## Implementation notes
- This is the single home for templates: `init` writes them into a target repo; `execute`/`plan`
  read the seeded copy. A template change always starts here.
- Include the directory-layout diagram and the file-count verification formulas so a scaffolded
  tree can be checked for completeness.

## Acceptance criteria
- [x] `tree-structure.md` is internally consistent and self-contained as the templates' one home.
- [x] It includes layout, numbering, templates, model heuristic, status-log spec, working
  agreement, and HTML-tracker structure.

## Out of scope
- Mode-specific reference prompts `init.md` / `plan.md` (Feature F1001).
