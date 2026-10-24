# pgquarrel

Candidate: [pgquarrel](https://github.com/eulerto/pgquarrel). It compares two PostgreSQL dumps and prints the ALTER statements that turn the first into the second.

## Tools installed

Built from source by `bin/devcontainer_post_create.sh` into `~/.local/bin`:

| Tool | Source | Why |
|---|---|---|
| `pgquarrel` | `github.com/eulerto/pgquarrel`, default branch, shallow clone | The candidate. |
| `libpq-dev` | apt, only when `pg_config` is missing | Headers for the build. |
| `make`, `gcc`, `git` | Already on the runner | Build and fetch. |

## How it deploys

1. Compares an empty dump with `database/` in sorted path order.
2. Applies the resulting ALTER script to the target.

## Known limits

- Built from the default branch, not a tag. Pin a tag once one is chosen.
- The `--source-dump` and `--target-dump` flags are written from memory and are unverified.
