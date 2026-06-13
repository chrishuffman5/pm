---
name: pm
description: Work a Rally-style PM tree at pm/E<NNN>/ (Epic → Feature → User Story → Task) — scaffold one, refine one, or execute one with a team of agents. Invoke as `/pm` (execution, the default), `/pm init …` (scaffold a brand-new tree), or `/pm plan …` (refine an existing tree in a planning session). Use this skill whenever someone wants to set up / scaffold / bootstrap a PM tree or PLAN.md, refine / groom / re-decompose / re-prioritize an existing tree, OR work on a feature (F1xxx), pick up a user story (US1xxxx), execute a task (TASK[NNN]), act as project manager, delegate stories to worker agents, update status fields or tick acceptance-criteria checkboxes in pm/E<NNN>/, create or merge git worktrees for parallel story work, surface blockers, or coordinate handoffs between agents. Trigger even when the user only mentions "PM tree", "worktree for a story", "tick the checkboxes", "claim a story", "I'm the pm", "scaffold the epic", or "groom the backlog" — those are signals to follow this skill rather than improvise.
---

# pm — Working a PM tree (scaffold · refine · execute)

This skill works a Rally hierarchy (Epic → Feature → User Story → Task) stored as a tree of `CLAUDE.md` files under `pm/E<NNN>/`. It has **three modes**; pick one before doing anything else.

## Pick the mode first

Look at how the skill was invoked and what's being asked:

| First token of the request | Mode | What to do |
|---|---|---|
| `init` (e.g. `/pm init …`), or "scaffold / bootstrap / set up a new PM tree" when none exists | **init** | Read **`references/init.md`** and follow it. Don't continue in this file. |
| `plan` (e.g. `/pm plan …`), or "refine / groom / re-decompose / re-prioritize" an existing tree | **plan** | Read **`references/plan.md`** and follow it. Don't continue in this file. |
| anything else (default) — "act as pm", "claim a story", "build out F1xxx" | **execute** | Continue in this file — the execution workflow below. |

If the first token is literally `init` or `plan`, treat the rest of the input as that mode's brief. If there's no explicit keyword, infer the mode from intent: a tree that **doesn't exist yet** → init; reshaping a tree that **does** exist (no coding) → plan; **building the tree out** → execute. When genuinely unsure between plan and execute, ask.

The other two modes live in this skill's `references/` so they share the same bundled assets — `scripts/` (`build-pm-html.ps1`, `set-status.ps1`) and `references/tree-structure.md` (the master templates / numbering / model / status-log spec). Everything below is the **execute** mode.

---

# Execute mode — building the tree out with a team of agents

The tree has two roles: a long-running **PM agent** that owns a Feature, and short-lived **Worker agents** that each own one User Story. If the tree doesn't exist yet, switch to **init** mode first; if the plan needs reshaping, switch to **plan** mode. Once a PM starts coding instead of delegating, it has lost the plot.

## What this skill assumes you already know

The hierarchy, file templates, numbering scheme, and the cross-feature "working agreement" are documented in:

- `pm/E<NNN>/CLAUDE.md` — epic charter with the **exact templates** for Feature/Story/Task files (`E100` in most projects). Read this once at the start of any PM-tree session; do not reconstruct the templates from memory. The master copy of those templates is this skill's `references/tree-structure.md`.
- `pm/PLAN.md` — the phase + dependency graph across all features, and the source the portfolio dashboard (`pm/index.html`) is rendered from.

This skill adds what those files do *not* cover: the **runtime workflow** — how PMs and Workers actually coordinate, how worktrees are managed per story, and how status discipline is enforced.

## Tooling — the two scripts, and bootstrapping them

The status and HTML workflow runs through two PowerShell scripts that live **in the target repo** at `pm/build-pm-html.ps1` and `pm/set-status.ps1`. `pm init` installs them there when it scaffolds a tree, so normally they're already present.

If you're executing a tree that lacks them (a hand-built tree, or one created before the tooling existed), install them from this skill's own bundled copies before relying on the status/HTML steps:

```
# from the repo root, copy this skill's bundled scripts into the tree
cp "${CLAUDE_SKILL_DIR}/scripts/build-pm-html.ps1" pm/build-pm-html.ps1
cp "${CLAUDE_SKILL_DIR}/scripts/set-status.ps1"    pm/set-status.ps1
pwsh -NoProfile -File pm/build-pm-html.ps1 -Path pm   # generate the initial tracker
```

`${CLAUDE_SKILL_DIR}` is this skill's own directory, so the copies always resolve regardless of where the plugin is installed. If PowerShell 7+ isn't available at all, fall back to editing `Status:` lines and the `## Status log` by hand (see "Status discipline") — the scripts only automate that bookkeeping; they aren't load-bearing for the actual work.

## Two roles

### PM (Project Manager) — owns one Feature `F1xxx`

A PM is a **long-running Opus 4.8 agent** that:

1. Reads its feature's `pm/E100/F1xxx/CLAUDE.md` in full and confirms feature-level dependencies (`Depends on:`) are `Done`.
2. Iterates through its stories in dependency-respecting order. For each story:
   - Spawns a **Worker** in a dedicated git worktree, briefed with: story ID, story folder path, worktree path, branch name, and the line "you own this story end-to-end".
   - Watches for completion notifications (or polls the story's `CLAUDE.md`/`TASK*.md` files for status changes).
   - When the worker reports done: verifies acceptance-criteria boxes are all ticked, reviews the worker's diff in the worktree (or a PR if pushed), then merges and tears the worktree down.
3. **Owns the status fields on the Feature `CLAUDE.md`** — bumps `Status:` to `In progress` when the first story starts and to `Done` only when every story is `Done`.
4. Escalates to the human when a worker surfaces a blocker the PM cannot resolve itself.

A PM does **not** execute tasks. It coordinates. If a PM starts writing code, it has lost the plot — spawn a Worker.

### Worker — owns one Story `US1xxxx`

A Worker is a single-purpose agent that:

1. Receives a story handoff from a PM (or directly from the user).
2. **Works in a dedicated git worktree** — either the one the PM created, or one the Worker creates itself.
3. Reads `pm/E100/F1xxx/US1xxxx/CLAUDE.md` and every `TASK*.md` in that folder, and confirms story-level dependencies (`Depends on:`) are `Done`.
4. Executes the tasks in order. For each task:
   - Implements the change.
   - Ticks acceptance-criteria checkboxes (`- [ ]` → `- [x]`) **as each is satisfied**, not in a batch at the end.
   - Bumps the task's `Last updated:` if anything material changed.
5. Updates the story `Status:` to `In progress` on claim and `Done` only when **every task's acceptance criteria are ticked**.
6. Surfaces blockers immediately — see "Blocker escalation" below.

A Worker does **not** start a second story. When done, it reports back and exits.

## Git worktree per story — the core mechanic

One story = one worktree = one branch. This is what lets multiple Workers run in parallel on the same Feature without stepping on each other's working trees.

**Naming convention:**

- Branch: `us1xxxx-<kebab-slug>` (e.g., `us10402-williamson-assessor`)
- Worktree path: `../landfinder-us1xxxx` (sibling to the main checkout; keeps the main worktree clean for the PM)

**See `references/worktree.md` for the exact git commands** (create, sync upstream, merge, tear down).

Assumptions:
- The repo's main worktree stays on `main` and is the PM's vantage point.
- Workers never push to `main` directly — they push their branch and the PM merges.
- After merge, the PM removes the worktree and deletes the branch (both local and remote).

## PM playbook

```
1. Confirm I own a Feature.
   - The user said "act as pm for F1xxx", or a prior turn established it.
   - Read pm/E100/F1xxx/CLAUDE.md fully.

2. Verify feature dependencies.
   - For each F-ID on the Depends on: line, confirm that feature's Status: is Done.
   - If not, stop and report — the work is blocked.

3. Set feature Status: to "In progress" — run:
   pwsh -NoProfile -File pm/set-status.ps1 -Path pm/E<NNN>/F1xxx/CLAUDE.md -Status "In progress"
   (this stamps the timestamped Status log entry, bumps Last updated, and regenerates the HTML).

4. Loop over stories in dependency order:
   a. Pick the next story whose Depends on: lines are all Done.
   b. Create the worktree + branch (references/worktree.md).
   c. Read the story's **Model:** line and spawn the Worker on that model — pass it as the
      Agent tool's `model` parameter (e.g. claude-sonnet-4-6 or claude-opus-4-8). If the story
      has no Model: line, default to claude-sonnet-4-6. The model is chosen per story at plan
      time (`pm init` or `pm plan`) precisely so the PM doesn't have to judge complexity at spawn
      time — honor it. Spawn via the Agent tool (or SendMessage if continuing a named worker).
      The brief MUST include:
        - The story ID (US1xxxx) and the absolute path to its folder.
        - The absolute path to the worktree it must work in.
        - The branch name.
        - The line "you own this story end-to-end; follow the pm skill's Worker playbook."
        - Confirmation that every dependency on the story's Depends on: line is Done.
   d. Wait for the worker's completion signal (background agent notification, or a status change in the story file).
   e. Verify: story Status: == Done; every task's acceptance criteria are ticked.
   f. Review the worker's diff in the worktree before merging.
   g. Merge: from the main worktree on `main`, `git merge --ff-only` the branch, then push.
   h. Tear down: remove the worktree, delete the branch locally and remotely.

5. When every story in the feature is Done:
   - Set feature Status: to Done — run:
     pwsh -NoProfile -File pm/set-status.ps1 -Path pm/E<NNN>/F1xxx/CLAUDE.md -Status "Done" -Note "<what closed it>"
   - Report up to the human with a one-paragraph summary.
```

**Parallelism.** A PM may run several Workers in parallel when stories are independent (no shared `Depends on:`). Use background agents and watch completion notifications. Don't exceed ~3 concurrent Workers per Feature — the PM's review queue becomes the bottleneck and worktree directories start to clutter.

## Worker playbook

```
1. I have a story handoff. Read pm/E100/F1xxx/US1xxxx/CLAUDE.md and every TASK*.md in that folder.

2. Verify story dependencies.
   - For each US-ID on the Depends on: line, confirm Status: == Done.
   - If not: surface a blocker (see below). Do not proceed.

3. Set up the worktree (if the PM did not already).
   - See references/worktree.md.
   - cd into the worktree; work there exclusively.

4. Set story Status: to "In progress" — run:
   pwsh -NoProfile -File pm/set-status.ps1 -Path pm/E<NNN>/F1xxx/US1xxxx/CLAUDE.md -Status "In progress" -Note "claimed by <branch>"
   (Run it from the main checkout's pm/ — the script edits the CLAUDE.md and regenerates the
   tracker, both of which live on the shared tree, not inside your worktree's product code.)

5. For each task in order:
   - Implement.
   - Tick acceptance criteria checkboxes (- [ ] -> - [x]) as each is satisfied, then regenerate
     the tracker so it reflects the new AC counts: pwsh -NoProfile -File pm/build-pm-html.ps1 -Path pm
     (ticking a checkbox is not a status change, so it goes through the generator directly, not set-status.ps1).
   - If blocked, see "Blocker escalation".

6. When every task's acceptance criteria are ticked:
   - Set story Status: to "Done" — run:
     pwsh -NoProfile -File pm/set-status.ps1 -Path pm/E<NNN>/F1xxx/US1xxxx/CLAUDE.md -Status "Done"
   - Commit and push the branch.
   - Report completion to the PM (or human if no PM). Include: branch name, worktree path, one-paragraph summary, anything the PM should look at during review.
```

## Status discipline — the contract

Every Feature, Story, and Task file has a `Status:` line and a `Last updated:` line (templates in `pm/E100/CLAUDE.md`). The contract:

| Field | When to bump |
|---|---|
| Story `Status:` | On claim → `In progress`; when every task's ACs are ticked → `Done` |
| Feature `Status:` | First story starts → `In progress`; every story `Done` → `Done` |
| `Last updated:` | Any time the file's substantive content changes |
| Task acceptance criteria `- [ ]` → `- [x]` | The moment that criterion is satisfied — not in a batch at the end |

Why the discipline matters: another agent reading the file later uses `Status:` to decide whether they can depend on this work. A stale `Status:` blocks downstream work even when the underlying code is fine, and a *prematurely* `Done` status causes downstream agents to build on sand.

**Always change `Status:` through `pm/set-status.ps1`, never by hand-editing the line.** The script rewrites `Status:`, bumps `Last updated:`, appends a timestamped entry to the node's `## Status log` (`- <UTC timestamp> — <Status> — <note>`), and regenerates the HTML tracker — all atomically. Three things that must move together, so they can't drift:

```
pwsh -NoProfile -File pm/set-status.ps1 -Path pm/E<NNN>/F1xxx/US1xxxx/CLAUDE.md -Status "In progress" -Note "why"
```

The `## Status log` accumulates the node's whole history — `Created` (stamped by `pm init`) → `In progress` → any intermediate state (`Blocked`) → `Done` — which is the audit trail a PM and the human read to see how a story actually progressed. Use `-Note` to record the *why* of each transition (who claimed it, what blocked it, which PR closed it). If you're making several status changes in a row, pass `-NoHtml` on all but the last to avoid regenerating the tracker repeatedly.

`set-status.ps1` only handles **status** transitions. Ticking acceptance-criteria checkboxes or editing a file's body are not status changes — make those edits directly, then run `pm/build-pm-html.ps1 -Path pm` to refresh the tracker.

## HTML tracker sync — keep `.html` in step with `CLAUDE.md`

Some PM trees ship a **static HTML tracker** mirroring the `CLAUDE.md` files: a sibling `E100.html` / `F1xxx.html` / `US1xxxx.html` next to every `CLAUDE.md`, plus a portfolio `pm/index.html`. The CLAUDE.md tree is the **single source of truth**; the HTML is generated from it, never hand-edited.

**The rule:** any time you change a `Status:` line, tick an acceptance-criteria checkbox, bump `Last updated:`, or otherwise edit a `CLAUDE.md` in the tree, **regenerate the HTML in the same turn** so the tracker never drifts from the files.

How to detect and regenerate:

1. Check for the generator at the pm root: `pm/build-pm-html.ps1` (`pm init` installs it there when it scaffolds a tree; or self-install it per "Tooling — the two scripts, and bootstrapping them").
2. If it exists, after your `CLAUDE.md` edits run:
   ```
   pwsh -NoProfile -File pm/build-pm-html.ps1
   ```
   It rewrites every page and recomputes the parent rollups (a story's status change updates its feature card and the epic/portfolio progress bars). Regenerating the whole tree is cheap — there is no per-file targeted mode and you don't need one.
3. If there is **no** generator in the tree (e.g. a tree that was never set up with the HTML tracker), there is nothing to sync — skip this step.

Never edit a `.html` file by hand: your change would be overwritten on the next regenerate, and the divergence misleads anyone reading the tracker. If the HTML needs to look different, change the generator or the `CLAUDE.md`, then regenerate.

## Blocker escalation

A Worker that hits a real blocker (missing dependency, ambiguous spec, broken external API, scope ambiguity) **must not silently skip or invent answers**. Add a `## Blocker` section to the story's `CLAUDE.md`:

```
## Blocker
**Surfaced at:** <ISO timestamp>
**Description:** <one paragraph: what specifically is blocking>
**Needs from PM/human:** <the specific ask — clarification, dep fix, scope change>
```

Also move the story's status to `Blocked` so the state is visible in the tracker and the transition is timestamped in the log:
```
pwsh -NoProfile -File pm/set-status.ps1 -Path pm/E<NNN>/F1xxx/US1xxxx/CLAUDE.md -Status "Blocked" -Note "<the specific ask>"
```
Then notify the PM via the same channel the PM used to brief you (typically a `SendMessage` to the PM's agent name, or a return message if you were spawned by `Agent`).

The PM either:
- **Resolves it** — clarifies, fixes the dep, narrows the scope.
- **Escalates** — reports to the human and waits.

The Worker pauses until unblocked. When the blocker is resolved, whoever resolved it deletes the `## Blocker` section and returns the story to `In progress` via `set-status.ps1`, and the Worker continues.

## Common pitfalls — avoid these

1. **Working in the main worktree.** Always work in the story's dedicated worktree. The main worktree is the PM's vantage point; uncommitted work there blocks reviews and other merges.
2. **Skipping dependency verification.** "It probably works" is not a substitute for reading the dependency's `Status:`. Stale assumptions cause subtle integration failures that are expensive to unwind.
3. **Batch-ticking checkboxes at the end.** Tick them as you go. If the worker crashes mid-story, the next agent needs to know what's actually done.
4. **A PM that starts coding.** Spawn a Worker. The PM's leverage is delegation, not execution.
5. **A Worker that grabs a second story.** One Worker, one Story. If a story turns out to require new stories, surface that — don't grow scope silently.
6. **Editing the repo root `CLAUDE.md` or `pm/PLAN.md` without explicit user direction.** Those are the design north star and the cross-feature roadmap; the PM tree is where ongoing state lives. (Reshaping `pm/PLAN.md` is `pm plan`'s job, not an execution-time edit.)
7. **`git merge --no-ff` by default.** Prefer fast-forward merges so the PM tree's history reads linearly. Only use `--no-ff` when the user has stated a preference for merge commits.
8. **Forgetting to tear down a merged worktree.** Orphaned worktree dirs and dangling branches pile up across a feature and confuse future agents about what's in progress vs. done.
9. **Editing a `CLAUDE.md` without regenerating the HTML tracker** (when one exists). The sibling `.html` and the portfolio rollups go stale and start lying about progress. Run `pm/build-pm-html.ps1` in the same turn — see "HTML tracker sync".
10. **Hand-editing a generated `.html`.** It's derived output; your edit is lost on the next regenerate. Change the `CLAUDE.md` (or the generator) instead.

## When you finish a turn — quick checklist

- Is every checkbox you ticked actually satisfied?
- If the lifecycle state moved, did you change it via `pm/set-status.ps1` (so the log entry, `Last updated:`, and HTML are all in step)?
- For non-status edits (AC ticks, body changes), did you bump `Last updated:` and regenerate the tracker with `pm/build-pm-html.ps1`?
- If you're a Worker who finished a story, did you push the branch and notify the PM?
- If you're a PM who finished merging, did you remove the worktree and delete the branch (local + remote)?

## The other modes

This file is the **execute** mode. The other two live in `references/` and are entered by the first token of the invocation (or by inferred intent — see "Pick the mode first" at the top):

- **`pm init`** → `references/init.md` — scaffold a PM tree that doesn't exist yet (writes `pm/PLAN.md`, the epic charter, the F/US/TASK skeleton, installs the two helper scripts, assigns each story's `Model:`). If you reached `pm` but there's no `pm/E<NNN>/` tree, you want this first.
- **`pm plan`** → `references/plan.md` — refine an existing tree in a planning session (split stories, repair dependencies, re-phase, re-evaluate model assignments) before or between execution passes.
