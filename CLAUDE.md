# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude Code **plugin** with a single **`pm`** skill that works a Rally-style PM tree in three **modes** — `init` (scaffold), `plan` (refine), and `execute` (default). The repo's only job is to host and deploy it — there is no application, build step, or test suite. The skill content is the product.

Why one skill with modes (not three skills): `/pm:init`-style names are the *plugin:skill* invocation convention, which would make `init`/`plan` separate skills. Instead the user wants one skill invoked as `/pm`, `/pm init`, `/pm plan` — so `init` and `plan` are **reference prompts** the `SKILL.md` dispatches to by the first token of the request. (Like the `domain-expert` plugin, `plugin.json` has **no `skills` field** — discovery is convention-based.)

```
skills/pm/
├── SKILL.md                 ← mode dispatch (first token → init|plan|execute) + the execute-mode workflow
├── scripts/{build-pm-html.ps1, set-status.ps1}
└── references/
    ├── init.md              ← `/pm init` reference prompt (scaffold)
    ├── plan.md              ← `/pm plan` reference prompt (refine)
    ├── tree-structure.md    ← master templates / numbering / model heuristic / status-log spec / HTML structure
    └── worktree.md          ← git worktree commands for the per-story workflow
```

- `skills/pm/SKILL.md` — picks the mode (see its "Pick the mode first" table), then for `execute` contains the PM/Worker workflow; for `init`/`plan` it points at the matching `references/*.md`.
- `skills/pm/references/tree-structure.md` — **the master source of truth** for file templates, numbering, model heuristic, status-log standard, working agreement, and HTML-tracker structure.
- `skills/pm/scripts/` — `build-pm-html.ps1` (HTML tracker generator) and `set-status.ps1` (atomic status change → timestamped log → HTML regen). `init` mode installs both into a target repo's `pm/`; `execute` mode self-installs them from `${CLAUDE_SKILL_DIR}/scripts/` if a tree lacks them.
- The reference prompts use **skill-root-relative** paths (`references/…`, `scripts/…`), since they're read with the `pm` skill's base dir as the working root.
- `.claude-plugin/{plugin.json, marketplace.json}` — manifest + single-plugin marketplace catalog.

A working copy of the original `pm` skill also lives at `C:\Users\chris\.claude\skills\pm`. This repo is the deployable copy; treat the `skills/` copies here as authoritative.

## The three modes

Selected by the first token of the invocation, or inferred from intent when no keyword is given:

- **`/pm init`** turns a design brief into a populated `pm/` tree — `pm/PLAN.md`, the epic charter, the F/US/TASK skeleton, the two installed helper scripts, and a per-story `Model:` assignment.
- **`/pm plan`** reshapes an existing tree (split stories, repair dependencies, re-phase, re-evaluate models) — additive, never renumbering, since IDs are cross-referenced as dependencies.
- **`/pm`** (default) executes the tree: a long-running **PM agent** owns a Feature and only delegates; short-lived **Worker agents** each own one User Story and do the coding, **one story = one git worktree = one branch** for parallelism.

### Ownership rule (important when editing)

The templates have **one home**: `skills/pm/references/tree-structure.md`. `init` mode writes them into a target repo's `pm/E<NNN>/CLAUDE.md`; at runtime `execute`/`plan` read that *seeded* copy from the target repo. So a template change starts in `tree-structure.md`. The whole `pm/` folder in a target repo is **self-contained**: `PLAN.md`, scripts, generated `index.html`, and the epic tree all live under it.

### The `Model:` contract

The story `CLAUDE.md` template carries a `**Model:**` line (`claude-sonnet-5-5` default; `claude-opus-5-5` for complex stories; `claude-fable-5-1` reserved for foundational, hard-to-reverse, or open-ended-correctness stories). It flows: **`init` assigns it → the story file stores it → `execute` reads it** to choose the model when spawning that story's Worker (the Agent tool's `model` param). `plan` re-evaluates it. If you change the field name or the heuristic, update `SKILL.md` + both reference prompts *and* the generator (`build-pm-html.ps1` parses `**Model:**` to render a chip and strips it from the body).

### The status-log contract

Every epic/feature/story `CLAUDE.md` carries a `## Status log` — one timestamped line per transition (`Created` → `In progress` → … → `Done`), UTC ISO-8601. Status is **only ever changed through `set-status.ps1`**, which rewrites `Status:`, bumps `Last updated:`, appends the log entry, and regenerates the HTML in one call — so the four can't drift. The generator parses the log into created/started/done chips. If you change the log format, keep the `## Status log` parser in `build-pm-html.ps1`'s `Get-Meta` (matches `-`, en-, and em-dash) and the writer in `set-status.ps1` in sync.

### PLAN.md → dashboard

`pm/PLAN.md` is the cross-feature roadmap and is rendered into the portfolio dashboard: `build-pm-html.ps1` reads `pm/PLAN.md` and embeds it as the "Roadmap" section of `pm/index.html`, which is the overall status indicator across all epics/features/stories.

## Releasing / deploying

Deployment is a GitHub release of this repo — `marketplace.json`'s `source.url` points at `github.com/chrishuffman5/pm.git`, and users install via `claude plugin marketplace add chrishuffman5/pm` + `claude plugin install pm@pm`.

The one non-obvious rule: **the version appears in THREE files and they must match the release tag.** When cutting a release, bump `version` in all of:
- `.claude-plugin/plugin.json` → `version`
- `.claude-plugin/marketplace.json` → `plugins[0].version`
- `skills/pm/SKILL.md` → `metadata.version` (embedded so a copied-around SKILL.md is self-describing — a user can diff their `metadata.version` against the latest release to know if they're current)

in the same commit, then tag `vX.Y.Z`. A mismatch makes the marketplace advertise a version the installed manifest disagrees with, or a stale SKILL.md lie about its provenance. Quick check before tagging:
```bash
grep -h '"version"' .claude-plugin/*.json; grep 'version:' skills/pm/SKILL.md
```

Plugin/skill changes only take effect in the user's **next** Claude Code session, never the running one.

## Conventions inherited from the sibling plugins

- Author block and `homepage`/`repository` URLs follow the `domain-expert` plugin's format (see its `.claude-plugin/` files for the canonical shape).
- The `pm` skill's single `description` front-matter is its whole trigger surface — it must cover all three modes' phrases (scaffold/bootstrap, refine/groom, and execute/claim-a-story) so the skill fires regardless of which mode the user wants. The actual mode is then chosen inside `SKILL.md` by the first token / inferred intent.
- Modes are invoked as `/pm`, `/pm init`, `/pm plan` (the keyword is the first argument to the one skill) — NOT `/pm:init`, which would be the plugin:skill convention for a *separate* skill. Keep `references/init.md` and `references/plan.md` as plain reference prompts (no SKILL.md frontmatter) so they aren't discovered as skills.
- `scripts/*.ps1` target PowerShell 7+ (`pwsh`) and run on the consumer's machine, not here.
