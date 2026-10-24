# dummy-fail

Test candidate. It always fails, on purpose, after creating the three schemas.

## Tools installed

None. `bin/devcontainer_post_create.sh` only prints a message.

## Purpose

Shows that a failing candidate:

- makes its matrix job fail,
- still produces `sql_dump.sql` and `objects.tsv`,
- appears in the bake-off report.
