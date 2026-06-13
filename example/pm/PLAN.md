# pm — Implementation Plan

> **Source of design intent:** `example/CLAUDE.md`.
> **This file:** how the `pm` skill got built — phases, features, dependencies. Rendered into
> the portfolio dashboard (`index.html`) as the Roadmap.

## The Epic

**E100 — Build and open-source the `pm` skill.** Package the Rally-style PM-tree workflow as a
Claude Code plugin, evolve it into a single skill with three modes (`init` · `plan` · `execute`),
give it self-contained tooling (HTML tracker + status logger), validate the mode dispatch with
real agents, and prepare a public release.

## Rally hierarchy

```
E100 (Epic)
└── F1xxx (Feature)
    └── US1xxxx (User Story)
        └── TASK001.md, TASK002.md, … (Tasks)
```

**Numbering:** Epic `E100`; Features `F1000`–`F1003`; Stories `US10xyN` (middle digits = feature
suffix); Tasks restart at `TASK001` per story. IDs are additive and permanent.

## Feature catalog

| ID | Feature | Phase | Stories | Status | Folder |
|---|---|---|---|---|---|
| F1000 | Skill foundation & plugin packaging | 1 | 4 | Done | `pm/E100/F1000/` |
| F1001 | Lifecycle modes (init · plan · execute) | 2 | 5 | Done | `pm/E100/F1001/` |
| F1002 | Tooling & status tracking | 2 | 4 | Done | `pm/E100/F1002/` |
| F1003 | Validation & open-source release | 3 | 5 | In progress | `pm/E100/F1003/` |

## Phases & dependency graph

### Phase 1 — Foundation
*No upstream dependencies.*
- **F1000** — extract the skill into a plugin repo, define the Rally hierarchy and templates,
  set the triggering description, stand up the git remote.

### Phase 2 — Capability
*Both depend on F1000; can run in parallel.*
- **F1001** — the three lifecycle modes and the single-skill dispatch that routes between them.
- **F1002** — the PowerShell tooling: the HTML tracker generator and the status-log helper.

### Phase 3 — Release
*Depends on F1001 + F1002.*
- **F1003** — a test harness and agent-driven dispatch tests, this example + GitHub Pages,
  description-trigger optimization, and the public repo/marketplace launch.

## Working agreement
1. Verify dependencies before claiming a story (every `Depends on:` is `Done`).
2. Change status only through `pm/set-status.ps1` (it stamps the log + regenerates HTML).
3. One agent per story. A story is `Done` only when every task's ACs are ticked.
4. Additive, never renumber — IDs are referenced as dependencies.
5. Regenerate the HTML tracker in the same turn as any `CLAUDE.md` edit.
