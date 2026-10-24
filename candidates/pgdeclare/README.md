# pgdeclare

Candidate: [pgdeclare](https://github.com/powertime-org/pgdeclare). A declarative differ that builds your SQL files in a scratch database, then introspects it and diffs the result against the live database.

## Tools installed

Installed by `bin/devcontainer_post_create.sh` with `uv tool install`, into `~/.local/bin`:

- `pgdeclare`, from PyPI, latest. This is the candidate. Version not pinned.

## How it deploys

1. `pgdeclare apply --dry-run`, to show the plan.
2. `pgdeclare apply`, to converge the database.

## Disqualification check

The README describes `@migrate-before` and `@migrate-after` blocks. They are imperative steps that run against the live database, so they bend the plan's declarative rule. A run is only counted as declarative if it does not use them. This test schema has none.

## Known limits

- The README does not say which directory `apply` reads. The first matrix run shows whether the default works.
