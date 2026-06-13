# pm — Rally-style PM tree plugin

A single-skill Claude Code plugin that teaches agents how to run a **Rally hierarchy** (Epic → Feature → User Story → Task) stored as a tree of `CLAUDE.md` files. It defines two roles — a long-running **PM agent** that owns a Feature and short-lived **Worker agents** that each own one User Story — and the runtime mechanics that keep them coordinated: git-worktree-per-story parallelism, strict status discipline, blocker escalation, and HTML tracker sync.

The skill was originally authored for the [`landfinder`](https://github.com/chrishuffman5/landfinder) repo's `pm/E100/` tree but the workflow applies to any repo laid out the same way.

## What's in here

| Path | Purpose |
|------|---------|
| `skills/pm/SKILL.md` | The skill itself — PM/Worker playbooks, status contract, pitfalls. |
| `skills/pm/references/worktree.md` | Exact git commands for create / sync / merge / tear-down. |
| `skills/pm/scripts/build-pm-html.ps1` | Generator that rebuilds the static HTML tracker from the `CLAUDE.md` tree. |
| `.claude-plugin/plugin.json` | Plugin manifest. |
| `.claude-plugin/marketplace.json` | Single-plugin marketplace catalog for installation. |

## Install

```bash
# Add this repo as a marketplace, then install the plugin
claude plugin marketplace add chrishuffman5/pm
claude plugin install pm@pm --scope user
```

Restart Claude Code; the `pm` skill then activates automatically whenever you work with a `pm/E100/`-style tree (see the skill's `description` for the full trigger list).

## License

MIT — see [LICENSE](LICENSE).
