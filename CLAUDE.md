# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude Code **plugin** that ships exactly one skill: `pm`. The repo's only job is to host and deploy that skill — there is no application, build step, or test suite. The skill content is the product.

Canonical source layout (mirrors the `domain-expert` plugin in this same `Github/` parent):

- `skills/pm/SKILL.md` — the skill. This is the single source of truth for the PM-tree workflow. Almost every meaningful change to this repo is an edit here.
- `skills/pm/references/worktree.md` — git commands the skill defers to.
- `skills/pm/scripts/build-pm-html.ps1` — generator the skill invokes *inside a consuming repo* (not run here).
- `.claude-plugin/plugin.json` — plugin manifest.
- `.claude-plugin/marketplace.json` — single-plugin marketplace catalog used for installation.

The working copy of this skill also lives at `C:\Users\chris\.claude\skills\pm` (where it was authored). This repo is the deployable copy; treat `skills/pm/SKILL.md` here as authoritative and keep the two in sync when editing.

## The skill in one paragraph

`pm` teaches agents to operate a Rally hierarchy (Epic → Feature → User Story → Task) stored as a tree of `CLAUDE.md` files under `pm/E100/` in a *target* repo. Two roles: a long-running **PM agent** owns one Feature and only delegates; short-lived **Worker agents** each own one User Story and do the coding. The core mechanic is **one story = one git worktree = one branch**, enabling parallel Workers without working-tree collisions. Read `skills/pm/SKILL.md` for the full playbooks before changing any of it.

## Releasing / deploying

Deployment is a GitHub release of this repo — `marketplace.json`'s `source.url` points at `github.com/chrishuffman5/pm.git`, and users install via `claude plugin marketplace add chrishuffman5/pm` + `claude plugin install pm@pm`.

The one non-obvious rule: **the version appears in two files and they must match.** When cutting a release, bump `version` in BOTH `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` (the `plugins[0].version` field) in the same commit. A mismatch makes the marketplace advertise a version the installed manifest disagrees with.

Plugin/skill changes only take effect in the user's **next** Claude Code session, never the running one.

## Conventions inherited from the sibling plugins

- Author block and `homepage`/`repository` URLs follow the `domain-expert` plugin's format (see its `.claude-plugin/` files for the canonical shape).
- A skill's `description` front-matter is its trigger surface — it must enumerate the phrases that should activate it. When editing `pm`'s behavior, keep the `description` trigger list in step with what the skill actually does.
- `scripts/*.ps1` target PowerShell 7+ (`pwsh`) and run on the consumer's machine, not here.
