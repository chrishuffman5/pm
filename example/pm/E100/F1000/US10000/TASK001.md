# TASK001 — Create .claude-plugin/plugin.json
**Story:** US10000
**Effort:** S
**Depends on:** none

## Objective
Author the plugin manifest that identifies the `pm` plugin to Claude Code, deliberately omitting
the `skills` field so the single `pm` skill is discovered by convention (matching the sibling
`domain-expert` plugin), not declared explicitly.

## Files to create / modify
- `.claude-plugin/plugin.json` — name `pm`, semantic `version`, `description`, author block, and
  `homepage`/`repository` URLs in the `domain-expert` format. No `skills` field.

## Implementation notes
- Keep `version` semver and remember it must stay in lockstep with `marketplace.json` at release.
- Copy the author block / URL shape from the `domain-expert` plugin's `.claude-plugin/plugin.json`.

## Acceptance criteria
- [x] `plugin.json` is valid JSON and parses without error.
- [x] It carries `name`, `version`, `description`, and author/URL fields, with **no** `skills` field.

## Out of scope
- The marketplace catalog (TASK002) and the skill content itself (TASK003).
