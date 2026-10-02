# `plan` mode — Refine an existing PM tree

> **This is the `plan` reference prompt of the `pm` skill.** You're here because the invocation began with `pm plan` (or the request is clearly to refine/groom an existing tree, not build or execute it). Paths below are relative to the `pm` skill's base directory.

Use this for the **planning sessions between scaffolding and execution**: a human and Claude sitting down with an existing `pm/` tree to reshape it — split stories that grew too big, fix a dependency that's wrong, add a feature that emerged, re-balance phases, sharpen vague acceptance criteria, re-check model assignments. The output is a better-shaped tree, not running code.

This mode changes *plans*, not product code. If you find yourself implementing a task, you've crossed into execution — that's the `pm` skill's default mode.

## Ground yourself first — the tree is the source of truth

Before changing anything, read the current state. The tree is self-describing; trust it over your memory of it:

1. **`pm/PLAN.md`** — the feature catalog and the phase/dependency graph (also rendered into the `pm/index.html` dashboard). The big picture.
2. **`pm/E<NNN>/CLAUDE.md`** — the epic charter. It holds the **file templates, numbering scheme, and working agreement** for this tree. Use *these* templates when you add or edit nodes — do not reconstruct them from memory, and do not import a different project's conventions.
3. The specific **feature / story / task** files in scope for this session.

If something in the tree contradicts the repo's root `CLAUDE.md` (the design north star), the root wins — surface the conflict rather than quietly encoding it.

## The cardinal rule: additive, never destructive

IDs (`F1xxx`, `US1xxxx`, `TASK[NNN]`) are referenced as dependencies all over the tree. Renumbering or deleting an ID silently breaks every `Depends on:` line that points at it. So:

- **Add** new features/stories/tasks with the next free ID; never renumber existing ones to "tidy up". Write each new node from the templates in the seeded `pm/E<NNN>/CLAUDE.md` charter — including a `## Status log` seeded with a `- <UTC timestamp> — Created` line, just like `pm init` does.
- When a story must be **split**, keep the original ID for one half and give the new work fresh IDs; update the parent feature's `## Stories` list and any `Depends on:` lines that should now point at the new IDs.
- When work is **dropped**, mark it `Cancelled` (with a reason) rather than deleting the folder, unless the user explicitly wants it gone and you've confirmed nothing depends on it. Use the helper so the cancellation is timestamped in the log: `pwsh -NoProfile -File pm/set-status.ps1 -Path <node>/CLAUDE.md -Status "Cancelled" -Note "<why>"`.

### Moving a story to a different feature (and splitting a feature)

Splitting a feature usually means some of its stories should now live under a **new** feature. The new *feature* gets the next free `F1xxx` ID (its century block is now "taken"), but a **story that moves keeps its original `US1xxxx` ID** — do **not** renumber it to match the new feature's block. Renumbering is exactly what breaks `Depends on:` references, and the ID-encodes-parent convention is only a *birth-time* convenience, not an invariant you may rewrite later. So a moved story whose ID no longer matches its parent's century block is **expected and correct**, not a mistake to fix.

When you move a story `US1xxxx` from `F100a` to `F100b`:

1. Move the story folder (`git mv` so history follows).
2. Update the story's `**Feature:**` line to the new feature ID.
3. Remove it from the old feature's `## Stories` list and add it to the new feature's — keeping its real ID, even though it won't sit in numeric order there.
4. Fix `Depends on:` lines: anything that depended on the moved story still uses its unchanged ID (no edit needed); add the new feature's own `Depends on:` if the split created a feature-level dependency.
5. Only **new** stories created during the split get fresh IDs from the *new* feature's block (`US10b00`, `US10b01`, …).

Add a one-line note in the moved story's `## Status log` (via `set-status.ps1` only if its lifecycle state actually changes; otherwise just note the move in the feature charters) so the reshape is traceable.

This is why a refinement skill exists at all: reshaping a live tree safely takes more care than building a fresh one.

## What a refinement session covers

Pick what the user asked for; you rarely do all of these at once.

- **Scope review** — read a feature/story and check it still matches intent. Tighten or split as needed.
- **Re-decomposition** — a story doing too much becomes several; a feature that's really two becomes two. Re-distribute tasks; keep ACs with the work they verify.
- **Dependency repair** — walk the `Depends on:` lines. Fix wrong ones, add missing ones, and watch for cycles (A→B→A is always a bug). Make sure `PLAN.md`'s phase graph still agrees with the per-file dependencies.
- **Phase re-balancing** — move features between phases when the dependency reality changed. Update `PLAN.md` and each feature's `Phase:` line together.
- **Acceptance-criteria sharpening** — vague ACs cause premature `Done` and rework. Make each one objectively checkable.
- **Model re-assignment** — re-evaluate each story's `**Model:**` against the heuristic (default `claude-sonnet-5-5`; `claude-opus-5-5` for architectural, ambiguous, algorithmic, cross-cutting, or security-sensitive stories; `claude-fable-5-1` reserved for foundational hard-to-reverse, open-ended-correctness, or long-horizon high-coupling stories, or ones that stalled on Opus). A story that grew in scope during refinement may now warrant a higher tier; one that got split into simpler pieces may drop back down. Stories that are already `Done` keep their `Model:` line as the record of what built them — re-evaluate only stories still to be worked. The heuristic and full rationale live in the pm skill's `references/tree-structure.md`.

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

This skill reshapes the *plan*; it does not advance execution state. Leave `Status:` reflecting real work done. The only legitimate status changes here are: newly-added nodes start `Not started` (seeded with a `Created` log entry), and dropped nodes become `Cancelled` (via `set-status.ps1`, which timestamps it). Flipping a story to `In progress`/`Done` is the executing agent's call (the `pm` skill), based on actual code — not something a planning session decides. As in `pm`, never hand-edit a `Status:` line — route status changes through `pm/set-status.ps1` so the log and HTML stay in step.

## Common pitfalls

1. **Renumbering existing IDs.** Breaks dependency references across the whole tree. Only append.
2. **Editing `PLAN.md` or a charter without updating the other.** They're two views of one plan; drift between them misleads every later agent.
3. **Re-decomposing without re-pointing dependencies.** When you split a story, anything that depended on the old scope needs its `Depends on:` updated to the right new ID.
4. **Sharpening ACs into a different scope.** Tightening an AC is good; silently expanding what the story must deliver is scope creep — call it out or make it a new story.
5. **Forgetting to regenerate the HTML tracker** after CLAUDE.md edits, so the tracker misrepresents the freshly-refined plan.
6. **Drifting into implementation.** If you're writing product code, you're in the wrong mode — refinement stops at the plan; switch to the `pm` default (execution) mode.

## The other modes

- **`pm init`** — if there's no tree yet, scaffold one first (it seeds the master templates this mode then reads from the charter).
- **`pm`** (default/execution) — once the plan is settled, build it out: a PM agent spawns Worker agents in git worktrees on each story's assigned model.
