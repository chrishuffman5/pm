# US10103 — Mode dispatch: single skill, first-token routing

**Feature:** F1001
**Status:** Done
**Model:** claude-opus-4-8
**Depends on:** US10100, US10101, US10102

**Last updated:** 2026-06-12

## User value

As a user who types `/pm`, `/pm init`, or `/pm plan`, I want the single `pm` skill to route me to
the right mode by the first token of my request (and infer intent when I give no keyword), so that
one skill cleanly serves three workflows without three separate skills polluting discovery.

## Acceptance criteria

- [x] `SKILL.md` opens with a "Pick the mode first" table mapping first token → mode → action
  (init/plan read the matching `references/*.md`; anything else continues as execute).
- [x] Inferred-intent rules are documented for when no keyword is given (no tree yet → init;
  reshape an existing tree → plan; build it out → execute; ask when genuinely unsure plan vs execute).
- [x] init and plan are collapsed into reference prompts (no SKILL.md frontmatter) so they are not
  discovered as separate skills, and cross-reference wording (`/pm init`, `/pm plan`) is consistent.

## Tasks

- TASK001 — "Pick the mode first" table in SKILL.md
- TASK002 — Inferred-intent rules for keyword-less requests
- TASK003 — Collapse init/plan into reference prompts
- TASK004 — Cross-reference wording (/pm init, /pm plan)

## Verification

Read the top of `skills/pm/SKILL.md`: the mode table and inferred-intent paragraph route correctly,
the `description` front-matter covers all three modes' trigger phrases, and `references/init.md` /
`references/plan.md` carry no skill frontmatter (so they aren't discovered). Invoking `/pm init` and
`/pm plan` lands in the right reference prompt; bare `/pm` continues into execute.

## Status log
- 2026-06-10T18:10Z — Created
- 2026-06-12T09:00Z — In progress — wiring the first-token dispatch
- 2026-06-12T13:00Z — Done — single-skill mode routing complete
