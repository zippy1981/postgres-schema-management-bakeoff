# pg-delta

Candidate: [pg-delta](https://github.com/supabase/pg-toolbelt), published as `@supabase/pg-delta`. A TypeScript diff and migration engine for PostgreSQL. Its CLI can apply a directory of `.sql` files, using a shadow database to normalise them.

## Tools installed

Installed globally with npm by `bin/devcontainer_post_create.sh`:

- `@supabase/pg-delta`, which provides the `pgdelta` CLI. This is the candidate. Version not pinned.

Needs Node.js and npm, which the devcontainer feature provides.

## How it deploys

1. Creates a shadow database.
2. `pgdelta schema apply --dir database --shadow <shadow> --target $DATABASE_URL`.

## Disqualification check

Not disqualified on input: it reads `.sql` files. Its README also describes a migration plan file workflow (`pgdelta plan` then `pgdelta apply --plan`). This test uses the `schema apply` path, which applies the desired state directly. The plan-file path is not tested.

## Known limits

- Flags come from the package README and the CLI summary. The first matrix run checks them.
