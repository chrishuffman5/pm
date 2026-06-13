# pm skill — invocation test scenarios

Goal: verify the single `pm` skill **dispatches to the correct mode / reference prompt**
when planning (`plan`) or initialization (`init`) is required, and stays in the default
**execute** workflow otherwise.

Each scenario runs an independent agent that is given **only** the skill path and a natural
user request — it is *not* told which mode to use. The agent must let `SKILL.md`'s
"Pick the mode first" logic route it, then report the mode it chose and the reference
file(s) it read. Run `bash test/setup-workspaces.sh` first to build the workspaces.

| # | Workspace | Trigger style | User prompt (abridged) | Expected mode | Expected reference read | Pass criteria |
|---|-----------|---------------|------------------------|---------------|--------------------------|---------------|
| A | `A-init-keyword` | explicit `init` keyword | "**/pm init** — set up a PM tree for TaskTrackr…" | **init** | `references/init.md` (+ `references/tree-structure.md`) | Reads init.md; creates `pm/PLAN.md`, `pm/E100/CLAUDE.md`, ≥2 feature charters, ≥1 story each w/ `Model:` + `## Status log` seeded `Created`; installs both scripts into `pm/`; generates `pm/index.html`. Does NOT read plan.md. |
| B | `B-init-inferred` | inferred (no keyword) | "I'm starting a new project BlogEngine — scaffold the PM tree / epic structure" | **init** | `references/init.md` | Same artifacts as A. Correctly *infers* init from "scaffold … no tree exists". |
| C | `C-plan-keyword` | explicit `plan` keyword | "**/pm plan** — F1001 is too big; split it and fix dependencies" | **plan** | `references/plan.md` | Reads plan.md; reshapes the **existing** tree additively (new IDs, never renumbers); updates `PLAN.md` + affected charters; regenerates HTML. Writes no product code. Does NOT read init.md. |
| D | `D-plan-inferred` | inferred (no keyword) | "review the stories in my pm tree and re-check which should be on Opus" | **plan** | `references/plan.md` | Infers plan; re-evaluates `**Model:**` lines with rationale; updates files + HTML via the tooling. Does NOT scaffold a new tree. |
| E | `E-execute` | default (no init/plan intent) | "**/pm** — act as PM for F1000: verify deps, mark it In progress, lay out the story plan" | **execute** | none (stays in `SKILL.md`); may read `references/worktree.md` | Stays in execute mode; does NOT read init.md or plan.md; changes status via `pm/set-status.ps1` (timestamped log entry appears); produces a PM plan. Negative control for mis-dispatch. |

## What we're really checking
1. **Routing correctness** — does the first token / inferred intent land on the right reference prompt? (A,B → init; C,D → plan; E → neither.)
2. **No false routing** — execute must not pull in init/plan; init must not pull in plan; etc.
3. **The reference prompt actually works** — following it produces the right artifacts (valid tree for init; additive reshape for plan; status transition for execute).
4. **Tooling fires** — `build-pm-html.ps1` / `set-status.ps1` are found and run from the seeded `pm/`.

Results of a run are summarized in `RESULTS.md`.
