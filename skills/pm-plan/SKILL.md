---
name: pm-plan
description: Refine an existing Rally-style PM tree (Epic → Feature → User Story → Task) during a planning or grooming session — review and reshape it, don't build it from scratch and don't spawn agents to execute it. Use this whenever someone wants to "refine the plan", "review the epics/features/stories", "groom the backlog", "re-decompose this feature", "split this story", "add a feature/story to the tree", "fix the dependency graph", "re-balance the phases", "re-prioritize", "tighten up the acceptance criteria", or "re-check which stories should be on Opus". This is the iterate-on-what-exists skill; if there is no tree yet use pm-init to scaffold one, and if the plan is settled and you want to execute stories with a team of agents use pm.
---

# pm-plan — Refine an existing PM tree

Use this skill for the **planning sessions between scaffolding and execution**: a human and Claude sitting down with an existing `pm/` tree to reshape it — split stories that grew too big, fix a dependency that's wrong, add a feature that emerged, re-balance phases, sharpen vague acceptance criteria, re-check model assignments. The output is a better-shaped tree, not running code.

This skill changes *plans*, not product code. If you find yourself implementing a task, you've crossed into execution — that's the `pm` skill's job.

## Ground yourself first — the tree is the source of truth

Before changing anything, read the current state. The tree is self-describing; trust it over your memory of it:

1. **`PLAN.md`** (repo root) — the feature catalog and the phase/dependency graph. The big picture.
2. **`pm/E<NNN>/CLAUDE.md`** — the epic charter. It holds the **file templates, numbering scheme, and working agreement** for this tree. Use *these* templates when you add or edit nodes — do not reconstruct them from memory, and do not import a different project's conventions.
3. The specific **feature / story / task** files in scope for this session.

If something in the tree contradicts the repo's root `CLAUDE.md` (the design north star), the root wins — surface the conflict rather than quietly encoding it.

## The cardinal rule: additive, never destructive

IDs (`F1xxx`, `US1xxxx`, `TASK[NNN]`) are referenced as dependencies all over the tree. Renumbering or deleting an ID silently breaks every `Depends on:` line that points at it. So:

- **Add** new features/stories/tasks with the next free ID; never renumber existing ones to "tidy up". Write each new node from the templates in the seeded `pm/E<NNN>/CLAUDE.md` charter — including a `## Status log` seeded with a `- <UTC timestamp> — Created` line, just like pm-init does.
- When a story must be **split**, keep the original ID for one half and give the new work fresh IDs; update the parent feature's `## Stories` list and any `Depends on:` lines that should now point at the new IDs.
- When work is **dropped**, mark it `Cancelled` (with a reason) rather than deleting the folder, unless the user explicitly wants it gone and you've confirmed nothing depends on it. Use the helper so the cancellation is timestamped in the log: `pwsh -NoProfile -File pm/set-status.ps1 -Path <node>/CLAUDE.md -Status "Cancelled" -Note "<why>"`.

This is why a refinement skill exists at all: reshaping a live tree safely takes more care than building a fresh one.

## What a refinement session covers

Pick what the user asked for; you rarely do all of these at once.

- **Scope review** — read a feature/story and check it still matches intent. Tighten or split as needed.
- **Re-decomposition** — a story doing too much becomes several; a feature that's really two becomes two. Re-distribute tasks; keep ACs with the work they verify.
- **Dependency repair** — walk the `Depends on:` lines. Fix wrong ones, add missing ones, and watch for cycles (A→B→A is always a bug). Make sure `PLAN.md`'s phase graph still agrees with the per-file dependencies.
- **Phase re-balancing** — move features between phases when the dependency reality changed. Update `PLAN.md` and each feature's `Phase:` line together.
- **Acceptance-criteria sharpening** — vague ACs cause premature `Done` and rework. Make each one objectively checkable.
- **Model re-assignment** — re-evaluate each story's `**Model:**` against the heuristic (default `claude-sonnet-4-6`; `claude-opus-4-8` for architectural, ambiguous, algorithmic, cross-cutting, or security-sensitive stories). A story that grew in scope during refinement may now warrant Opus; one that got split into simpler pieces may drop back to Sonnet. The heuristic and full rationale live in the `pm-init` skill's `references/tree-structure.md`.

## Keep the three views in step — every turn

A refinement that updates one view and not the others leaves the tree lying about itself. Whenever you change the tree:

1. **`PLAN.md` ↔ the charters.** If you re-phase or add/remove a feature, update both the `PLAN.md` catalog/graph and the affected `CLAUDE.md` files in the same turn.
2. **Feature `## Stories` list ↔ the actual `US1xxxx/` folders.** They must enumerate exactly the same set.
3. **`Last updated:`** — bump it on every file whose substantive content you changed.
4. **The HTML tracker.** If `pm/build-pm-html.ps1` exists, regenerate after editing any `CLAUDE.md`:
   ```
   pwsh -NoProfile -File pm/build-pm-html.ps1 -Path <repo>/pm
   ```
   This recomputes the rollups (a re-phased feature moves on the epic page; a split story changes the counts) so the tracker never drifts from the files. `CLAUDE.md` is the single source of truth — never hand-edit the `.html`. If there's no generator in the tree, skip this.

## Don't touch status to fake progress

`pm-plan` reshapes the *plan*; it does not advance execution state. Leave `Status:` reflecting real work done. The only legitimate status changes here are: newly-added nodes start `Not started` (seeded with a `Created` log entry), and dropped nodes become `Cancelled` (via `set-status.ps1`, which timestamps it). Flipping a story to `In progress`/`Done` is the executing agent's call (the `pm` skill), based on actual code — not something a planning session decides. As in `pm`, never hand-edit a `Status:` line — route status changes through `pm/set-status.ps1` so the log and HTML stay in step.

## Common pitfalls

1. **Renumbering existing IDs.** Breaks dependency references across the whole tree. Only append.
2. **Editing `PLAN.md` or a charter without updating the other.** They're two views of one plan; drift between them misleads every later agent.
3. **Re-decomposing without re-pointing dependencies.** When you split a story, anything that depended on the old scope needs its `Depends on:` updated to the right new ID.
4. **Sharpening ACs into a different scope.** Tightening an AC is good; silently expanding what the story must deliver is scope creep — call it out or make it a new story.
5. **Forgetting to regenerate the HTML tracker** after CLAUDE.md edits, so the tracker misrepresents the freshly-refined plan.
6. **Drifting into implementation.** If you're writing product code, switch to the `pm` skill — refinement stops at the plan.

## Related skills

- **pm-init** — if there's no tree yet, scaffold one first (it owns the master templates this skill reads from the seeded charter).
- **pm** — once the plan is settled, execute it: a PM agent spawns Worker agents in git worktrees to build the stories out, on each story's assigned model.
