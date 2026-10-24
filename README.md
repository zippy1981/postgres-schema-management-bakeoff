# Postgres schema management bake-off

Compares Postgres schema management tools on one shared, realistic schema. Each candidate deploys the same SQL source to its own database and leaves evidence that can be compared.

## Status

[![Candidates](https://github.com/zippy1981/postgres-schema-management-bakeoff/actions/workflows/candidates.yml/badge.svg?branch=main)](https://github.com/zippy1981/postgres-schema-management-bakeoff/actions/workflows/candidates.yml)
[![SQL lint](https://github.com/zippy1981/postgres-schema-management-bakeoff/actions/workflows/sql-lint.yml/badge.svg?branch=main)](https://github.com/zippy1981/postgres-schema-management-bakeoff/actions/workflows/sql-lint.yml)
[![Lint Markdown](https://github.com/zippy1981/postgres-schema-management-bakeoff/actions/workflows/markdown-lint.yml/badge.svg?branch=main)](https://github.com/zippy1981/postgres-schema-management-bakeoff/actions/workflows/markdown-lint.yml)

- **Candidates:** one job per folder under `candidates/`. Results are in the `candidate-<name>` artifacts. The report is the `bakeoff-report` artifact.
- **SQL lint:** sqlfluff over `database/`. A failure blocks a PR.
- **Lint Markdown:** markdownlint over every `.md` file.

## Where to look

- [`docs/plan.md`](docs/plan.md): the rules, the schema requirements, and the agent roster.
- [`docs/candidates.md`](docs/candidates.md): the shortlist and the excluded tools.
- [`candidates/README.md`](candidates/README.md): the contract each candidate follows.
- [`docs/adr/`](docs/adr/): architecture decision records.
