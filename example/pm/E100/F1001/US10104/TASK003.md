# TASK003 — Execute mode reads Model: when spawning the Worker

**Story:** US10104
**Effort:** S
**Depends on:** none

## Objective

Wire the contract's consumption side into the execute-mode PM playbook in `SKILL.md`: when the PM
spawns a story's Worker, it reads that story's `**Model:**` line and passes it as the Agent tool's
`model` parameter, defaulting to `claude-sonnet-4-6` if the line is absent. The model is chosen per
story at plan time precisely so the PM doesn't judge complexity at spawn time — honor it.

## Files to create / modify

- `skills/pm/SKILL.md` — in the PM playbook's story loop (the spawn step), add the "read the
  story's `Model:` line and spawn the Worker on that model" instruction with the Sonnet default.

## Implementation notes

- Spawn via the Agent tool's `model` param (or SendMessage if continuing a named Worker).
- This closes the contract loop: `init` assigns → the story file stores → `execute` reads → `plan`
  re-evaluates. Cross-check that wording matches `references/tree-structure.md`.

## Acceptance criteria

- [x] The `SKILL.md` PM playbook instructs reading the story's `Model:` line and passing it to the Agent tool's `model` param when spawning the Worker.
- [x] It defaults to `claude-sonnet-4-6` when a story has no `Model:` line.

## Out of scope

- The heuristic for choosing the value (TASK002) — execute mode only consumes it.
