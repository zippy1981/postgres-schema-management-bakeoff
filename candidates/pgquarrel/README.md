# pgquarrel

Candidate: [pgquarrel](https://github.com/eulerto/pgquarrel). It compares two PostgreSQL databases and prints the ALTER statements that turn the first into the second.

## Tools installed

Built from source by `bin/devcontainer_post_create.sh` with CMake, installed to `~/.local/bin`:

- `pgquarrel`: built from `github.com/eulerto/pgquarrel` (default branch, shallow clone). This is the candidate.
- `postgresql-server-dev-all`: installed with apt on every run. Provides `pg_config` and `libpgport.a`. The earlier `libpq-dev` alone was not enough.
- `cmake`, `make`, `git`: must already be on the runner.

## How it deploys

1. Creates a scratch database and loads `database/` into it, in sorted path order (`scripts/ci/desired-state.sh`).
2. Runs `pgquarrel` with the candidate database as source and the scratch database as target.
3. Applies the ALTER script to the candidate database.

## Known limits

- Built from the default branch, not a tag. Pin a tag once one is chosen.
- Step 1 uses the naive sorted load, the same limit as migra and psqldef. A failure there is a loader failure, not a pgquarrel result.
- Flags are `--source-dbname` and `--target-dbname`, checked against the upstream README.
- The project's `cmake_minimum_required` is below 3.5, which current CMake rejects. The hook passes `-DCMAKE_POLICY_VERSION_MINIMUM=3.5` to work around it.
