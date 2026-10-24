# migra

Candidate: [migra](https://github.com/djrobstep/migra). It diffs two databases and prints the SQL that turns one into the other.

## Tools installed

Installed by `bin/devcontainer_post_create.sh` with `uv tool install` into `~/.local/bin`:

| Tool | Source | Why |
|---|---|---|
| `migra` | PyPI, latest | The candidate. Diffs the target against a shadow database. |
| `psycopg2-binary` | PyPI, injected with `--with` | Postgres driver that migra imports. |

Also used from the system: `psql`.

## How it deploys

1. Loads `database/` into a shadow database, in sorted path order (`scripts/ci/desired-state.sh`).
2. Runs `migra --unsafe` from the empty target to the shadow.
3. Applies the printed SQL to the target.

Step 1 is where this candidate depends on file order. The sorted order puts `Foreign Keys/` before `Tables/`, so loading the shadow is expected to fail on the alphabetical traps.

## Known limits

- The shadow database is loaded with `psql`, so migra does not solve ordering. That is a limit of the candidate, and the result should say so.
- Versions are not pinned yet. The install log records what `uv` resolved.
