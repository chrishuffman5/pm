# TASK005 — Blocker escalation procedure

**Story:** US10100
**Effort:** S
**Depends on:** none

## Objective

Document how a Worker escalates a real blocker in `SKILL.md`: never silently skip or invent answers
— add a `## Blocker` section to the story `CLAUDE.md`, move status to `Blocked` via `set-status.ps1`,
notify the PM, and pause until unblocked. Define the PM's resolve-or-escalate options and how the
story returns to `In progress`.

## Files to create / modify

- `skills/pm/SKILL.md` — add the "Blocker escalation" section: the `## Blocker` block template
  (Surfaced at / Description / Needs from PM-human), the `Blocked` status path, and the resolution flow.

## Implementation notes

- A blocker is a missing dependency, ambiguous spec, broken external API, or scope ambiguity — the
  Worker must surface it, not guess.
- Status moves to `Blocked` via `set-status.ps1` so the transition is visible in the tracker and
  timestamped in the log; the resolver deletes the `## Blocker` section and returns to `In progress`.

## Acceptance criteria

- [x] `SKILL.md` documents the `## Blocker` section format and the `Blocked` status path via set-status.ps1.
- [x] The PM resolve-or-escalate flow and the unblock/return-to-In-progress step are documented.

## Out of scope

- The inter-agent messaging mechanism (SendMessage/Agent) beyond naming it as the notify channel.
