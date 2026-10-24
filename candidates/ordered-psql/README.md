# ordered-psql

Control, not a tool. It loads `database/` with `psql`, in a dependency order that a person wrote by hand.

## Tools installed

None beyond the system `psql`. `bin/devcontainer_post_create.sh` only prints its version.

## How it deploys

`bin/deploy.sh` lists every file in dependency order and applies each with `psql -v ON_ERROR_STOP=1`.

## Expected result

Passes on the current schema. It is the reference for what a correct order looks like, so any tool that fails where this passes has missed a dependency. It breaks if the schema changes and the list is not updated, which is part of what the bake-off measures.
