# Agents

Agents are the specialist roles that do the bake-off work. Each agent is defined in `agents/<slug>.md` with YAML front matter (`name`, `description`) followed by sections: Purpose, Inputs, Responsibilities, Boundaries, Handoffs, Done when.

The `orchestrator` coordinates the others: it plans the work, delegates by name, runs independent work in parallel on separate branches, verifies reports, and decides merges.

## Roster

| Agent | File | Responsibility | Owns |
| --- | --- | --- | --- |
| `orchestrator` | `agents/orchestrator.md` | Plans the bake-off, delegates, sequences and parallelizes work, verifies reports, decides merges, enforces file ownership. | `agents/orchestrator.md`, `agents/README.md` |
| `adr-author` | `agents/adr-author.md` | Writes and updates architecture decision records. | `docs/adr/` |
| `schema-author` | `agents/schema-author.md` | Writes plain SQL schema objects, one object per file, named after the object. | `database/` |
| `migration-runner` | `agents/migration-runner.md` | Applies the shared `database/` schema to each candidate's own database and reports the result. | Candidate `test_results/` and `working_folder/` output for migration runs |
| `postgres-admin` | `agents/postgres-admin.md` | Manages the Postgres server, roles, and database lifecycle (create, reset, drop), reporting before any destructive step. | Database server setup and lifecycle scripts |
| `devcontainer-manager` | `agents/devcontainer-manager.md` | Maintains the dev container and its Postgres services. | `.devcontainer/` |
| `agent-skill-manager` | `agents/agent-skill-manager.md` | Creates and maintains agent definitions and skills. | `agents/` (other than the orchestrator's own files), `skills/` |

## Ownership rules

- Each agent edits only the paths it owns. Changes outside those paths go back to the owner.
- The orchestrator does not write schema SQL, ADRs, or migrations, and does not run migrations or drop databases without the owning agent's report.
- Candidates under `candidates/<CANDIDATE_NAME>/` are created only when the user names them.

## Adding an agent

Use `agent-skill-manager`. It creates `agents/<slug>.md` with the required front matter and sections, adds the row to this roster, and checks that the new agent's owned paths do not overlap an existing owner.
