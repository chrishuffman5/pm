# TASK001 — Add the Model: line to the story template

**Story:** US10104
**Effort:** S
**Depends on:** none

## Objective

Add the `**Model:**` metadata line to the Story `CLAUDE.md` template in
`references/tree-structure.md` (and mirror it in the epic charter's copy of that template), with the
allowed values `claude-sonnet-4-6 | claude-opus-4-8`, so every story carries an explicit model
assignment in the standard `**Key:** value` shape the generator parses.

## Files to create / modify

- `skills/pm/references/tree-structure.md` — add `**Model:**` to the Story template and a sentence
  noting it's what the skill reads when spawning the story's Worker.

## Implementation notes

- Keep the exact `**Model:** value` shape — `build-pm-html.ps1` parses it to render a chip and strips
  it from the rendered body.
- Place it among the other story metadata lines (after `Status:`, before `Depends on:`).

## Acceptance criteria

- [x] The Story template in `references/tree-structure.md` carries a `**Model:**` line with the two allowed values.
- [x] The template notes the field is consumed at Worker-spawn time and parsed by the HTML generator.

## Out of scope

- The selection heuristic (TASK002) and the execute-time read (TASK003).
