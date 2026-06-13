# pm skill — invocation test results

Run date: 2026-06-13. Method: 5 independent agents, each given only the skill path and a
natural user prompt (no mode hint), told to follow `SKILL.md`'s own "Pick the mode first"
dispatch and report which mode + reference files it used. Reports were then **graded against
the actual workspace outputs** (not trusted blind).

## Verdict: 5 / 5 PASS — dispatch routes correctly for init, plan, and execute.

| # | Scenario | Expected mode | Mode chosen | Reference read | Output check | Result |
|---|----------|---------------|-------------|----------------|--------------|--------|
| A | `/pm init …` (explicit) | init | **init** | SKILL.md → init.md → tree-structure.md | `pm/PLAN.md` + charter + 3 features / 6 stories / 7 tasks; both scripts installed; 11 HTML pages; all 6 stories carry `Model:` + seeded `## Status log`. Never read plan.md. | ✅ |
| B | "scaffold the PM tree…" (inferred) | init | **init** | SKILL.md → init.md → tree-structure.md | Correctly *inferred* init (no keyword). Full tree, scripts, 11 HTML, 3 feature charters. Never read plan.md. | ✅ |
| C | `/pm plan …` split F1001 (explicit) | plan | **plan** | SKILL.md → plan.md | Added **F1002** with the next free ID; `F1000/F1001/US100xx` all intact (**no renumbering**); `PLAN.md` + charters updated; HTML regenerated. No product code. Never read init.md. | ✅ |
| D | "re-check Opus vs Sonnet" (inferred) | plan | **plan** | SKILL.md → plan.md → tree-structure.md | Correctly inferred plan. Downgraded `US10101` opus→sonnet with rationale; left the `Done` story alone; regenerated HTML via `build-pm-html.ps1` (not set-status — model edit isn't a status change). Did not scaffold. | ✅ |
| E | `/pm` act as PM for F1000 (default) | execute | **execute** | SKILL.md only | **Negative control held**: did not read init.md or plan.md. Verified deps, marked F1000 `In progress` via `set-status.ps1` (timestamped log entry present), laid out the story plan. | ✅ |

## What this proves
- **Explicit keyword routing works** — `init`/`plan` as the first token land on the matching reference prompt (A, C).
- **Inferred routing works** — with no keyword, "scaffold a tree that doesn't exist" → init (B) and "re-evaluate an existing tree, no coding" → plan (D).
- **No false routing** — execute stayed in `SKILL.md` and never pulled in init/plan (E); init never pulled in plan (A, B).
- **The reference prompts are executable** — following them produced a valid tree (init), an additive reshape that respects the no-renumber rule (plan), and a logged status transition (execute).
- **Bundled tooling fires** — `build-pm-html.ps1` ran in all four mutating scenarios; `set-status.ps1` ran in execute and produced a correct timestamped `## Status log` entry.

## Findings / follow-ups (non-blocking)
1. **Moved-story ID convention (C).** When `plan` split F1001 and moved `US10101` under the new `F1002`, the agent kept the ID `US10101` (honoring the cardinal "never renumber" rule) even though the numbering convention would suggest `US102xx` for a story under `F1002`. The agent made the safe call, but `references/plan.md` could state explicitly how to handle *moving* a story across features (keep ID vs. new ID) so the behavior isn't left to judgment.
2. **Seed nicety.** The seed marked `F1000` `In progress` but its status log only had `Created`; the execute agent noticed and added the missing `In progress` entry. Harmless, but `setup-workspaces.sh` could seed that transition via `set-status.ps1` for realism.

## Reproduce
```
bash test/setup-workspaces.sh        # rebuild the 5 workspaces
# then run the 5 prompts in test/SCENARIOS.md as independent agents
```
