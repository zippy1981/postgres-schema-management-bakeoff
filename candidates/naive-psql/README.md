# naive-psql

Control, not a tool. It loads `database/` with `psql` in sorted path order, with no dependency analysis.

## Tools installed

None beyond the system `psql`. `bin/devcontainer_post_create.sh` only prints its version.

## How it deploys

`scripts/ci/desired-state.sh database | psql "$DATABASE_URL" -v ON_ERROR_STOP=1`

## Expected result

Fails on the first statement that needs an object created later. The sorted order puts `Foreign Keys/` before `Tables/`. This is the trap from `docs/plan.md` section 3, and it is kept so the matrix shows the failure.
