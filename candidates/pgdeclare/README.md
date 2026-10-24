# pgdeclare

Candidate: [pgdeclare](https://github.com/powertime-org/pgdeclare) from Powertime. It is a declarative tool. It builds the SQL files in a scratch plan database, diffs that against the target through `pg_catalog`, and applies the difference. Statements that fail on a missing dependency are retried until everything succeeds.

The round-2 evaluation shortlists it conditionally. Its `@migrate-before` and `@migrate-after` blocks are imperative escape hatches. This schema uses none, so they play no part in the result.

## Tools installed

Installed by `bin/devcontainer_post_create.sh` with `uv tool install` into `~/.local/bin`:

- Tool: `pgdeclare`; Source: PyPI, `pgdeclare==0.1.1`; Why: The candidate. Needs Python 3.12 or later, which `uv` provides.

## How it deploys

1. Builds `working_folder/sql/schemas/` from symlinks to every folder of `database/` except `Schemas/`. pgdeclare reads `<sql-dir>/schemas/` recursively. The links keep the shared tree as the only copy (ADR 0004).
2. Passes each schema in `database/Schemas/` with `--schema`. pgdeclare creates those schemas itself, and a `CREATE SCHEMA` in the files then fails as a duplicate. That is why `Schemas/` is not linked.
3. Sets `search_path` to those schemas through `PGOPTIONS`.
4. Runs `pgdeclare apply --database-url <target> --sql-dir working_folder/sql`. pgdeclare creates and drops its own plan database, which needs `CREATEDB`.

## Known limits

- Steps 2 and 3 adapt the input to the tool. pgdeclare's DDL uses unqualified names, so without `search_path` every table, foreign key and view fails with `relation ... does not exist`. Its documentation defaults to managing `public`, which is always on the path.
- The `Schemas/` files are replaced by `--schema` flags, so `CREATE SCHEMA` comes from the tool, not the SQL.
- Version 0.1.x. Upstream says backwards compatibility may not hold until 1.0.
- Local run against Postgres 16 (2026-10-24): deploy succeeds and converges (a second diff is empty), and the objects match the reference.
