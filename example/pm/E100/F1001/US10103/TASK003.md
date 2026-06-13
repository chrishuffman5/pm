# TASK003 — Collapse init/plan into reference prompts

**Story:** US10103
**Effort:** M
**Depends on:** none

## Objective

Keep `init` and `plan` as **reference prompts** rather than separate skills: `references/init.md`
and `references/plan.md` carry no SKILL.md frontmatter, so they aren't discovered as skills, and the
single `pm` skill's `description` front-matter covers all three modes' trigger phrases so the skill
fires regardless of which mode the user wants.

## Files to create / modify

- `skills/pm/SKILL.md` — ensure the single `description` front-matter spans scaffold/bootstrap,
  refine/groom, and execute/claim-a-story phrasing for all three modes.
- `skills/pm/references/init.md` — confirm no skill frontmatter (plain reference prompt).
- `skills/pm/references/plan.md` — confirm no skill frontmatter (plain reference prompt).

## Implementation notes

- `/pm:init` would be the *plugin:skill* convention for a separate skill — that's exactly what we're
  avoiding. The keyword is the first *argument* to the one `pm` skill.
- Mirror the `domain-expert` plugin: `plugin.json` has no `skills` field; discovery is convention-based.

## Acceptance criteria

- [x] `references/init.md` and `references/plan.md` contain no SKILL.md frontmatter, so neither is discovered as a separate skill.
- [x] The single `pm` skill `description` covers all three modes' trigger phrases.

## Out of scope

- The mode table and inference logic (TASK001 / TASK002).
