# Candidate shortlist for the bake-off

This is a proposed shortlist. Nothing here creates a folder under `candidates/`. Per `agents/README.md`, a candidate is created only when the user names it.

Every candidate must deploy the shared `database/` tree (`docs/plan.md` section 1) without migration scripts, ORMs, or YAML or Python schema definitions. That excludes migration-first tools such as Flyway, Liquibase changelogs, Sqitch, dbmate, golang-migrate, and pgroll, and YAML-first tools such as Pyrseas and SchemaHero. They are left out below.

The entries are from general knowledge and have not been checked against current releases. Each entry needs a version pin and a check of its SQL-file input support before a candidate folder is created.

## Candidates

| # | Tool | Language / form | How it reads `database/` | Notes |
|---|------|-----------------|--------------------------|-------|
| 1 | [migra](https://github.com/djrobstep/migra) | Python CLI library | Apply `database/` to a scratch database, then diff it against the target | Diff tool. Deploy is `migra --unsafe` or the printed SQL. Needs a shadow DB step. |
| 2 | [pg-schema-diff](https://github.com/stripe/pg-schema-diff) (Stripe) | Go CLI | Takes a directory of SQL files as the desired schema (`--to-dir`) | Plans and applies the diff. Designed for declarative SQL input. |
| 3 | [Atlas](https://atlasgo.io) (Ariga) | Go CLI | Desired state as SQL files (`file://` source) | Declarative `schema apply`. Also has a migration mode, which the rules exclude. Confirm the SQL-source mode is enabled for the pinned version. |
| 4 | pgschema (URL not confirmed) | Go CLI | Desired state as a SQL file | Declarative Postgres tool. Newer than the others here, so check its maturity. |
| 5 | [sqldef / psqldef](https://github.com/sqldef/sqldef) | Go CLI | Desired state as a SQL file on stdin | Declarative. Covers PostgreSQL alongside MySQL and SQLite. |
| 6 | [pgquarrel](https://github.com/eulerto/pgquarrel) | C CLI | Compares two SQL schema directories | Diff tool. Outputs an ALTER script from `database/` to a reference. |
| 7 | [apgdiff](https://www.apgdiff.com) | Java CLI | Compares two SQL dump files | Diff tool. Needs `database/` concatenated into one dump, which may break the one-object-per-file rule. Check it. |
| 8 | Custom ordered `psql` loader | Bash | Applies files in an explicit dependency order (`Schemas/`, `Tables/`, `Foreign Keys/`, `Views/`, `Procedures/`) | Control: a hand-written order, not a tool. It shows what dependency ordering costs without a tool's help. |
| 9 | Naive sorted `psql` loader | Bash | Applies every file in sorted path order | Negative control. The plan's section 3 schema is expected to fail it. Included only to show the trap. |

Entries 8 and 9 are controls, not candidates. Entries 1 to 7 are the candidates. That is seven candidates with two controls, under the limit of a dozen.

## Excluded

| Tool | Reason |
|------|--------|
| Flyway, Liquibase (changelog mode), Sqitch, dbmate, golang-migrate, pgroll | Migration-first. Section 1 rules out deploying from versioned scripts. |
| Pyrseas, SchemaHero | Schema defined in YAML. Section 1 rules this out. |
| Alembic, SQLAlchemy, Django migrations | ORM or Python model source. Section 1 rules this out. |
| Redgate SQL Compare and SSDT | SQL Server tooling. The layout comes from SSDT, but the tools do not target PostgreSQL. |

## Open decisions

- Whether `pg-schema-diff`, `pgquarrel`, and `apgdiff` (diff tools) count as candidates or only as comparison helpers. The plan does not say. Each is listed as a candidate here, because each deploys from SQL source once a shadow database is involved.
- Whether a candidate may run its own shadow database. That affects the database naming question in `docs/plan.md` section 8.
