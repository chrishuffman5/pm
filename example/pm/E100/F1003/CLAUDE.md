# F1003 — Validation & open-source release
**Phase:** 3
**Status:** In progress
**Depends on:** F1001, F1002
**Last updated:** 2026-06-13

## Purpose

Prove the `pm` skill actually works and then ship it. Validation comes first: a repeatable test
harness that seeds throwaway PM trees, plus agent-driven dispatch tests that spawn real Workers
with no mode hint and grade their output against the filesystem. Then the release work: a worked
example tree (this very tree) rendered to a GitHub Pages dashboard, a description-trigger
optimization pass so `/pm` fires on the right phrasings and stays quiet on the wrong ones, and
finally flipping the public repo on and verifying the marketplace install path.

## In scope

- A shell-based harness that builds disposable workspaces / seed trees and a documented scenario
  catalog (`test/setup-workspaces.sh`, `test/SCENARIOS.md`).
- Agent-driven tests of mode dispatch (init / plan / execute) with results captured in
  `test/RESULTS.md`, including a re-run after fixing findings.
- The `example/pm/` worked example scaffolded via init mode and rendered to a static HTML
  dashboard published on GitHub Pages.
- Description-trigger optimization against a should/should-not eval set.
- Publishing the public repo and verifying the marketplace listing/install.

## Out of scope

- Building the skill's runtime behavior (that is F1001/F1002 — modes and tooling).
- Any product domain content; the example tree documents the skill itself, nothing else.
- CI automation of the test harness — the harness is run by hand / by agents, not a pipeline.

## Acceptance criteria (feature-level)
- [x] test harness exists
- [x] agent dispatch tests pass
- [ ] description optimized
- [ ] public repo published

## Stories
- US10300 — Skill-invocation test harness — Status: Done
- US10301 — Agent-driven mode-dispatch tests — Status: Done
- US10302 — Example project + GitHub Pages dashboard — Status: Done
- US10303 — Description-trigger optimization — Status: Not started
- US10304 — Publish public repo + marketplace listing — Status: Not started

## Key design notes
- Tests run in disposable workspaces so a failed/garbage run never pollutes the repo; run outputs
  are gitignored.
- Dispatch tests deliberately omit the mode keyword to exercise *inferred* intent, not just the
  keyword path — that is the harder, more realistic case.
- The example tree is "the skill managing itself"; it doubles as both validation evidence and the
  public reference shape served by Pages.
- Description optimization and the public-repo flip are the last two gates and are still open,
  which is why the feature (and the whole epic) reads In progress.

## Open questions
- Final wording of the optimized `description` front-matter (pending the eval-loop result).
- Marketplace listing copy and announcement channels for US10304.

## Status log
- 2026-06-12T16:10Z — Created
- 2026-06-13T09:00Z — In progress
