# `init` mode — Scaffold a new PM tree

> **This is the `init` reference prompt of the `pm` skill.** You're here because the invocation began with `pm init` (or the request is clearly to scaffold a brand-new tree). Follow this procedure, then return to normal work. Paths below are relative to the `pm` skill's base directory.

Turn a design brief into a fully-populated `pm/` tree: a `pm/PLAN.md` roadmap, an epic charter, the Feature → Story → Task folder hierarchy, and a generated HTML tracker. After this runs, the `pm` skill's default (execution) mode can build the tree out and `pm plan` can refine it.

The layout, file templates, numbering scheme, model-assignment rules, working agreement, and HTML-tracker details all live in **`references/tree-structure.md`** — read it once at the start; it is the contract everything downstream depends on. This file is the *procedure* for laying the tree down.

## Before you scaffold: gather the inputs

A PM tree is a decomposition of a design, so you need the design first. Pull these from the repo's root `CLAUDE.md`, an existing brief, or by asking the user:

- **Epic statement** — one paragraph: what the whole thing is and the thesis behind it.
- **Feature list** — the major capabilities, roughly Phase-ordered. If the user only has a vague idea, propose a feature breakdown and confirm it before writing files.
- **Rough story breakdown per feature** — you don't need every task up front, but you need enough to size each feature (how many stories, what each delivers).
- **Dependencies** — which features/stories block which. This drives both `PLAN.md`'s phase graph and the `Depends on:` lines.

Don't invent domain facts to fill gaps. If a feature's scope is genuinely unclear, list it as an open question in the feature charter rather than fabricating acceptance criteria — a confidently-wrong tree is worse than an honestly-incomplete one, because later agents build on it.

## Scaffolding procedure

```
1. Read references/tree-structure.md. Confirm the numbering scheme and templates.

2. Write pm/PLAN.md (inside the pm/ folder — it is rendered into the portfolio dashboard).
   - Epic summary, the feature catalog (table: ID | Feature | Phase | #stories | folder),
     and the phase + dependency graph (which features run in parallel, what blocks what).
   - This is the cross-feature roadmap; the epic charter points back to it.

3. Write pm/E<NNN>/CLAUDE.md — the epic charter.
   - Epic statement, scope, the Rally hierarchy diagram, the numbering scheme,
     the THREE file templates verbatim from references/tree-structure.md, the working
     agreement, and a file-count verification block.
   - This file makes the tree self-describing: an agent dropped into pm/E<NNN>/ with no
     other context can navigate and extend the tree from this charter alone. That is the
     whole point — so copy the templates in fully, don't summarize them.

4. For each feature, create pm/E<NNN>/F1xxx/CLAUDE.md from the Feature template.
   - Fill Purpose / In scope / Out of scope / feature-level ACs / the Stories list /
     design notes / open questions. Set Phase, Status: Not started, Depends on, Last updated.

5. For each story, create pm/E<NNN>/F1xxx/US1xxxx/CLAUDE.md from the Story template.
   - Fill user value, acceptance criteria, the task list, verification.
   - Assign **Model:** per the model-assignment rules (see below).
   - Create at least TASK001.md from the Task template; add more tasks as the story warrants.

   Every feature, story, and the epic charter gets a "## Status log" section seeded with a
   single "- <UTC timestamp> — Created" line (today's date at scaffold time). This is the start
   of the file's timestamped history — see "Status log" in references/tree-structure.md.

6. Install the helper scripts and run the HTML tracker generator (see "HTML tracker" below).

7. Verify (see "Verify the tree" below) and report — including which stories you put on Opus.
```

Scaffolding a large tree is a lot of nearly-identical file writes. That's expected — the value is in getting the *content* (scope, ACs, dependencies, model assignment) right, not in the mechanics. Work feature-by-feature so a partially-built tree is still internally consistent.

## Model assignment — call out the right model per story

Each story's `**Model:**` line tells the `pm` skill which model to spawn its Worker on. Default to **`claude-sonnet-4-6`**; bump to **`claude-opus-4-8`** for stories with architectural decisions, ambiguous acceptance criteria, algorithmic/scoring logic, cross-cutting changes, or security-sensitive work. The task `Effort:` ratings are a good proxy — mostly S/M → Sonnet, several L or a foundational story → Opus. Full rationale and the heuristic are in `references/tree-structure.md`.

Bias toward the Sonnet default — the model isn't load-bearing for correctness (a story that turns out harder than expected can be re-run on Opus), so reserve Opus for stories that genuinely need the extra reasoning. **After scaffolding, list the stories you bumped to Opus** so the user can sanity-check the calls in one place.

## HTML tracker

The tree ships a static HTML mirror generated from the `CLAUDE.md` files. The two helper scripts live at `scripts/` (relative to the `pm` skill base dir). As the initializer, you copy both into the project so the repo has a self-contained generator the execution and refinement modes can re-run:

```
1. Copy scripts/build-pm-html.ps1 to <repo>/pm/build-pm-html.ps1   (the HTML generator)
   Copy scripts/set-status.ps1    to <repo>/pm/set-status.ps1       (the status-change helper)
2. Generate the tracker:
   pwsh -NoProfile -File <repo>/pm/build-pm-html.ps1 -Path <repo>/pm -ProjectName "<Project>" -Lede "<tagline>"
```

`set-status.ps1` is what later agents call to move a node's status — it rewrites `Status:`, stamps the timestamped `## Status log` entry, bumps `Last updated:`, and regenerates the HTML in one atomic call (`pwsh -NoProfile -File pm/set-status.ps1 -Path <node>/CLAUDE.md -Status "In progress"`). Installing it now is what makes that workflow available downstream.

`-ProjectName` brands every page; `-Lede` is the portfolio subtitle. The generator parses each `CLAUDE.md`'s `Status:` and acceptance-criteria checkboxes to compute rollups, so the tracker is only as accurate as the files. `CLAUDE.md` is the single source of truth — never hand-edit the generated `.html`. For the structure and a real example to model output on, see the "HTML tracker" section of `references/tree-structure.md` (`C:\Users\chris\Github\winnie\pm` is a complete reference tree).

## Verify the tree

Before reporting done, run the file-count and structural checks from `references/tree-structure.md`:

- Markdown count = 1 epic charter + (feature charters) + (story charters) + (task files).
- Every `F1xxx/` has a `CLAUDE.md`; every `US1xxxx/` has a `CLAUDE.md` and at least `TASK001.md`.
- Each feature's `## Stories` block enumerates exactly the `US1xxxx/` folders that exist.
- The HTML mirror exists: `index.html` + one `.html` per epic/feature/story node.
- Spot-check that every story has a valid `**Model:**` value and a `## Status log` seeded with a `Created` entry.
- Both helper scripts are installed: `pm/build-pm-html.ps1` and `pm/set-status.ps1`.

## Common pitfalls

1. **Scaffolding before the design is settled.** The tree encodes decisions; if the feature breakdown is still in flux, lock it (or capture the uncertainty as open questions) before writing 300 files you'll have to rewrite.
2. **Summarizing the templates in the charter instead of copying them verbatim.** Later agents reconstruct files from the charter — a paraphrased template breeds drift.
3. **Renumbering to "tidy up".** IDs are cross-referenced as dependencies. Only ever append.
4. **Forgetting to generate the HTML after writing the tree**, leaving an empty/missing tracker that misrepresents a freshly-built plan.
5. **Putting everything on Opus "to be safe".** That's expensive and defeats the point of per-story assignment. Default Sonnet; justify each Opus.
6. **Hand-editing generated `.html`.** It's derived output; change the `CLAUDE.md` and regenerate.

## After init — the other modes

- **`pm plan`** — once the tree exists, refine it: re-decompose stories, repair dependency graphs, re-balance phases, re-evaluate model assignments.
- **`pm`** (default/execution) — build the tree out: a PM agent spawns Worker agents (on each story's assigned model) in git worktrees and merges their work.
