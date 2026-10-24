# Postgres Schema Management Bake-off: Plan

## 1. Goal and rules for this round

**Goal.** Compare Postgres schema management approaches for Python projects on one shared, realistic schema. Each candidate must deploy that schema to its own database and leave evidence (logs, exit codes, a schema dump) that can be compared fairly.

**Rules for this round:**

- The schema is plain SQL only.
- The schema lives in `database/` in an SSDT-style layout: one object per file, named after the object (for example `database/Tables/sales.customer.sql`).
- No migration-based deployment. Candidates must deploy from the declarative SQL source, not from a chain of versioned migration scripts.
- No ORMs.
- Nothing is stored outside SQL. No schema definitions in YAML, Python models, or generated files that become a second source of truth.
- One shared copy of the schema. Every candidate reads the same `database/` folder.
- Each candidate migrates its own database. Databases are isolated by name inside the shared Postgres compose service.
- Candidates are never named in this plan. Each candidate lives in its own folder and is evaluated against the rules above, not against this document.

## 2. Repository layout

```
.devcontainer/                 Dev container definition (compose service "app" + "db")
  devcontainer.json
  docker-compose.yml
  Dockerfile
  post_create.sh               (new) loops over candidates/*/bin/devcontainer_post_create.sh
docs/
  plan.md                      this document
  adr/                         Architecture Decision Records (NNNN-title.md)
database/                      The single shared schema, SSDT-style, plain SQL
  Schemas/                     CREATE SCHEMA files
  Tables/                      <schema>.<table>.sql
  Views/                       <schema>.<view>.sql
  Procedures/                  <schema>.<procedure>.sql
  Functions/                   (reserved; not required by the test schema unless added)
candidates/
  <CANDIDATE_NAME>/            One folder per candidate (created by the team, not by this plan)
    bin/                       Scripts: deploy, reset, dump, run-and-capture
    bin/devcontainer_post_create.sh
    working_folder/            Candidate working files (config, scratch, tool state)
    test_results/
      test_logs.log            Timestamped run log with exit codes
      sql_dump.sql             Deterministic schema dump after deployment
agents/                        Agent definitions (standard location; NOT .claude/)
  orchestrator.md
  adr-author.md
  schema-author.md
  migration-runner.md
  postgres-admin.md
  agent-skill-manager.md
  devcontainer-manager.md
skills/                        Skills, one folder each
  <name>/SKILL.md
```

Notes:

- `database/` is the only schema source. Nothing under `candidates/` may hold a copy of it. Candidates reference it by path.
- `candidates/` holds only candidate-specific material. A candidate's `working_folder/` should be treated as disposable; `test_results/` is the deliverable.
- `agents/` and `skills/` sit at the repository root, not under `.claude/`.

## 3. Test schema requirements

The test schema must be realistic enough to expose ordering and dependency problems. It must include the following, in one shared `database/` tree.

1. **Multiple schemas.** At least three PostgreSQL schemas (for example `sales`, `inventory`, `audit`). Objects are qualified with their schema, and cross-schema foreign keys are required.
2. **Alphabetical-order trap.** A table that sorts alphabetically before another table must hold a foreign key to the later one, which owns the primary key. A naive "create files in alphabetical order" deployment fails here. Example: `sales.order_line` sorts before `sales.order_header`, but `order_line` references `order_header`.
3. **Circular foreign key.** Two tables that reference each other (for example `sales.department` has `manager_id` referencing `sales.employee`, and `sales.employee` has `department_id` referencing `sales.department`). Deployment must resolve this, typically with `ALTER TABLE ... ADD CONSTRAINT` after both tables exist.
4. **Self-referencing foreign keys.** At least one table with a parent reference to itself (for example `inventory.category.parent_id`), including a hierarchy that can be queried.
5. **Views.** At least one view that depends on tables in two schemas, and at least one view that depends on another view. Dependency order matters.
6. **Stored procedures.** At least one `CREATE PROCEDURE` (not a function) that writes to a table, so that deployment checks that the body compiles against the tables.
7. **One object per file.** Each file contains exactly one database object and is named after it. No file contains two tables, and no table is split across files.

The schema does not need business depth. It needs to be correct, small enough to read, and deterministic.

## 4. Agent roster

Each agent has one purpose, a set of owned paths, and explicit handoffs. An agent edits only the paths it owns.

### orchestrator

- **Purpose.** Breaks the round into tasks, assigns them to agents and branches, checks that each branch stays inside its owned files, and drives the merge order.
- **Owned paths.** `agents/orchestrator.md`. Read access to everything.
- **Handoffs.** Receives requests from the user. Hands ADR work to `adr-author`, schema work to `schema-author`, run work to `migration-runner`, database lifecycle work to `postgres-admin`, skill work to `agent-skill-manager`, and environment work to `devcontainer-manager`.

### adr-author

- **Purpose.** Records significant decisions as ADRs (for example, the rules in section 1, the layout in section 2, and the choice of Postgres version).
- **Owned paths.** `docs/adr/`.
- **Handoffs.** Takes decision requests from `orchestrator`. Returns ADR paths to `orchestrator`. Does not edit `docs/plan.md`.

### schema-author

- **Purpose.** Writes and maintains the shared SSDT-style SQL under `database/`, meeting section 3.
- **Owned paths.** `database/`.
- **Handoffs.** Receives object requirements from `orchestrator`. Hands a finished schema to `migration-runner` for deployment checks. Asks `postgres-admin` when an object needs a Postgres feature the chosen version may not support.

### migration-runner

- **Purpose.** Runs each candidate's deploy and capture scripts against that candidate's own database. Records timestamped logs, exit codes, and the schema dump.
- **Owned paths.** Writes run output to `candidates/<CANDIDATE_NAME>/test_results/` only. Does not change candidate code.
- **Handoffs.** Requests database create, reset, and drop from `postgres-admin`. Reports failures to `schema-author` (for SQL defects) or to `orchestrator` (for candidate defects).

### postgres-admin

- **Purpose.** Manages the named databases in the compose `db` service: create, reset, drop, and confirm the Postgres version. Provides the lifecycle that `migration-runner` depends on.
- **Owned paths.** Lifecycle scripts only, placed in `.devcontainer/` or a shared script path agreed with `orchestrator`. Does not change candidate-owned `bin/` scripts.
- **Handoffs.** Serves `migration-runner` and `devcontainer-manager`. Reports the running Postgres version to `orchestrator` for the version pin decision.

### agent-skill-manager

- **Purpose.** Creates, updates, and retires skills under `skills/` and keeps agent definitions in sync with the skills they use.
- **Owned paths.** `skills/`, and the skill references inside `agents/` (but not the agent role text, which belongs to `orchestrator` and the owning agent).
- **Handoffs.** Receives skill requests from `orchestrator`. Checks that each skill named in section 7 has an owner.

### devcontainer-manager

- **Purpose.** Owns the dev container: `uv` for Python tooling, `postCreateCommand`, and the candidate post-create hook loop.
- **Owned paths.** `.devcontainer/` (except lifecycle scripts owned by `postgres-admin`).
- **Handoffs.** Receives candidate hook requirements from `orchestrator`. Coordinates with `postgres-admin` when post-create needs database setup.

## 5. Devcontainer changes

1. **Python tooling through `uv`.** Install `uv` in the image (`Dockerfile`) or in `post_create.sh`. Use `uv` for every Python tool, and do not use bare `pip install`. Pin `uv` to an exact version.
2. **`postCreateCommand`.** Add to `.devcontainer/devcontainer.json`:

   ```json
   "postCreateCommand": "bash .devcontainer/post_create.sh"
   ```

3. **`.devcontainer/post_create.sh`.** Loops over each candidate and runs its hook, if present:

   ```bash
   for hook in candidates/*/bin/devcontainer_post_create.sh; do
     [ -f "$hook" ] || continue
     bash "$hook" || exit 1
   done
   ```

   The script must fail loudly on a non-zero exit from any candidate hook, and must print which candidate it is running.
4. **Existing features.** Keep the Claude Code feature. Keep the compose file as is, except as needed for the Postgres version pin (section 8).

## 6. Parallel branch plan

Eight branches run in parallel. Each owns a disjoint set of files, so no two branches conflict on content.

| Branch | Owns | Purpose |
|---|---|---|
| `docs/adr-process` | `docs/adr/` | ADR template and first ADRs (rules, layout, Postgres version) |
| `agents/orchestrator` | `agents/orchestrator.md` | Orchestrator role definition |
| `agents/schema-author` | `agents/schema-author.md`, `database/` | Schema author role and the initial SSDT-style schema |
| `agents/migration-runner` | `agents/migration-runner.md` | Migration runner role definition |
| `agents/postgres-admin` | `agents/postgres-admin.md`, DB lifecycle scripts | Postgres admin role and database lifecycle |
| `agents/agent-skill-manager` | `agents/agent-skill-manager.md`, `skills/` | Skill manager role and skill files |
| `devcontainer/uv-and-candidate-hooks` | `.devcontainer/` | `uv`, `postCreateCommand`, `post_create.sh` |
| `docs/plan` | `docs/plan.md` | This plan |

Rules for parallel work:

- A branch edits only the paths it owns. Anything outside them goes back to `orchestrator`.
- `agents/devcontainer-manager.md` and `agents/adr-author.md` are not in the table. Assign them to `agents/orchestrator` or to a follow-up branch before work starts.
- `candidates/` is not touched by any of the eight branches. Candidate branches are created separately.

**Suggested merge order:**

1. `docs/adr-process`. Records the decisions everything else depends on.
2. `docs/plan`. Puts the plan in place for reviewers.
3. `devcontainer/uv-and-candidate-hooks`. The environment must exist before anything runs.
4. `agents/postgres-admin`. Database lifecycle must exist before runs.
5. `agents/schema-author`. Schema content, which runs depend on.
6. `agents/migration-runner`. Depends on the schema and the lifecycle.
7. `agents/agent-skill-manager`. Skills are referenced by agents, so they land after the agents exist; if an agent file references a skill that is not yet merged, merge the skill first.
8. `agents/orchestrator`. Last, because it routes work to all the others.

## 7. Skills needed

These are suggestions. None is created by this plan.

| Skill name | Purpose | Used by |
|---|---|---|
| `sql-layout-ssdt` | SSDT-style layout: one object per file, filename = `<schema>.<object>.sql`, folder per object type, deterministic ordering of files. | `schema-author`, `orchestrator` |
| `postgres-ddl-authoring` | Writing PostgreSQL DDL that deploys in any file order: FK ordering, circular references via deferred `ALTER TABLE ... ADD CONSTRAINT`, self-referencing FKs, view dependency order, procedure bodies. | `schema-author` |
| `pg-schema-dump` | Deterministic schema dump with `pg_dump --schema-only`: fixed option set (for example `--schema-only --no-owner --no-privileges --no-comments` as decided in an ADR), sorted output, stable across runs. | `migration-runner`, `postgres-admin` |
| `postgres-database-lifecycle` | Create, reset, and drop named databases in the compose `db` service; check the server version; wait for readiness. | `postgres-admin`, `migration-runner` |
| `candidate-run-and-capture` | Run a candidate's deploy and capture to `test_results/test_logs.log` with timestamps, exit codes, and step names; write `sql_dump.sql`. | `migration-runner` |
| `adr-authoring` | ADR template, numbering in `docs/adr/`, status fields, and linking ADRs from the plan. | `adr-author`, `orchestrator` |
| `agent-definition-authoring` | Structure of `agents/*.md`: purpose, owned paths, handoffs, tool limits. | `agent-skill-manager`, `orchestrator` |
| `uv-devcontainer-post-create` | `uv` installation and pinning, `postCreateCommand`, the candidate hook loop, and fail-loud behaviour. | `devcontainer-manager` |

## 8. Open questions for the user

1. **Is the test schema authored in this round?** Section 3 describes it, but this plan does not write it. Should `schema-author` produce the full schema now, or only the layout and a first slice?
2. **Postgres version pin.** `.devcontainer/docker-compose.yml` uses `postgres:latest`, which is not reproducible. Which exact major version should be pinned (for example `postgres:17`), and should an ADR record it?
3. **`pg_dump` option set.** Which flags define the deterministic dump? Should the comparison ignore owners, privileges, and comments, or keep them?
4. **Candidate hook contract.** Is `bin/devcontainer_post_create.sh` required for every candidate, or optional? Should the loop fail the container build when a hook fails?
5. **Database naming.** Should each candidate use a database named after the candidate (for example one database per candidate), and who owns that naming rule?
6. **Missing owners.** `agents/devcontainer-manager.md` and `agents/adr-author.md` have no branch in section 6. Should they be added to an existing branch or to a new one?
7. **`uv` installation point.** Install `uv` in the Dockerfile (image rebuild on change) or in `post_create.sh` (slower container creation)?
