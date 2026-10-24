# pgschema

Candidate: [pgschema](https://github.com/pgplex/pgschema) from pgplex. It is a declarative tool. A SQL file is the desired state of one schema, and pgschema plans and applies the difference, Terraform-style.

## Tools installed

Downloaded by `bin/devcontainer_post_create.sh` into `~/.local/bin`:

- Tool: `pgschema`; Source: `pgplex/pgschema` release `v1.13.3`, `pgschema-1.13.3-linux-amd64`, checked against the release's `pgschema-1.13.3-checksums.txt`; Why: The candidate CLI.

Also used from the system: `psql`.

## How it deploys

1. Applies `database/Schemas/` with `psql`. pgschema manages the objects inside a schema, and refuses to plan one that does not exist yet.
2. For each schema, concatenates that schema's files (`<schema>.*.sql`) in sorted path order.
3. Runs `pgschema apply --auto-approve --schema <schema> --file <that file>`, in the order `database/Schemas/` sorts. pgschema validates the desired state in its embedded Postgres, then applies the plan.

## Known limits

- Step 1 is outside the tool. pgschema does not create the schema it manages.
- pgschema loads the file into a temporary schema in the order given, so it does not solve ordering. `sales` fails on the sorted order: `Foreign Keys/` comes before `Tables/`.
- One schema per run. The embedded plan database holds only the schema being planned, so a reference to another schema fails even in dependency order. Local run: `sales` fails with `schema "inventory" does not exist` from `sales.order_detail`'s foreign key to `inventory.product`. Upstream suggests `--plan-host` (an external plan database) or `.pgschemaignore` for this. Neither is used yet.
- Local run against Postgres 16 (2026-10-24): `audit` and `inventory` apply, `sales` fails, objects check fails.
