# Candidates

Each folder under `candidates/` is one candidate. The **Candidates** workflow (`.github/workflows/candidates.yml`) runs one job per folder that contains `bin/deploy.sh`.

## Contract

| File | Required | Purpose |
|---|---|---|
| `bin/deploy.sh` | yes | Deploys the shared `database/` tree to `$DATABASE_URL`. Exit non-zero on failure. Log to stdout and stderr. |
| `bin/devcontainer_post_create.sh` | yes | Installs the candidate's tools. Idempotent. Runs in the devcontainer and in CI before `deploy.sh`. |
| `README.md` | yes | Lists the tools the install step installs, and how the candidate is run. |
| `working_folder/` | no | Scratch files. Disposable. |

Environment provided by CI:

- `DATABASE_URL`: the candidate's own database (`bakeoff_<name>`, with `-` replaced by `_`), on Postgres 16.

CI captures these after every run, including failed runs, and uploads them as the `candidate-<name>` artifact:

- `test_results/test_logs.log`: timestamped log of create, install, deploy, and capture.
- `test_results/sql_dump.sql`: schema-only `pg_dump`, or a placeholder if the dump failed.
- `test_results/objects.tsv`: every schema, table, view, sequence, index, function, procedure, constraint, and trigger.
- `test_results/status.txt`: outcome of each step.

Shared helpers in `scripts/ci/`:

- `desired-state.sh`: prints `database/` concatenated in sorted path order. Naive input for tools that need one SQL stream.
