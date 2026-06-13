# TASK001 — references/init.md scaffolding workflow

**Story:** US10101
**Effort:** M
**Depends on:** none

## Objective

Author `references/init.md` as the `init`-mode reference prompt: frame it as the procedure for
laying down a tree (with `references/tree-structure.md` as the template/numbering contract), and
establish the overall flow from design brief to a populated, HTML-mirrored `pm/` tree.

## Files to create / modify

- `skills/pm/references/init.md` — the init reference prompt: intro/framing, pointer to
  `references/tree-structure.md` as the source of truth, and the post-init handoff to plan/execute modes.

## Implementation notes

- State up front that paths are relative to the `pm` skill base dir and that this is a reference
  prompt entered when the invocation begins with `pm init`.
- The charter must copy the three templates *verbatim* from tree-structure (not summarize), so the
  scaffolded tree is self-describing.

## Acceptance criteria

- [x] `references/init.md` exists and frames init mode as the scaffolding procedure.
- [x] It points at `references/tree-structure.md` as the canonical template/numbering source and notes the handoff to plan/execute.

## Out of scope

- The detailed input-gathering (TASK002), step-by-step procedure (TASK003), and verification (TASK004).
