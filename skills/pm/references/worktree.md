# Git worktree commands for the per-story workflow

The SKILL.md explains *why* we use one worktree per story; this file is the *how*. Refer to it when setting up or tearing down a story's working environment.

## Naming convention

- **Branch:** `us1xxxx-<kebab-slug>` — e.g., `us10402-williamson-assessor`
- **Worktree path:** `../landfinder-us1xxxx` — sibling to the main checkout

The sibling-directory pattern keeps the main worktree on `main` (the PM's vantage point) and makes orphan-detection easy: `git worktree list` shows everything in one place.

## Create a worktree (PM or Worker, before any story work starts)

From the main repo directory:

```bash
git fetch origin
git worktree add -b us1xxxx-<slug> ../landfinder-us1xxxx origin/main
```

This creates a new branch off the **latest** `main` and checks it out into the sibling directory in one step. If the branch already exists (e.g., a prior abandoned attempt), drop the `-b` and the branch arg, then check out the existing branch into the worktree instead — but verify first that you actually want to resume that branch's history.

## Sync the worktree with main (during long-running stories)

If `main` has advanced and you want to incorporate changes:

```bash
# From inside the worktree:
git fetch origin
git rebase origin/main
```

Use `git merge origin/main` instead of rebase if the branch has been shared with reviewers and a rebase would invalidate their context (rare for short-lived story branches).

## Push the branch (Worker, on completion)

```bash
# From inside the worktree:
git push -u origin us1xxxx-<slug>
```

The `-u` sets up tracking so subsequent pushes are just `git push`.

## Merge the branch (PM, after reviewing the worker's diff)

Prefer fast-forward — it keeps history linear and the PM tree easy to scan later:

```bash
# From the main worktree, on `main`:
git fetch origin
git merge --ff-only origin/us1xxxx-<slug>
git push origin main
```

If `--ff-only` fails (history diverged because main moved during the story), have the Worker rebase the branch onto current `main` from their worktree, then retry. Avoid `--no-ff` unless the user has stated a preference for merge commits.

## Tear down after merge (PM)

```bash
# From the main repo directory:
git worktree remove ../landfinder-us1xxxx
git branch -d us1xxxx-<slug>
git push origin --delete us1xxxx-<slug>
```

Use `-d` (lowercase, "safe delete") so git refuses if the branch hasn't been merged into the current HEAD. If you intentionally want to throw away an unmerged branch — usually because the story was abandoned — use `-D` and document the abandonment reason in the story's `CLAUDE.md` before deletion.

## Listing & cleanup

```bash
git worktree list             # what worktrees exist and where they're checked out
git worktree prune            # remove worktree entries whose directories were deleted out-of-band
```

Run `git worktree list` periodically as a PM — it surfaces orphans (worktrees for stories that should have been torn down already) and tells you at a glance how much parallel work is in flight.

## Edge cases

- **Worktree directory already exists, not registered with git.** `git worktree add` will refuse. Either pick a different path or remove the stale directory after confirming it has no uncommitted work.
- **Cross-platform paths.** On Windows, prefer forward slashes in worktree paths to avoid escaping headaches: `../landfinder-us1xxxx` works in PowerShell, cmd, and bash.
- **Hooks running in the wrong worktree.** Pre-commit / pre-push hooks run against the worktree's working tree, not main. If a hook depends on shared dependencies (e.g., installed Node modules), make sure they're available in the worktree — or install them per worktree.
