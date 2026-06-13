# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude Code **plugin** built around one Rally-style PM-tree workflow, exposed as a top-level skill **`pm`** (execution) with two sub-skills nested inside it, **`/pm:init`** (scaffold) and **`/pm:plan`** (refine). The repo's only job is to host and deploy them — there is no application, build step, or test suite. The skill content is the product.

Canonical source layout (mirrors the `domain-expert` plugin in this same `Github/` parent — which proves nested skills work: Claude Code recursively discovers every `SKILL.md` under `skills/`, and a directory can be both a skill and a container of sub-skills. Like domain-expert, `plugin.json` has **no `skills` field** — discovery is convention-based):

```
skills/pm/                    ← top-level skill (pm, execution); OWNS the shared assets
├── SKILL.md
├── scripts/{build-pm-html.ps1, set-status.ps1}
├── references/{tree-structure.md, worktree.md}
├── init/SKILL.md             ← /pm:init   (reaches ../scripts, ../references)
└── plan/SKILL.md             ← /pm:plan   (reaches ../references)
```

- `skills/pm/SKILL.md` — execution workflow (PM/Worker roles, worktrees, status discipline) **and** the owner of the shared `scripts/` + `references/`.
- `skills/pm/references/tree-structure.md` — **the master source of truth** for file templates, numbering, model-assignment heuristic, status-log standard, working agreement, and HTML-tracker structure.
- `skills/pm/scripts/` — `build-pm-html.ps1` (HTML tracker generator) and `set-status.ps1` (atomic status change → timestamped log → HTML regen). `/pm:init` installs both into a target repo's `pm/`; `pm` self-installs them from `${CLAUDE_SKILL_DIR}/scripts/` if a tree lacks them.
- `skills/pm/init/SKILL.md`, `skills/pm/plan/SKILL.md` — the scaffold/refine sub-skills; they reference `../scripts/` and `../references/` (one level up into the parent `pm` skill — within the plugin, so install-safe).
- `.claude-plugin/{plugin.json, marketplace.json}` — manifest + single-plugin marketplace catalog.

A working copy of the original `pm` skill also lives at `C:\Users\chris\.claude\skills\pm`. This repo is the deployable copy; treat the `skills/` copies here as authoritative.

## How the skill + sub-skills relate

Three lifecycle phases, deliberately separate so each loads only its own context and triggers on its own phrases:

- **/pm:init** turns a design brief into a populated `pm/` tree — `pm/PLAN.md`, the epic charter, the F/US/TASK skeleton, the two installed helper scripts, and a per-story `Model:` assignment.
- **/pm:plan** reshapes an existing tree (split stories, repair dependencies, re-phase, re-evaluate models) — additive, never renumbering, since IDs are cross-referenced as dependencies.
- **pm** executes the tree: a long-running **PM agent** owns a Feature and only delegates; short-lived **Worker agents** each own one User Story and do the coding, **one story = one git worktree = one branch** for parallelism.

### Ownership rule (important when editing)

`pm` owns the shared assets; `init`/`plan` reuse them via `../`. The templates have **one home**: `skills/pm/references/tree-structure.md`. `/pm:init` writes them into a target repo's `pm/E<NNN>/CLAUDE.md`; at runtime `pm` and `/pm:plan` read that *seeded* copy from the target repo. So a template change starts in `tree-structure.md`. The whole `pm/` folder in a target repo is **self-contained**: `PLAN.md`, scripts, generated `index.html`, and the epic tree all live under it.

### The `Model:` contract

The story `CLAUDE.md` template carries a `**Model:**` line (`claude-sonnet-4-6` default; `claude-opus-4-8` for complex stories). It flows: **/pm:init assigns it → the story file stores it → pm reads it** to choose the model when spawning that story's Worker (the Agent tool's `model` param). `/pm:plan` re-evaluates it. If you change the field name or the heuristic, update all three SKILL.md files *and* the generator (`build-pm-html.ps1` parses `**Model:**` to render a chip and strips it from the body).

### The status-log contract

Every epic/feature/story `CLAUDE.md` carries a `## Status log` — one timestamped line per transition (`Created` → `In progress` → … → `Done`), UTC ISO-8601. Status is **only ever changed through `set-status.ps1`**, which rewrites `Status:`, bumps `Last updated:`, appends the log entry, and regenerates the HTML in one call — so the four can't drift. The generator parses the log into created/started/done chips. If you change the log format, keep the `## Status log` parser in `build-pm-html.ps1`'s `Get-Meta` (matches `-`, en-, and em-dash) and the writer in `set-status.ps1` in sync.

### PLAN.md → dashboard

`pm/PLAN.md` is the cross-feature roadmap and is rendered into the portfolio dashboard: `build-pm-html.ps1` reads `pm/PLAN.md` and embeds it as the "Roadmap" section of `pm/index.html`, which is the overall status indicator across all epics/features/stories.

## Releasing / deploying

Deployment is a GitHub release of this repo — `marketplace.json`'s `source.url` points at `github.com/chrishuffman5/pm.git`, and users install via `claude plugin marketplace add chrishuffman5/pm` + `claude plugin install pm@pm`.

The one non-obvious rule: **the version appears in two files and they must match.** When cutting a release, bump `version` in BOTH `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` (the `plugins[0].version` field) in the same commit. A mismatch makes the marketplace advertise a version the installed manifest disagrees with.

Plugin/skill changes only take effect in the user's **next** Claude Code session, never the running one.

## Conventions inherited from the sibling plugins

- Author block and `homepage`/`repository` URLs follow the `domain-expert` plugin's format (see its `.claude-plugin/` files for the canonical shape).
- A skill's `description` front-matter is its trigger surface — it must enumerate the phrases that should activate it, and the three descriptions must stay mutually exclusive (init = create, plan = refine, pm = execute) so the right one fires. Keep each `description` trigger list in step with what its skill actually does.
- Sub-skill command names come from the directory name namespaced by the plugin: `skills/pm/init/` → `/pm:init`, `skills/pm/plan/` → `/pm:plan`. The dirs are deliberately bare `init`/`plan` (not `pm-init`) because the `pm:` namespace already disambiguates them from the built-in `/init`.
- `scripts/*.ps1` target PowerShell 7+ (`pwsh`) and run on the consumer's machine, not here.
