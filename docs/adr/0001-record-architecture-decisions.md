# 0001 Record architecture decisions as ADRs

Status: Accepted

## Context

The bake-off compares Postgres schema management tools across several candidates. Many choices shape how every candidate is built and judged: the schema format, the folder layout, the rules about what may be used, and the test requirements. Without a record, these choices live only in chat history or in people's heads, and later contributors cannot tell which constraints are deliberate and which are accidents.

## Decision

Significant decisions are recorded as Architecture Decision Records in `docs/adr/`, following the format and numbering rules in `docs/adr/README.md`. An ADR is written before or alongside the change it governs. Accepted ADRs are not edited to change their decision; a new ADR supersedes them instead.

## Consequences

- Constraints such as "plain SQL only" and "no migrations" have a durable, citable source.
- Writing an ADR adds a small amount of effort to decisions that matter. Routine implementation choices do not need one.
- Superseding instead of editing keeps the history of how the rules changed visible.
