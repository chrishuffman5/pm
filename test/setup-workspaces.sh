#!/usr/bin/env bash
# Sets up isolated workspaces for testing the pm skill's mode dispatch.
#   - init scenarios get an empty repo with a design brief in CLAUDE.md (no pm/ tree yet)
#   - plan / execute scenarios get a pre-inited pm/ tree (E100 + 2 features + stories/tasks)
# Re-runnable: it wipes and rebuilds test/workspaces/.
set -euo pipefail

SKILL="/c/Users/chris/Github/pm/skills/pm"
ROOT="/c/Users/chris/Github/pm/test/workspaces"
TODAY="$(date -u +%Y-%m-%d)"
STAMP="$(date -u +%Y-%m-%dT%H:%MZ)"

rm -rf "$ROOT"
mkdir -p "$ROOT"

# ---------------------------------------------------------------------------
# seed_tree <workspace-dir> <project-name>
#   Writes a small, template-conformant pm/ tree, installs the helper scripts,
#   and generates the HTML tracker — i.e. the state /pm init would leave behind.
# ---------------------------------------------------------------------------
seed_tree() {
  local ws="$1" proj="$2"
  mkdir -p "$ws/pm/E100/F1000/US10000" "$ws/pm/E100/F1000/US10001" \
           "$ws/pm/E100/F1001/US10100" "$ws/pm/E100/F1001/US10101"
  cp "$SKILL/scripts/build-pm-html.ps1" "$ws/pm/build-pm-html.ps1"
  cp "$SKILL/scripts/set-status.ps1"    "$ws/pm/set-status.ps1"

  cat > "$ws/CLAUDE.md" <<EOF
# $proj

A small demo service used to exercise the pm skill. Two subsystems: a storage
layer and a REST API on top of it.
EOF

  cat > "$ws/pm/PLAN.md" <<EOF
# $proj — Implementation Plan

## Feature catalog
| ID | Feature | Phase | Stories | Folder |
|---|---|---|---|---|
| F1000 | Storage layer | 1 | 2 | pm/E100/F1000/ |
| F1001 | REST API | 2 | 2 | pm/E100/F1001/ |

## Phases & dependency graph
### Phase 1 — Foundation
- F1000 Storage layer — no upstream dependencies.
### Phase 2 — Surface
- F1001 REST API — depends on F1000.
EOF

  cat > "$ws/pm/E100/CLAUDE.md" <<'EOF'
# E100 — Demo service epic
**Status:** In progress
**Last updated:** TODAY

## Epic statement
Build a small storage-backed REST service to exercise the PM workflow.

## Rally hierarchy & numbering
- Features F1000, F1001. Stories US10xyN under feature F10xy. Tasks TASK001+ per story.

## File templates (use exactly these)
### Feature `CLAUDE.md`
```
# F1xxx — <name>
**Phase:** N
**Status:** Not started | In progress | Done
**Depends on:** F1xxx (or "none")
**Last updated:** YYYY-MM-DD

## Purpose
## In scope
## Out of scope
## Acceptance criteria (feature-level)
- [ ] …
## Stories
- US1xxxx — <title> — Status: Not started
## Key design notes
## Open questions

## Status log
- YYYY-MM-DDTHH:MMZ — Created
```
### Story `CLAUDE.md`
```
# US1xxxx — <title>
**Feature:** F1xxx
**Status:** Not started | In progress | Done
**Model:** claude-sonnet-4-6 | claude-opus-4-8
**Depends on:** US1xxxx (or "none")
**Last updated:** YYYY-MM-DD

## User value
## Acceptance criteria
- [ ] …
## Tasks
- TASK001 — <title>
## Verification

## Status log
- YYYY-MM-DDTHH:MMZ — Created
```
### Task `TASK[NNN].md`
```
# TASK[NNN] — <title>
**Story:** US1xxxx
**Effort:** S | M | L
**Depends on:** none
## Objective
## Files to create / modify
## Implementation notes
## Acceptance criteria
- [ ] …
## Out of scope
```

## Working agreement
1. Verify dependencies before claiming a story.
2. Status discipline: change status via pm/set-status.ps1.
3. One agent per story. 4. Story Done <=> every task's ACs ticked.
5. Root CLAUDE.md wins on conflict. 6. Additive, never renumber.
EOF
  sed -i "s/^\*\*Last updated:\*\* TODAY/**Last updated:** $TODAY/" "$ws/pm/E100/CLAUDE.md"

  # ---- Feature F1000 (Storage) ----
  cat > "$ws/pm/E100/F1000/CLAUDE.md" <<EOF
# F1000 — Storage layer
**Phase:** 1
**Status:** In progress
**Depends on:** none
**Last updated:** $TODAY

## Purpose
Persist and query the domain objects.

## In scope
- Schema + a small data-access module.

## Out of scope
- Caching.

## Acceptance criteria (feature-level)
- [ ] Schema defined and a record round-trips.

## Stories
- US10000 — Define schema — Status: Done
- US10001 — Data-access module — Status: In progress

## Key design notes
- Single-node store is fine for the demo.

## Open questions
- none

## Status log
- $STAMP — Created
EOF

  cat > "$ws/pm/E100/F1000/US10000/CLAUDE.md" <<EOF
# US10000 — Define schema
**Feature:** F1000
**Status:** Done
**Model:** claude-sonnet-4-6
**Depends on:** none
**Last updated:** $TODAY

## User value
As a developer, I want a schema so data has a stable shape.

## Acceptance criteria
- [x] Tables/entities defined.

## Tasks
- TASK001 — Write the schema

## Verification
Schema file exists and parses.

## Status log
- $STAMP — Created
- $STAMP — Done
EOF
  cat > "$ws/pm/E100/F1000/US10000/TASK001.md" <<EOF
# TASK001 — Write the schema
**Story:** US10000
**Effort:** S
**Depends on:** none

## Objective
Define the entities.

## Files to create / modify
- \`schema.sql\` — entity definitions

## Acceptance criteria
- [x] schema.sql committed

## Out of scope
- migrations
EOF

  cat > "$ws/pm/E100/F1000/US10001/CLAUDE.md" <<EOF
# US10001 — Data-access module
**Feature:** F1000
**Status:** In progress
**Model:** claude-sonnet-4-6
**Depends on:** US10000
**Last updated:** $TODAY

## User value
As a developer, I want CRUD helpers so the API can read/write records.

## Acceptance criteria
- [ ] create/read/update/delete helpers exist
- [ ] each is unit-tested

## Tasks
- TASK001 — Implement CRUD helpers

## Verification
Unit tests pass.

## Status log
- $STAMP — Created
- $STAMP — In progress — claimed for testing
EOF
  cat > "$ws/pm/E100/F1000/US10001/TASK001.md" <<EOF
# TASK001 — Implement CRUD helpers
**Story:** US10001
**Effort:** M
**Depends on:** none

## Objective
CRUD over the schema.

## Files to create / modify
- \`store.py\` — CRUD helpers

## Acceptance criteria
- [ ] helpers implemented
- [ ] tests added

## Out of scope
- pagination
EOF

  # ---- Feature F1001 (API), depends on F1000 ----
  cat > "$ws/pm/E100/F1001/CLAUDE.md" <<EOF
# F1001 — REST API
**Phase:** 2
**Status:** Not started
**Depends on:** F1000
**Last updated:** $TODAY

## Purpose
Expose the store over HTTP.

## In scope
- CRUD endpoints.

## Out of scope
- Auth.

## Acceptance criteria (feature-level)
- [ ] Endpoints return correct status codes.

## Stories
- US10100 — Endpoint scaffolding — Status: Not started
- US10101 — CRUD endpoints + validation — Status: Not started

## Key design notes
- Thin handlers over the data-access module.

## Open questions
- Which web framework? (left open intentionally)

## Status log
- $STAMP — Created
EOF
  cat > "$ws/pm/E100/F1001/US10100/CLAUDE.md" <<EOF
# US10100 — Endpoint scaffolding
**Feature:** F1001
**Status:** Not started
**Model:** claude-sonnet-4-6
**Depends on:** US10001
**Last updated:** $TODAY

## User value
As a client, I want a running API server so I can call it.

## Acceptance criteria
- [ ] server boots and serves a health check

## Tasks
- TASK001 — Bootstrap the server

## Verification
GET /health returns 200.

## Status log
- $STAMP — Created
EOF
  cat > "$ws/pm/E100/F1001/US10100/TASK001.md" <<EOF
# TASK001 — Bootstrap the server
**Story:** US10100
**Effort:** S
**Depends on:** none

## Objective
Stand up the HTTP server with a health route.

## Files to create / modify
- \`server.py\` — app + /health

## Acceptance criteria
- [ ] /health returns 200

## Out of scope
- business endpoints
EOF
  cat > "$ws/pm/E100/F1001/US10101/CLAUDE.md" <<EOF
# US10101 — CRUD endpoints + validation
**Feature:** F1001
**Status:** Not started
**Model:** claude-opus-4-8
**Depends on:** US10100
**Last updated:** $TODAY

## User value
As a client, I want validated CRUD endpoints so I can manage records safely.

## Acceptance criteria
- [ ] all four CRUD verbs wired to the store
- [ ] request validation with helpful errors
- [ ] integration tests cover happy + error paths

## Tasks
- TASK001 — Wire CRUD handlers
- TASK002 — Add request validation

## Verification
Integration tests pass.

## Status log
- $STAMP — Created
EOF
  cat > "$ws/pm/E100/F1001/US10101/TASK001.md" <<EOF
# TASK001 — Wire CRUD handlers
**Story:** US10101
**Effort:** M
**Depends on:** none

## Objective
Map endpoints to data-access helpers.

## Files to create / modify
- \`server.py\` — CRUD routes

## Acceptance criteria
- [ ] four verbs wired

## Out of scope
- validation (TASK002)
EOF
  cat > "$ws/pm/E100/F1001/US10101/TASK002.md" <<EOF
# TASK002 — Add request validation
**Story:** US10101
**Effort:** M
**Depends on:** TASK001

## Objective
Validate inputs; return helpful 4xx errors.

## Files to create / modify
- \`server.py\` — validation layer

## Acceptance criteria
- [ ] invalid input yields a 400 with a message

## Out of scope
- auth
EOF

  # Generate the HTML tracker, exactly as an inited tree would have.
  pwsh -NoProfile -File "$ws/pm/build-pm-html.ps1" -Path "$ws/pm" -ProjectName "$proj" -Lede "Demo tree for skill testing." >/dev/null
  # Make it a git repo so execute-mode worktree steps are at least possible.
  ( cd "$ws" && git init -q && git add -A && git -c user.email=t@t -c user.name=t commit -qm "seed" )
}

# Empty repo with only a design brief (init scenarios) ----------------------
seed_brief() {
  local ws="$1" proj="$2" pitch="$3"
  mkdir -p "$ws"
  cat > "$ws/CLAUDE.md" <<EOF
# $proj

$pitch
EOF
  ( cd "$ws" && git init -q && git add -A && git -c user.email=t@t -c user.name=t commit -qm "brief" )
}

echo "Seeding workspaces under $ROOT ..."
seed_brief "$ROOT/A-init-keyword"  "TaskTrackr" "A small team task tracker. Capabilities: user accounts & login, task CRUD with due dates, and email notifications when a task is assigned or due."
seed_brief "$ROOT/B-init-inferred" "BlogEngine" "A minimal blogging platform. Capabilities: author accounts, post authoring with markdown, a public reading site, and comments with moderation."
seed_tree  "$ROOT/C-plan-keyword"  "DemoApp"
seed_tree  "$ROOT/D-plan-inferred" "DemoApp"
seed_tree  "$ROOT/E-execute"       "DemoApp"

echo "Done. Workspaces:"
ls -1 "$ROOT"
echo
echo "Seed sanity — C-plan-keyword tree:"
find "$ROOT/C-plan-keyword/pm" -maxdepth 2 -name '*.md' | sort
echo "HTML pages generated in C: $(find "$ROOT/C-plan-keyword/pm" -name '*.html' | wc -l)"
