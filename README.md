# pm — Rally-style PM tree plugin

> 📊 **[Live example dashboard →](https://chrishuffman5.github.io/pm/)** — a worked PM tree, rendered by the skill's own tooling, showing how `pm` plans and executes project development. (The example tree under [`example/`](example/) documents how this very skill was built.)

A Claude Code plugin with a single **`pm`** skill for working a **Rally hierarchy** (Epic → Feature → User Story → Task) stored as a tree of `CLAUDE.md` files under `pm/E<NNN>/`. The skill has **three modes**, selected by the first token of the invocation (or inferred from intent).

The workflow was originally authored for the [`landfinder`](https://github.com/chrishuffman5/landfinder) repo's `pm/E100/` tree but applies to any repo laid out the same way.

## Three modes of `/pm`

| Invocation | Mode | What it does | Triggers on |
|------------|------|--------------|-------------|
| `/pm init …` | Scaffold | Builds a tree from a design brief: writes `pm/PLAN.md`, the `E<NNN>/CLAUDE.md` charter, the F/US/TASK folder skeleton, installs the two helper scripts, and auto-assigns each story a `Model:`. | "scaffold the PM tree", "bootstrap the Rally hierarchy", "set up pm/E100" |
| `/pm plan …` | Refine | Reshapes an existing tree in a planning session: split stories, repair dependency graphs, re-balance phases, sharpen acceptance criteria, re-evaluate model assignments. Additive, never destructive. | "refine the plan", "groom the backlog", "re-decompose this feature", "re-prioritize" |
| `/pm …` | Execute (default) | Builds the tree out: a long-running **PM agent** owns a Feature and spawns short-lived **Worker agents** — one per story, in a dedicated git worktree, on that story's assigned model — then reviews and merges their work. | "act as pm for F1xxx", "claim a story", "worktree for a story", "I'm the pm" |

The `init` and `plan` workflows are **reference prompts** (`references/init.md`, `references/plan.md`) that `SKILL.md` routes to based on the first word of the request; `execute` is the default in `SKILL.md` itself. One skill, one set of bundled `scripts/` and `references/`, no duplication.

### The `Model:` contract

Each story's `CLAUDE.md` carries a `**Model:**` line (`claude-sonnet-4-6` by default, `claude-opus-4-8` for architectural / ambiguous / algorithmic / cross-cutting / security-sensitive work). `init` mode assigns it at scaffold time, `plan` mode re-evaluates it, and `execute` mode reads it to decide which model to spawn each Worker on. Picking the model is a planning decision, not a spawn-time guess.

### Status log & timestamps

Every epic/feature/story file keeps a `## Status log` — one UTC-timestamped line per transition (`Created → In progress → Done`, with optional notes), giving each node a full audit trail rather than just a current state. Status is changed through the installed `set-status.ps1`, which rewrites the `Status:` line, stamps the log entry, bumps `Last updated:`, and regenerates the HTML tracker in one atomic call, so the file, its history, and the tracker never drift apart. The tracker surfaces created/started/done timestamps as chips on each page.

### Self-contained `pm/` folder

Everything the workflow needs lives under the target repo's `pm/`: `PLAN.md` (the roadmap, rendered into the dashboard), the two helper scripts, the generated `index.html` dashboard, and the epic tree. `init` mode lays this down; if you run `execute` mode on a tree missing the scripts, it installs them from the skill's own bundled copies (`${CLAUDE_SKILL_DIR}/scripts/`).

## Repository layout

```
skills/
└── pm/                                 ← the single skill
    ├── SKILL.md                        ← mode dispatch + the execute-mode workflow
    ├── scripts/
    │   ├── build-pm-html.ps1           ← tracker generator (installed into target repos)
    │   └── set-status.ps1              ← status change → timestamped log → HTML regen
    └── references/
        ├── init.md                     ← `/pm init` reference prompt (scaffold)
        ├── plan.md                     ← `/pm plan` reference prompt (refine)
        ├── tree-structure.md           ← master templates, numbering, model heuristic, status-log standard, HTML structure
        └── worktree.md                 ← git worktree commands for the per-story workflow
.claude-plugin/
├── plugin.json
└── marketplace.json
```

`SKILL.md` reads the first token of the request and routes to `references/init.md` or `references/plan.md`, or stays in execute mode. `references/tree-structure.md` is the single source of truth for the templates; `init` mode seeds them into a target repo's charter, and `plan`/`execute` read the seeded copy from there.

## Install

```bash
claude plugin marketplace add chrishuffman5/pm
claude plugin install pm@pm --scope user
```

Restart Claude Code; the skills then activate automatically on their trigger phrases.

## License

MIT — see [LICENSE](LICENSE).
