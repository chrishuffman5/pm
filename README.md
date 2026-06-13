# pm — Rally-style PM tree plugin

A Claude Code plugin that teaches agents to run a **Rally hierarchy** (Epic → Feature → User Story → Task) stored as a tree of `CLAUDE.md` files under `pm/E<NNN>/`. It ships three skills covering the full lifecycle of such a tree — scaffold it, refine it, then execute it with a coordinated team of agents.

The workflow was originally authored for the [`landfinder`](https://github.com/chrishuffman5/landfinder) repo's `pm/E100/` tree but applies to any repo laid out the same way.

## The three skills

| Skill | Phase | What it does | Triggers on |
|-------|-------|--------------|-------------|
| **pm-init** | Genesis | Scaffolds a tree from a design brief: writes `PLAN.md`, the `E<NNN>/CLAUDE.md` charter, the F/US/TASK folder skeleton, installs the HTML generator, and auto-assigns each story a `Model:`. Owns the master templates. | "scaffold the PM tree", "bootstrap the Rally hierarchy", "set up pm/E100", "build out the feature/story/task structure" |
| **pm-plan** | Refinement | Reshapes an existing tree in a planning session: split stories, repair dependency graphs, re-balance phases, sharpen acceptance criteria, re-evaluate model assignments. Additive, never destructive. | "refine the plan", "groom the backlog", "re-decompose this feature", "fix the dependencies", "re-prioritize" |
| **pm** | Execution | Builds the tree out: a long-running **PM agent** owns a Feature and spawns short-lived **Worker agents** — one per story, in a dedicated git worktree, on that story's assigned model — then reviews and merges their work. | "act as pm for F1xxx", "claim a story", "worktree for a story", "tick the checkboxes", "I'm the pm" |

### The `Model:` contract

Each story's `CLAUDE.md` carries a `**Model:**` line (`claude-sonnet-4-6` by default, `claude-opus-4-8` for architectural / ambiguous / algorithmic / cross-cutting / security-sensitive work). `pm-init` assigns it at scaffold time, `pm-plan` re-evaluates it, and `pm` reads it to decide which model to spawn each Worker on. Picking the model is a planning decision, not a spawn-time guess.

### Status log & timestamps

Every epic/feature/story file keeps a `## Status log` — one UTC-timestamped line per transition (`Created → In progress → Done`, with optional notes), giving each node a full audit trail rather than just a current state. Status is changed through the installed `set-status.ps1`, which rewrites the `Status:` line, stamps the log entry, bumps `Last updated:`, and regenerates the HTML tracker in one atomic call, so the file, its history, and the tracker never drift apart. The tracker surfaces created/started/done timestamps as chips on each page.

## Repository layout

```
skills/
├── pm-init/
│   ├── SKILL.md
│   ├── references/tree-structure.md     ← master templates, numbering, model heuristic, status-log standard, HTML structure
│   └── scripts/
│       ├── build-pm-html.ps1            ← the tracker generator (installed into target repos)
│       └── set-status.ps1               ← status change → timestamped log → HTML regen (installed into target repos)
├── pm-plan/
│   └── SKILL.md
└── pm/
    ├── SKILL.md
    └── references/worktree.md           ← git worktree commands for the per-story workflow
.claude-plugin/
├── plugin.json
└── marketplace.json
```

`tree-structure.md` (in pm-init) is the single source of truth for the templates; pm-init seeds them into a target repo's charter, and pm / pm-plan read the seeded copy from there.

## Install

```bash
claude plugin marketplace add chrishuffman5/pm
claude plugin install pm@pm --scope user
```

Restart Claude Code; the skills then activate automatically on their trigger phrases.

## License

MIT — see [LICENSE](LICENSE).
