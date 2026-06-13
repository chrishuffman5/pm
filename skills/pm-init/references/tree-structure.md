# PM tree — structure, templates, numbering (master reference)

This is the **canonical source** for the PM-tree layout, the file templates, and the numbering scheme. `pm-init` writes these into a target repo; once seeded, the `pm` (execution) and `pm-plan` (refinement) skills read the *seeded* copies from the target repo, not this file. So treat what you write here as the contract every later agent depends on.

## Directory layout

A PM tree lives under `pm/` at the repo root. One epic per `E<NNN>` folder; the typical project has exactly one epic.

```
<repo>/
├── PLAN.md                               ← cross-feature roadmap: feature catalog + phase/dependency graph
└── pm/
    ├── build-pm-html.ps1                 ← HTML tracker generator (pm-init installs this)
    ├── set-status.ps1                    ← status-change helper (pm-init installs this)
    ├── index.html                        ← portfolio page (generated)
    └── E100/                             ← Epic
        ├── CLAUDE.md                     ← epic charter (templates + numbering + working agreement live here)
        ├── E100.html                     ← generated
        ├── F1000/                        ← Feature
        │   ├── CLAUDE.md                 ← feature charter
        │   ├── F1000.html                ← generated
        │   ├── US10000/                  ← User Story
        │   │   ├── CLAUDE.md             ← story context
        │   │   ├── US10000.html          ← generated
        │   │   ├── TASK001.md            ← Task
        │   │   ├── TASK002.md
        │   │   └── …
        │   ├── US10001/
        │   └── …
        ├── F1001/
        └── …
```

Every `CLAUDE.md` is paired with a sibling `.html` of the same basename (the tracker mirror — see "HTML tracker" below). Tasks are plain `.md` files and are *not* mirrored to HTML individually; they surface inside their story page.

## Numbering scheme

- **Epic:** `E<NNN>` — `E100` for the first epic. Only one in most projects.
- **Feature:** `F1xxx` — `F1000`, `F1001`, … zero-padded, one block per feature.
- **Story:** `US1xxxx` — the middle digits encode the parent feature: feature `F10xy` → stories `US10xyN`. So `F1004` → `US10400`, `US10401`, …; `F1014` → `US11400`, `US11401`, …
- **Task:** `TASK001`, `TASK002`, … restart at `001` inside each story folder.

**Numbering is additive and permanent.** IDs are referenced as dependencies elsewhere in the tree, so never renumber an existing ID — only append new ones. This is the single most important rule for keeping a tree internally consistent over time.

## File templates (use exactly these)

The metadata lines (`**Status:**`, `**Depends on:**`, etc.) are parsed by the HTML generator and by later agents — keep the exact `**Key:** value` shape and the exact key names.

### Feature `CLAUDE.md`
```
# F1xxx — <name>
**Phase:** N
**Status:** Not started | In progress | Done
**Depends on:** F1xxx, F1xxx          (or "none")
**Last updated:** YYYY-MM-DD

## Purpose
…

## In scope
- …

## Out of scope
- …

## Acceptance criteria (feature-level)
- [ ] …

## Stories
- US1xxxx — <title> — Status: Not started
- …

## Key design notes
- …

## Open questions
- …

## Status log
- YYYY-MM-DDTHH:MMZ — Created
```

### Story `CLAUDE.md`
```
# US1xxxx — <title>
**Feature:** F1xxx
**Status:** Not started | In progress | Done
**Model:** claude-sonnet-4-6 | claude-opus-4-8
**Depends on:** US1xxxx, US1xxxx       (other story IDs, or "none")
**Last updated:** YYYY-MM-DD

## User value
As a <persona>, I want <capability> so that <outcome>.

## Acceptance criteria
- [ ] …

## Tasks
- TASK001 — <title>
- TASK002 — <title>
- …

## Verification
How to confirm this story is truly done.

## Status log
- YYYY-MM-DDTHH:MMZ — Created
```

The `**Model:**` line is what the `pm` skill reads when it spawns the Worker for this story — the whole Worker runs at that one model. See "Model assignment" for how to pick it.

### Task `TASK[NNN].md`
```
# TASK[NNN] — <title>
**Story:** US1xxxx
**Effort:** S | M | L
**Depends on:** TASK[NNN] (same story) ; US1xxxx (other story)

## Objective
…

## Files to create / modify
- `path/to/file.ext` — what changes

## Implementation notes
…

## Acceptance criteria
- [ ] …

## Out of scope
- …
```

Task `Effort:` (S/M/L) is the per-task complexity signal that informs the story-level `Model:` choice — a story full of L tasks is a strong hint to run it on Opus.

## Model assignment (story-level)

Every story carries a `**Model:**` line. Default to **`claude-sonnet-4-6`** — it handles the bulk of well-specified implementation work efficiently. Bump a story to **`claude-opus-4-8`** when it has any of:

- **Architectural decisions** — choosing a schema, designing an interface other features depend on, picking an algorithm.
- **Under-specified / ambiguous acceptance criteria** — the Worker must exercise judgment, not just execute.
- **Algorithmic or scoring logic** — non-trivial correctness, math, or heuristics.
- **Cross-cutting changes** — touches many files or features, or sets a pattern others copy.
- **Security-sensitive work** — auth, secrets, permissions, anything where a subtle mistake is expensive.

When in doubt, the `Effort:` ratings of the story's tasks are a good proxy: mostly S/M → Sonnet; several L or a foundational story others depend on → Opus. The model is not load-bearing for correctness (a Sonnet story that turns out hard can be re-run on Opus), so bias toward the cheaper default and reserve Opus for stories that genuinely need the extra reasoning.

## Status log — the timestamped history standard

Every epic / feature / story `CLAUDE.md` carries a `## Status log` section: one line per status transition, oldest first, so the file records its own history rather than just its current state.

```
## Status log
- 2026-06-13T12:00Z — Created
- 2026-06-14T09:10Z — In progress — claimed by worker us10000-assessor
- 2026-06-15T16:30Z — Done — merged PR #42
```

- **Format:** `- <UTC ISO-8601 timestamp to the minute> — <Status> [— <optional note>]`. UTC + `Z` keeps entries unambiguous and sortable across agents in different time zones.
- **First entry is always `Created`** (stamped at scaffold time). Then `In progress`, any intermediate states (`Blocked`, etc.), and finally `Done` (or `Cancelled`).
- **The note is the per-transition record** — who claimed it, why it blocked, what PR merged it. This is where the "why" of a status change lives.

Do not hand-edit this log or the `**Status:**` line in lockstep by hand — that's exactly the drift the `set-status.ps1` script (installed alongside the HTML generator) exists to prevent. It rewrites `Status:`, bumps `Last updated:`, appends the timestamped log entry, and regenerates the HTML in one atomic call. The HTML generator parses the log to show created/started/done chips on each page, and the full log renders in the page body.

Tasks (`TASK[NNN].md`) have no `Status:` line — they track progress through acceptance-criteria checkboxes — so they carry no status log.

## Working agreement (write this into the epic charter)

1. **Verify dependencies before claiming a story.** Open the feature `CLAUDE.md` and the story `CLAUDE.md`; every entry on a `Depends on:` line must be `Done`.
2. **Status discipline.** Update `Status:` and `Last updated:` on the feature and story when you claim and again when you finish.
3. **One agent per story.** Tasks within a story may run in parallel under one agent; do not split a story across agents.
4. **Story is `Done` ⇔ every task's acceptance criteria are ticked.**
5. **The root `CLAUDE.md` is the design north star.** If a PM file conflicts with it, the root wins — flag it.
6. **Additive, not destructive.** Add new stories/tasks rather than renumbering existing ones.

## HTML tracker

The tree ships a static, dependency-free HTML mirror generated from the `CLAUDE.md` files — `CLAUDE.md` is always the single source of truth; the HTML is derived and never hand-edited. The generator `build-pm-html.ps1` (in this skill's `scripts/`, installed by pm-init into the target repo's `pm/`) walks the tree, parses each item's `Status:` and acceptance-criteria checkboxes for progress rollups, and emits:

- `pm/index.html` — portfolio page (all epics, overall completion bar)
- `pm/E<NNN>/E<NNN>.html` — epic page (features grouped by phase, story rollups)
- `pm/E<NNN>/F1xxx/F1xxx.html` — feature page (story list with AC progress)
- `pm/E<NNN>/F1xxx/US1xxxx/US1xxxx.html` — story page (rendered body, AC checkboxes)

A real fully-populated example to model the output on: `C:\Users\chris\Github\winnie\pm` (one epic, 15 features, ~87 stories, ~90 HTML files).

Run it after scaffolding and any time a `CLAUDE.md` changes:
```
pwsh -NoProfile -File pm/build-pm-html.ps1 -Path <repo>/pm -ProjectName "<Project>" -Lede "<one-line tagline>"
```
`-ProjectName` sets the brand/title shown across all pages; `-Lede` sets the portfolio subtitle. Both fall back sensibly (repo folder name / generic tagline) if omitted.

The companion `set-status.ps1` (also installed into `pm/` by pm-init) is the preferred way to change a node's status: it rewrites `Status:`, bumps `Last updated:`, appends the timestamped `## Status log` entry, and regenerates the HTML in one call — see "Status log" above.

## File-count verification

After scaffolding, confirm the tree is complete. Expected file count for a tree with `E` epics, `F` features, `S` stories, `T` total tasks:

`1 (epic charter) + F (feature charters) + S (story charters) + T (task files)` markdown files, plus the HTML mirror: `1 (index) + E + F + S` html files.

```powershell
# markdown nodes
(Get-ChildItem -Recurse pm -Filter *.md | Measure-Object).Count
# every feature has a charter; every story has a charter + at least TASK001
Get-ChildItem pm/E*/F* -Directory | Where-Object { -not (Test-Path "$($_.FullName)/CLAUDE.md") }   # should be empty
```
For each feature, the `## Stories` block in `F1xxx/CLAUDE.md` must enumerate exactly the set of `US1xxxx/` subfolders that exist.
