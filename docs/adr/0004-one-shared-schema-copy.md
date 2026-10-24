# 0004 One shared schema copy; each candidate migrates its own database

Status: Accepted

## Context

If each candidate kept its own copy of the schema SQL, the copies could drift apart and the candidates would no longer be given the same target. Still, each candidate has to deploy into a database of its own, because the tools track their own state (such as the last deployed version or the diff baseline) and must not interfere with each other.

## Decision

- There is exactly one copy of the schema, in `database/` at the repository root.
- Candidates do not duplicate or modify it. They read from `database/` and apply it to their own database.
- Each candidate migrates its own database instance or database name, so its state is independent of every other candidate.

## Consequences

- Every candidate is measured against identical schema input.
- A schema change is made once and reaches all candidates together.
- Candidates that need extra files, such as generated scripts or state files, keep them in their own `candidates/<NAME>/` folder, not in `database/`.
- Running candidates side by side requires separate database names or instances; the candidate tooling must enforce this.
