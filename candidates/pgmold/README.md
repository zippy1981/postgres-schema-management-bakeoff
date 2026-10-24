# pgmold

Candidate: [pgmold](https://github.com/fmguerreiro/pgmold). PostgreSQL schema-as-code. It diffs a SQL file against a live database, then plans and applies the delta.

## Tools installed

Built with `cargo install --locked` by `bin/devcontainer_post_create.sh`, into `~/.local/bin`:

- `pgmold`, from crates.io, latest. This is the candidate. Version not pinned.

GitHub's `ubuntu-latest` has a Rust toolchain. The first build is slow.

## How it deploys

1. Writes `database/` to one file in sorted order (`scripts/ci/desired-state.sh`).
2. Runs `pgmold apply -s sql:<file> -d $DATABASE_URL`.

## Known limits

- The input is the sorted-order concatenation, so the ordering is pgmold's job.
- Flags come from the upstream README.
