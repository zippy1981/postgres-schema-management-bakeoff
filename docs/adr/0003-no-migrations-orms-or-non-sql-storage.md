# 0003 No migration-based deployment, ORMs, or non-SQL schema storage for this round

Status: Accepted

## Context

The bake-off asks which tools manage a Postgres schema well. Migration-based tools (numbered scripts applied in sequence), ORMs that define the schema in application code, and tools that store the schema in YAML, JSON, or other non-SQL formats all change what is being compared. Allowing them would measure how well each candidate's own paradigm fits the rules instead of how well it manages the plain SQL schema.

## Decision

For this round:

- Deployment is declarative or state-based. Migration-based deployment (versioned up/down scripts, changelogs of applied migrations) is not used.
- No ORM is used to define, generate, or manage the schema.
- The schema is not stored outside SQL. Nothing in YAML, JSON, TOML, or a code-first model is a source of truth for schema objects (see ADR 0002).

## Consequences

- Candidates that depend on migrations or ORM models must be adapted or excluded from scoring, and the results must say so.
- The comparison reflects the same input for every candidate.
- Tools that generate migrations internally may still be evaluated, as long as the schema source remains plain SQL and the deployment is not a hand-written migration sequence.
- These limits apply to this round only. A later round may change them through a new ADR that supersedes this one.
