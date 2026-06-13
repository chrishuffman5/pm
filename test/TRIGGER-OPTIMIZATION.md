# pm skill — description-trigger optimization (US10303)

Goal: tune the single `pm` skill's `description` front-matter (its only trigger surface) so it
fires on scaffold/refine/execute requests against a PM tree and stays quiet on look-alikes.

Method: a **test team** of router agents — each given one candidate description in isolation
(no ground truth) and asked, per query, "would you invoke this skill?" Votes graded against the
eval set in `trigger-evals.json` (18 base near-misses + 8 adversarial hard cases). Run by the
`pm` skill in execute mode (this work is story US10303 in `example/`).

## Candidates
- **B0** — the shipped v0.1.0 description (verbose; lists literal trigger phrases like "I'm the pm", "groom the backlog", "act as project manager", "update status fields", "worktree", with no negative guard).
- **C1** — anchors hard to "a Rally-style tree of CLAUDE.md files under pm/E<NNN>/", spells out the three modes, adds explicit exclusions (generic/agile PM, Jira/Trello/Asana/Linear, `npm init`/`create-*`).
- **C2** — same anchoring + exclusions, more concise. **(chosen)**

## Results

Round 1 — base set (queries 1–18), 2 router agents per description:

| Description | Accuracy |
|---|---|
| B0 | 18/18 |
| C1 | 18/18 |
| C2 | 18/18 |

The base set was **non-discriminating** (everything aced it), so it was expanded with 8
adversarial hard cases (H1–H8) that reuse B0's own literal trigger phrases in generic, non-pm-tree
contexts (H1–H6 → should NOT trigger) plus two file-based positives (H7–H8 → should trigger).

Round 2 — hard set (H1–H8), 2 router agents per description:

| Description | Hard score | Failure |
|---|---|---|
| **B0** | **7/8 ×2** | under-triggered on **H8** ("I track each story as a CLAUDE.md file… pick up the next story") both runs — anchored to `pm/E<NNN>`/IDs, missed the *file-based* framing |
| **C1** | 8/8 ×2 | — |
| **C2** | 8/8 ×2 | — |

Combined (26 queries): **B0 25/26 · C1 26/26 · C2 26/26.** The win is a pure **recall** gain
(catching the "stories-as-CLAUDE.md-files" execute case) with **no precision loss** — every
description correctly rejected all 15 negatives, including the adversarial near-misses.

## Decision

Adopt **C2** — tied with C1 at 26/26 but leaner (the description is always in context). Validated
in a final combined pass over all 26 queries with **3 fresh router agents → 26/26, unanimous**.

Applied to `skills/pm/SKILL.md`. Net change vs B0: explicit "file-based CLAUDE.md tree" anchoring
(+1 recall) and explicit exclusions (robustness against generic-PM / external-tracker / code-scaffold
look-alikes), at roughly half the length.

## Reproduce
`test/trigger-evals.json` holds the eval set. Re-run by handing each candidate description + the
queries (no ground truth) to independent router agents, then grade votes against `should_trigger`.
The canonical alternative is skill-creator's `scripts/run_loop.py` (train/test split, `claude -p`).
