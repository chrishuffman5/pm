# TASK002 — Sonnet/Opus selection heuristic

**Story:** US10104
**Effort:** M
**Depends on:** none

## Objective

Document the "Model assignment (story-level)" heuristic in `references/tree-structure.md`: default to
`claude-sonnet-4-6`; bump to `claude-opus-4-8` for stories with architectural decisions,
under-specified/ambiguous ACs, algorithmic/scoring logic, cross-cutting changes, or
security-sensitive work — with task `Effort:` ratings as a proxy and a clear bias toward the cheaper default.

## Files to create / modify

- `skills/pm/references/tree-structure.md` — add the "Model assignment (story-level)" section with
  the default, the five Opus triggers, and the Effort-as-proxy rule.
- `skills/pm/references/init.md` — reference the heuristic from the init "Model assignment" call-out (already points here).
- `skills/pm/references/plan.md` — reference the heuristic from the plan "Model re-assignment" activity (already points here).

## Implementation notes

- Make explicit that the model is *not* load-bearing for correctness — a Sonnet story that turns out
  hard can be re-run on Opus — so reserve Opus for stories that genuinely need the extra reasoning.
- Mostly S/M tasks → Sonnet; several L or a foundational story others depend on → Opus.

## Acceptance criteria

- [x] `references/tree-structure.md` documents the Sonnet default and the five Opus-trigger categories with the Effort proxy.
- [x] It states the bias toward Sonnet and that the model isn't load-bearing for correctness.

## Out of scope

- The template field itself (TASK001) and the execute-time read (TASK003).
