# TASK003 — Align with domain-expert plugin conventions
**Story:** US10002
**Effort:** S
**Depends on:** none

## Objective
Match the sibling `domain-expert` plugin's conventions so the `pm` plugin feels native: no
`skills` field (convention-based discovery), and the same author/`homepage`/`repository` shape.

## Files to create / modify
- `.claude-plugin/plugin.json` — author block and URL fields in the `domain-expert` format.
- `skills/pm/SKILL.md` — confirm invocation is `/pm`, `/pm init`, `/pm plan` (not `/pm:init`).

## Implementation notes
- `/pm:init` would imply a separate `init` skill; keep one skill invoked with a first-token keyword.
- Reference the `domain-expert` `.claude-plugin/` files for the canonical author/URL shape.

## Acceptance criteria
- [x] `plugin.json`'s author/URL block matches the `domain-expert` format and omits `skills`.
- [x] Invocation convention is the single-skill `/pm [init|plan]` form, documented in `SKILL.md`.

## Out of scope
- Marketplace versioning (US10000 / Feature F1003).
