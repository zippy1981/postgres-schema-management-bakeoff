# Architecture Decision Records

An Architecture Decision Record (ADR) captures one significant decision: the context that forced it, what was decided, and what follows from it. ADRs are short, dated by their number, and kept in the repository next to the code they govern.

## When to write an ADR

Write an ADR when a decision:

- Constrains how the bake-off is run or how candidates are built (rules, layouts, tooling).
- Would be expensive to reverse or would surprise a reader who arrives later.
- Chooses between real alternatives that a reasonable person could have picked differently.

Do not write an ADR for routine implementation details, bug fixes, or choices that are obvious from the code.

## Status values

- **Proposed**: under discussion, not yet binding.
- **Accepted**: binding. Accepted ADRs are not edited (see below).
- **Superseded by NNNN**: replaced by a later ADR. The old file stays in place with its status updated to point at the new one.
- **Deprecated**: no longer applies, and nothing replaces it.

## Template

Every ADR uses this structure:

```markdown
# NNNN Short imperative title

Status: Accepted

## Context

What forces are at play. The problem, the constraints, and the facts that made a decision necessary.

## Decision

What we decided, stated in plain, direct sentences.

## Consequences

What becomes easier, what becomes harder, and what follow-up work or risks this creates.
```

## Numbering and file names

- ADRs live in `docs/adr/` and are named `NNNN-slug.md`, where `NNNN` is a zero-padded four-digit number and `slug` is a short lowercase hyphenated summary of the title.
- Numbers are assigned sequentially: the next ADR is the highest existing number plus one.
- Numbers are never reused, even if an ADR is later deprecated.
- The title in the file starts with the number, for example `# 0002 Schema is plain SQL in an SSDT-style layout`.

## Changing an ADR

- An **Accepted** ADR is not edited to change its decision. To change a decision, write a new ADR that supersedes it, and update the old ADR's status line to `Superseded by NNNN`.
- Small corrections (typos, broken links) are allowed in place.

## Index

| Number | Title | Status |
| --- | --- | --- |
| [0001](0001-record-architecture-decisions.md) | Record architecture decisions as ADRs | Accepted |
| [0002](0002-plain-sql-ssdt-layout.md) | Schema is plain SQL in an SSDT-style layout | Accepted |
| [0003](0003-no-migrations-orms-or-non-sql-storage.md) | No migration-based deployment, ORMs, or non-SQL schema storage for this round | Accepted |
| [0004](0004-one-shared-schema-copy.md) | One shared schema copy; each candidate migrates its own database | Accepted |
| [0005](0005-candidate-folder-structure.md) | Candidate folder structure | Accepted |
| [0006](0006-devcontainer-conventions.md) | Devcontainer conventions | Accepted |
| [0007](0007-test-schema-requirements.md) | Test schema requirements | Accepted |
