# pg-schema-diff

Candidate: [pg-schema-diff](https://github.com/stripe/pg-schema-diff) from Stripe. It plans and applies the difference between a directory of SQL files and a live database.

## Tools installed

Built by `bin/devcontainer_post_create.sh` with `go install` into `~/.local/bin`:

- Tool: `pg-schema-diff`; Source: `github.com/stripe/pg-schema-diff/cmd/pg-schema-diff@latest`; Why: The candidate.

Needs the Go toolchain on `PATH`. GitHub's `ubuntu-latest` runner has one. The devcontainer does not, so this hook stops there.

## How it deploys

`pg-schema-diff apply --from-dsn "$DATABASE_URL" --to-dir database`, with the tree passed unchanged. This tests whether the tool orders the files itself.

## Known limits

- Version is `@latest`, not pinned. Pin it once a version is chosen.
- Flags checked against the upstream README: `apply --from-dsn` and `--to-dir`. `--version` does not exist, so the install hook no longer calls it.
