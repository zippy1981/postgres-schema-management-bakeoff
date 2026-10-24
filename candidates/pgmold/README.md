# pgmold

Candidate: [pgmold](https://github.com/fmguerreiro/pgmold). It is a declarative tool. It parses SQL DDL files as the desired state, diffs them against the live database, and applies the plan in one transaction.

## Tools installed

Downloaded by `bin/devcontainer_post_create.sh` into `~/.local/bin`:

- Tool: `pgmold`; Source: `fmguerreiro/pgmold` release `v0.34.17`, `pgmold-x86_64-unknown-linux-gnu.tar.gz`, checked against the release's `checksums-sha256.txt`; Why: The candidate CLI. The round-2 evaluation says to pin it because the project is young.

## How it deploys

`pgmold apply --schema sql:database/ --target-schemas audit,inventory,sales --verify-after-apply`, with the tree passed unchanged. pgmold reads the directory recursively and parses the SQL itself, so file order is its problem, not the input's.

- `--target-schemas` is built from `database/Schemas/`. The default is `public` only. Without it, pgmold reports "No changes to apply" against an empty database.
- `--verify-after-apply` re-reads the database and fails if anything still differs from the files.

## Known limits

- pgmold's SQL parser rejects `CREATE PROCEDURE ... AS $$ ... $$`, so the whole run stops before planning. This was the open question in the round-2 evaluation.
- With `Procedures/` left out, in a local test only (not what `deploy.sh` does): the two `ALTER TABLE ... ADD CONSTRAINT` files in `Foreign Keys/` are silently skipped, and `--verify-after-apply` reports both views as still differing after apply.
- Upstream says it is tested on PostgreSQL 13 to 17.
- Local run against Postgres 16 (2026-10-24): deploy fails on the procedure, objects check fails.
