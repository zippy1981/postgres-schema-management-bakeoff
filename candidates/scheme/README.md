# scheme

Candidate: [scheme](https://github.com/nvcnvn/scheme). A declarative PostgreSQL schema migration tool. You write `schema.sql`, scheme loads it into a clean database, then diffs that against the live database and applies the result.

## Tools installed

Installed with `go install` into `~/.local/bin` by `bin/devcontainer_post_create.sh`:

- `scheme`, from `github.com/nvcnvn/scheme/cmd/scheme@latest`. This is the candidate. Version not pinned.

## How it deploys

1. Writes `database/` to one file in sorted order.
2. `scheme apply --file <file> --url $DATABASE_URL --dev-url <dev database>`.

## Known limits

- Repo has 0 stars and was last pushed 2026-03-07. Maturity is low.
- The `--file` and `--dev-url` flags come from the README's examples, which show `--dev-url` for an existing database. The first matrix run checks them.
