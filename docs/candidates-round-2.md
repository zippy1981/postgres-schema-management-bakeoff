# Candidate evaluation, round 2

This evaluates 24 tools. Twelve are new declarative candidates. Twelve are names that came up in the search and fail the plan's rules, so they are recorded with the rule that rejects them.

Nothing here creates a `candidates/` folder. Per `agents/README.md`, a candidate folder is created only when the user names it.

## Method

Names came from GitHub repo lookups and web roundups. Each repo was checked with `gh api`, on 2026-10-24, for stars, last push, archive state, language and license. The READMEs were read for the input format and install path.

The plan's rules, in `docs/plan.md` section 1, are applied as screens:

- **R1, plain SQL input.** The desired schema is SQL. YAML, an ORM model, or a platform's own format fails this.
- **R2, declarative deploy.** The deploy comes from the SQL source, not from a chain of migration scripts.
- **R3, PostgreSQL.** The tool targets PostgreSQL.
- **R4, open licence.** A licence is stated, and it is open source.
- **R5, active.** The last push was within 12 months.

## Batch 1: new declarative candidates

| # | Repo | Language | Licence | Stars | Last push | Input | Install | R1 | R2 | R4 | R5 | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `pgplex/pgschema` | Go | Apache-2.0 | 1072 | 2026-10-15 | `schema.sql` desired state; dump, edit, plan, apply | Go binary | pass | pass | pass | pass | Strong. Shortlist. |
| 2 | `fmguerreiro/pgmold` | Rust | MIT | 19 | 2026-10-06 | SQL DDL as desired state; plan and apply | `cargo install pgmold` | pass | pass | pass | pass | Strong, but young. Shortlist. |
| 3 | `powertime-org/pgdeclare` | Python | Apache-2.0 | 4 | 2026-10-19 | SQL files run in a scratch database | `pip install pgdeclare` | pass | partial | pass | pass | Conditional. Its `@migrate-before` and `@migrate-after` blocks are imperative escape hatches. Shortlist if those are allowed. |
| 4 | `supabase/pg-toolbelt` (`pg-delta`) | TypeScript | PostgreSQL | 80 | 2026-10-23 | Not confirmed from the README | npm and Bun | unverified | unverified | pass | pass | Verify the input before scoring. |
| 5 | `nvcnvn/scheme` | Go | Apache-2.0 | 0 | 2026-03-07 | `schema.sql`, loaded into a clean database | Go binary | pass | pass | pass | fails | Conditional. Matches the design, but has no adoption and was last pushed in March. |
| 6 | `bikeshedder/tusker` | Rust | Apache-2.0 | 18 | 2026-10-02 | Schema diff, plus an embedded migration runner | `cargo install tusker` | pass | fails | pass | pass | Reject for pure declarative. The migration runner is the deploy path. |
| 7 | `joncrlsn/pgdiff` | Go | MIT | 507 | 2025-03-09 | Diffs two live databases; output is ALTER statements to apply by hand | Go build | fails | fails | pass | fails | Reject. Its input is two live databases, not the plan's SQL source, and it was last pushed 19 months ago. |
| 8 | `zombodb/pg-schema-diff` | Rust | not stated (`NOASSERTION`) | 19 | 2026-01-22 | Parse-tree deparser and diff | `cargo` | unverified | unverified | fails | pass | Reject until the licence is clear. |
| 9 | `lovablelabs/pg-schema-diff` | Go | MIT | 2 | 2026-03-12 | Go library. Its README and workflows are copied from Stripe's. | Go library | pass | pass | pass | pass | Reject as a fork. Its README and workflows are Stripe's, and `stripe/pg-schema-diff` is already a candidate. |
| 10 | `alxndrchernov/postgres_schema_diff` | Go | none | 0 | 2025-11-09 | Compares two SQL files | Go build | pass | fails | fails | pass | Reject. No licence. |
| 11 | `schemacrawler/SchemaCrawler` | Java | not stated (`NOASSERTION`) | 1840 | 2026-10-22 | Discovers and reports on live databases | Java jar and Docker | fails | fails | fails | pass | Reject. It is a discovery and reporting tool, not a deploy tool. |
| 12 | `omasaaki/pgsd` | Python | MIT | 0 | 2025-10-27 | Compares two live databases and writes a report | pip | fails | fails | pass | pass | Reject. It reports differences and does not deploy them. |

## Batch 2: names that fail the rules

These came up in the search, and each one fails a rule. They are recorded so the rejection is on the record.

| # | Repo | Language | Licence | Stars | Last push | Why it fails |
| --- | --- | --- | --- | --- | --- | --- |
| 13 | `ardsantos/postgres-schema-diff` | not stated | none | 0 | 2025-10-11 | No licence, no description, no adoption. |
| 14 | `amacneil/dbmate` | Go | MIT | 7482 | 2026-10-18 | Migration-first (R2). Deploys a chain of versioned SQL files. |
| 15 | `pressly/goose` | Go | `NOASSERTION` | 11614 | 2026-10-23 | Migration-first (R2). Versioned SQL and Go migrations. |
| 16 | `golang-migrate/migrate` | Go | `NOASSERTION` | 18987 | 2026-09-09 | Migration-first (R2). Versioned migration files. |
| 17 | `liquibase/liquibase` | Java | `NOASSERTION` | 5633 | 2026-10-23 | Changelog-first (R1, R2). Diffs generate changelogs, which are then applied. |
| 18 | `flyway/flyway` | Java | Apache-2.0 | 10164 | 2026-10-22 | Migration-first (R2). Versioned migrations. |
| 19 | `bytebase/bytebase` | Go | `NOASSERTION` | 14625 | 2026-10-23 | Platform (R1, R2). Change review and governance around migrations. |
| 20 | `xataio/pgroll` | Go | Apache-2.0 | 6607 | 2026-09-21 | Migration-first (R1, R2). Migration definitions in JSON or YAML. |
| 21 | `perseas/Pyrseas` (`pyrseas`) | Python | BSD-3-Clause | 405 | 2026-09-09 | YAML is the source (R1). |
| 22 | `schemahero/schemahero` | Go | Apache-2.0 | 1272 | 2026-09-19 | Kubernetes YAML is the source (R1). |
| 23 | `prisma/orm` (Prisma) | TypeScript | Apache-2.0 | 47662 | 2026-10-23 | ORM schema language is the source (R1). |
| 24 | `sqlc-dev/sqlc` | Go | MIT | 18406 | 2026-10-23 | Code generator. It does not deploy schemas, so it is off-scope. |

## Shortlist from this round

For the bake-off, the following are worth adding as candidates when you name them:

1. `pgplex/pgschema`. Its install and plan behaviour are documented, and the desired state is a plain SQL file. It was previously dropped because its install source could not be verified, and that is now resolved.
2. `fmguerreiro/pgmold`. Declarative SQL DDL, planned and applied. It is young, so pin its version.
3. `nvcnvn/scheme`, if the bake-off wants a second declarative tool with a similar design. It is the least mature of the three.
4. `powertime-org/pgdeclare`, on the condition that its imperative blocks are counted as a deviation from the rules.

Two entries need checking before a decision: `supabase/pg-toolbelt` (its input format) and `pgmold`'s behaviour with procedures, since the schema has one.

## Not yet done

- No candidate folders are created. That waits for the user to name them.
- The unverified entries are not run. Scores for them are provisional.
- Stars and push dates are a snapshot from 2026-10-24.
