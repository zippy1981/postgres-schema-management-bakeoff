# pgschema

Candidate: [pgschema](https://github.com/pgplex/pgschema). A Terraform-style declarative tool for PostgreSQL. You keep the desired schema as one SQL file, then `plan` and `apply` against the live database.

## Tools installed

Installed with `go install` into `~/.local/bin` by `bin/devcontainer_post_create.sh`:

- `pgschema`, from `github.com/pgplex/pgschema@latest`. This is the candidate. Version not pinned.

Needs the Go toolchain on `PATH`. GitHub's `ubuntu-latest` has one.

## How it deploys

1. Writes `database/` to one file in sorted order (`scripts/ci/desired-state.sh`). The tool is not given an order.
2. Runs `pgschema apply` once for each of `sales`, `inventory` and `audit`, because pgschema manages one schema per run.

## Known limits

- One schema per run. A cross-schema foreign key may fail on the first schema's run, before the other schema exists.
- Flags come from the upstream README, except `--auto-approve`, which is unverified.
