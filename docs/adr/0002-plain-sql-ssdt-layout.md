# 0002 Schema is plain SQL in an SSDT-style layout

Status: Accepted

## Context

Each candidate tool must deploy the same schema, so the schema needs one neutral, tool-independent representation. Fair comparison requires that no candidate gets a richer source format than another. The layout also needs to make diffs readable and let a reviewer find any object quickly.

## Decision

- The schema is written as plain SQL and kept in `database/`.
- The layout follows SQL Server Data Tools (SSDT) conventions: one database object per file, with the file named after the object. For example, `database/Tables/sales.customer.sql` defines the table `sales.customer`.
- Objects are grouped in folders per object type (for example `Tables/`, `Views/`, `Procedures/`, `Foreign Keys/` or equivalent), so the folder name says what kind of object a file holds.
- Each file contains the statements that define that single object and nothing else.
- Candidates read this single schema tree; they do not keep their own copies of the SQL definitions (see ADR 0004).

## Consequences

- Candidates that expect a different source format must convert from this layout rather than change it.
- One object per file makes diffs and reviews map directly onto database objects.
- Because files are named after objects, the apply order is not implied by file names; tools must derive dependency order themselves (see ADR 0007).
- Object folders must be kept consistent as new object types are added, which is a small ongoing cost.
