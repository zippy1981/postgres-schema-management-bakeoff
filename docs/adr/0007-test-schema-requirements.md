# 0007 Test schema requirements

Status: Accepted

## Context

The bake-off's test schema has to exercise the features that separate schema management tools. A trivial schema of independent tables would let every candidate pass, because alphabetical order happens to work and no object depends on another in a tricky way. Dependency ordering, circular references, and programmable objects are where tools differ.

## Decision

The test schema in `database/` must include all of the following:

1. **Multiple schemas.** Objects are spread across more than one Postgres schema, so tools must handle qualified names.
2. **Non-alphabetical apply order.** At least one table sorts alphabetically before another table, and it has a foreign key to a table that sorts alphabetically after it. A tool that applies objects in alphabetical order will fail, so the tool must derive dependency order.
3. **A circular foreign key.** At least two tables reference each other through foreign keys, so no single creation order satisfies every dependency without deferring or altering a constraint.
4. **Self-referencing foreign keys.** At least one table has a foreign key to itself, for example a parent column pointing at the same table's primary key.
5. **Views.** At least one view is defined over the tables, and at least one view depends on another view or on a table that is created later in the apply order.
6. **Stored procedures.** At least one stored procedure is defined. It must reference a table or view so that its position in the dependency order matters.

## Consequences

- Any candidate that cannot handle these cases is visibly weaker, which is the purpose of the test.
- The schema is harder to write and maintain than a simple one. Changes to it must keep all six requirements true.
- Checking these requirements is part of reviewing any change to the test schema. A reviewer should be able to confirm each item by inspecting `database/`.
