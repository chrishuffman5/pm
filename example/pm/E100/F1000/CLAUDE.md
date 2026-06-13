# F1000 — Skill foundation & plugin packaging
**Phase:** 1
**Status:** Done
**Depends on:** none
**Last updated:** 2026-06-10

## Purpose
Extract the landfinder `pm` skill into a standalone, open-source Claude Code plugin repo:
correct plugin manifests, the `SKILL.md` plus its `references/`, a Rally-style file-template
and numbering contract, a single `description` that triggers the skill across all three modes,
and a git repo pushed to a private GitHub remote. This is the foundation every later feature
(lifecycle modes, tooling, validation) builds on.

## In scope
- `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` manifests.
- Copying `SKILL.md`, `references/`, and `scripts/` into `skills/pm/`.
- The Epic/Feature/Story/Task templates, the per-feature century-block numbering scheme, the
  status-log standard, the `Model:` field, and the working agreement — captured in
  `references/tree-structure.md` as the single source of truth.
- The skill's triggering `description` and progressive-disclosure structure.
- `git init`, initial commit, and a private GitHub remote.

## Out of scope
- The `init` / `plan` / `execute` mode workflows themselves (Feature F1001).
- The HTML tracker generator and status-log helper implementations (Feature F1002).
- Agent-driven validation and the public release (Feature F1003).

## Acceptance criteria (feature-level)
- [x] Plugin manifests (`plugin.json`, `marketplace.json`) are valid and version-aligned.
- [x] `SKILL.md` plus `references/` are present under `skills/pm/`.
- [x] Repo is initialized and pushed to a GitHub remote.

## Stories
- US10000 — Extract the pm skill into a plugin repo — Status: Done
- US10001 — Define the Rally hierarchy & file templates — Status: Done
- US10002 — Author the triggering description & conventions — Status: Done
- US10003 — Initialize git repo & private remote — Status: Done

## Key design notes
- One skill, three modes (`init`/`plan`/`execute`) selected by the first token — not three
  separate skills. So `plugin.json` carries **no `skills` field**; discovery is
  convention-based, mirroring the sibling `domain-expert` plugin.
- The templates have exactly one home: `references/tree-structure.md`. `init` writes them into
  a target repo; `execute`/`plan` read the seeded copy. A template change always starts there.
- The version lives in two files (`plugin.json` and `marketplace.json`) and must stay in sync.

## Open questions
- None remaining — all resolved during the build (see story notes).

## Status log
- 2026-06-09T15:35Z — Created
- 2026-06-09T15:40Z — In progress
- 2026-06-10T18:00Z — Done
