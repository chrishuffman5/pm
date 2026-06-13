# TASK004 — File-count verification step

**Story:** US10101
**Effort:** S
**Depends on:** none

## Objective

Add a "verify the tree" step to `references/init.md` so the initializer confirms completeness before
reporting done: the markdown file count matches the expected formula, every node has its required
files, each feature's `## Stories` block enumerates exactly its actual story folders, and the HTML
mirror exists.

## Files to create / modify

- `skills/pm/references/init.md` — add the "Verify the tree" checklist (file-count formula,
  per-node presence checks, Stories-block ↔ folders match, HTML mirror, scripts installed).

## Implementation notes

- Expected markdown = 1 epic charter + feature charters + story charters + task files; expected
  HTML = 1 index + one per epic/feature/story.
- Spot-check that every story has a valid `**Model:**` value and a `## Status log` seeded with a
  `Created` entry, and that both `build-pm-html.ps1` and `set-status.ps1` are installed in `pm/`.

## Acceptance criteria

- [x] `references/init.md` documents the markdown/HTML file-count expectations and per-node presence checks.
- [x] It requires confirming each feature's `## Stories` block matches its actual `US1xxxx/` folders before reporting done.

## Out of scope

- The HTML generator's internals (F1002 tooling).
