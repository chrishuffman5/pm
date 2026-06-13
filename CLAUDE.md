# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude Code **plugin** that ships three skills covering the lifecycle of a Rally-style PM tree: `pm-init` (scaffold), `pm-plan` (refine), and `pm` (execute). The repo's only job is to host and deploy them — there is no application, build step, or test suite. The skill content is the product.

Canonical source layout (mirrors the `domain-expert` plugin in this same `Github/` parent; `plugin.json`'s `"skills": "./skills/"` auto-discovers all three):

- `skills/pm-init/SKILL.md` + `references/tree-structure.md` + `scripts/` — the greenfield scaffolder. **`tree-structure.md` is the master source of truth** for the file templates, numbering scheme, model-assignment heuristic, status-log standard, working agreement, and HTML-tracker structure. `scripts/` holds the two helpers pm-init installs into a target repo's `pm/`: `build-pm-html.ps1` (HTML tracker generator) and `set-status.ps1` (atomic status change → timestamped log entry → HTML regen).
- `skills/pm-plan/SKILL.md` — the refinement workflow over an existing tree.
- `skills/pm/SKILL.md` + `references/worktree.md` — the execution workflow (PM/Worker roles, worktrees, status discipline) and the git commands it defers to.
- `.claude-plugin/plugin.json` — plugin manifest.
- `.claude-plugin/marketplace.json` — single-plugin marketplace catalog used for installation.

A working copy of the original `pm` skill also lives at `C:\Users\chris\.claude\skills\pm` (where it was authored). This repo is the deployable copy; treat the `skills/` copies here as authoritative and keep them in sync when editing.

## How the three skills relate

They map to three lifecycle phases and are deliberately separate so each loads only its own context and triggers on its own phrases:

- **pm-init** turns a design brief into a populated `pm/E<NNN>/` tree — `PLAN.md`, the epic charter, the F/US/TASK skeleton, the installed HTML generator, and a per-story `Model:` assignment.
- **pm-plan** reshapes an existing tree (split stories, repair dependencies, re-phase, re-evaluate models) — additive, never renumbering, since IDs are cross-referenced as dependencies.
- **pm** executes the tree: a long-running **PM agent** owns a Feature and only delegates; short-lived **Worker agents** each own one User Story and do the coding, **one story = one git worktree = one branch** for parallelism.

### Canonical-ownership rule (important when editing)

The file templates have **one home**: `skills/pm-init/references/tree-structure.md`. pm-init writes them into a target repo's `pm/E<NNN>/CLAUDE.md`; `pm` and `pm-plan` then read that *seeded* copy from the target repo, never each other's files. So a template change starts in `tree-structure.md`. No skill references another skill's files.

### The `Model:` contract

The story `CLAUDE.md` template carries a `**Model:**` line (`claude-sonnet-4-6` default; `claude-opus-4-8` for complex stories). It flows: **pm-init assigns it → the story file stores it → pm reads it** to choose the model when spawning that story's Worker (the Agent tool's `model` param). pm-plan re-evaluates it. If you change the field name or the heuristic, update all three skills *and* the generator (`build-pm-html.ps1` parses `**Model:**` to render a chip and strips it from the body).

### The status-log contract

Every epic/feature/story `CLAUDE.md` carries a `## Status log` — one timestamped line per transition (`Created` → `In progress` → … → `Done`), UTC ISO-8601. Status is **only ever changed through `set-status.ps1`**, which rewrites `Status:`, bumps `Last updated:`, appends the log entry, and regenerates the HTML in one call — so the four can't drift. The generator parses the log into created/started/done chips. If you change the log format, the parser to keep in sync is the `## Status log` block in `build-pm-html.ps1`'s `Get-Meta` (it matches `-`, en-, and em-dash separators) and the writer in `set-status.ps1`.

## Releasing / deploying

Deployment is a GitHub release of this repo — `marketplace.json`'s `source.url` points at `github.com/chrishuffman5/pm.git`, and users install via `claude plugin marketplace add chrishuffman5/pm` + `claude plugin install pm@pm`.

The one non-obvious rule: **the version appears in two files and they must match.** When cutting a release, bump `version` in BOTH `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` (the `plugins[0].version` field) in the same commit. A mismatch makes the marketplace advertise a version the installed manifest disagrees with.

Plugin/skill changes only take effect in the user's **next** Claude Code session, never the running one.

## Conventions inherited from the sibling plugins

- Author block and `homepage`/`repository` URLs follow the `domain-expert` plugin's format (see its `.claude-plugin/` files for the canonical shape).
- A skill's `description` front-matter is its trigger surface — it must enumerate the phrases that should activate it, and the three descriptions must stay mutually exclusive (init = create, plan = refine, pm = execute) so the right one fires. Keep each `description` trigger list in step with what its skill actually does.
- `scripts/*.ps1` target PowerShell 7+ (`pwsh`) and run on the consumer's machine, not here.
