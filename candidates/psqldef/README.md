# psqldef

Candidate: [sqldef](https://github.com/sqldef/sqldef), in its PostgreSQL form `psqldef`. It is a declarative tool. It takes the SQL as desired state and applies the difference.

## Tools installed

Downloaded by `bin/devcontainer_post_create.sh` into `~/.local/bin`:

- Tool: `psqldef`; Source: `sqldef/sqldef` latest release, `psqldef_linux_amd64.tar.gz`; Why: The candidate CLI.

## How it deploys

1. Passes `database/` in sorted path order as one SQL stream (`scripts/ci/desired-state.sh`).
2. Runs `psqldef --apply` with host, port, user, password and database split out of `DATABASE_URL` (`scripts/ci/db-parts.sh`). `--apply` is required. Without it, psqldef only dry-runs.

## Known limits

- Release is `latest`, not pinned.
- The archive layout and the `-W` password flag are assumed. The first matrix run checks them.
