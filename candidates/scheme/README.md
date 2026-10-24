# scheme

Candidate: [scheme](https://github.com/nvcnvn/scheme). It is a declarative tool, inspired by Atlas. A `schema.sql` file is the desired state. scheme loads it into a clean dev database to normalise it, diffs the target against that, and applies the changes.

The round-2 evaluation shortlists it conditionally. It fails R5 (last push 2026-03-07) and has no adoption.

## Tools installed

Built by `bin/devcontainer_post_create.sh` with `go install` into `~/.local/bin`:

- Tool: `scheme`; Source: `github.com/nvcnvn/scheme/cmd/scheme@v0.0.1`; Why: The candidate. The project publishes a tag but no release binaries.

Needs the Go toolchain on `PATH`.

## How it deploys

1. Creates a scratch dev database, `<target>_dev`.
2. Passes `database/` in sorted path order as one SQL file (`scripts/ci/desired-state.sh`).
3. Runs `scheme apply --auto-approve --url <target> --dev-url <dev> --schema <file>`.

By default scheme starts a Docker container for the dev database. `--dev-url` replaces that with the scratch database, so no Docker is needed in CI or the devcontainer.

## Known limits

- scheme runs the file as is in the dev database, so it does not solve ordering. The sorted order fails first, at `Foreign Keys/sales.*` before `CREATE SCHEMA sales`.
- In dependency order (ordered-psql's list, local test only), it still fails on the procedure. It reads `pg_get_function_result`, which is NULL for procedures: `cannot scan NULL into *string`.
- Local run against Postgres 16 (2026-10-24): deploy fails, objects check fails.
