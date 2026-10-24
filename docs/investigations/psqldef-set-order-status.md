# Why psqldef drops sales.set_order_status

**Status:** root cause confirmed in sqldef's source. The procedure is dropped silently in psqldef's default mode, and psqldef exits 0.

**Reproduce:** `scripts/investigate/psqldef-procedure.sh <psqldef> <admin-url>`. It runs psqldef in each parser mode, on a procedure, on a function and procedure, and on a function alone.

**Tested with:** psqldef 3.11.26 (linux amd64 release), PostgreSQL 17.11 server.

## Result of the reproduction

| Case | Mode | Exit | Functions | Procedures | Warnings |
| --- | --- | --- | --- | --- | --- |
| procedure | auto (default) | 0 | 0 | 0 | 1 |
| procedure | generic | 1 | 0 | 0 | 0 |
| procedure | pgquery | 0 | 0 | 0 | 0 |
| function and procedure | auto | 0 | 1 | 0 | 1 |
| function and procedure | generic | 1 | 0 | 0 | 0 |
| function and procedure | pgquery | 0 | 0 | 0 | 0 |
| function only | auto | 0 | 1 | 0 | 0 |
| function only | generic | 0 | 1 | 0 | 0 |
| function only | pgquery | 0 | 0 | 0 | 0 |

## Theories

1. **The generic parser has no CREATE PROCEDURE.** Confirmed. In generic mode the statement fails with `syntax error at line 1, column 18 near 'procedure'`. Auto mode falls back when this happens.
2. **psqldef bundles a PostgreSQL grammar older than 11.** Ruled out. It bundles `pg_query_go` v6.2.2, which uses the PostgreSQL 17 grammar. Pgquery mode accepts the statement without a syntax error.
3. **The body or dollar quoting causes it.** Ruled out. `CREATE PROCEDURE p2() LANGUAGE sql AS 'SELECT 1'` is also dropped. The same holds for a one-line `$$ BEGIN END $$` body.
4. **Parenthesis spacing or the position of LANGUAGE causes it.** Ruled out. Variants with no space before the parameter list, with `CREATE OR REPLACE`, and with LANGUAGE after the body all fail the same way.
5. **The pgquery converter discards procedures.** Confirmed as the root cause of the silent loss. In `database/postgres/parser.go`, `parseStmt` returns `&parser.Ignore{}` for every `CreateFunctionStmt`, with the comment "In pgquery parser, CreateFunctionStmt is ignored." PostgreSQL's parse tree stores `CREATE PROCEDURE` as a `CreateFunctionStmt`. Pgquery-only mode therefore drops functions too, as the table shows.
6. **Auto mode hides the failure.** Confirmed. The fallback retries the statement with the generic parser. That fails, and the error is logged as a `WARN` line. The run then continues and exits 0. This is why the function survives in auto mode: its generic parse succeeds.

## Evidence in the source

- Documented support: `object-management.md` lists `procedure` as supported for psqldef.
- The parser modes are defined in `database/postgres/parser.go`, lines 30 to 60. The default is the mode that prefers the generic parser and falls back to pgquery.
- The conversion that drops the statement is in `database/postgres/parser.go`, lines 185 to 186, on `main` and at tag `v3.11.26`.

## Web search

I searched for upstream reports, and found none that match. The web results were general PostgreSQL material. One gives the date procedures were added: [PostgreSQL 11 introduced stored procedures](https://neon.com/postgresql/plpgsql/postgresql-create-procedure). I did not search the sqldef issue tracker through the web tool. Searches on `gh` for "procedure" in `sqldef/sqldef` returned no issues.

## Impact

- The object check in this repo catches the drop. Without it, the psqldef run would count as a pass.
- The same loss applies to functions in pgquery mode. The auto default keeps them only when the generic parser handles them.

## Options

1. **Report upstream.** The fix is in the converter, which should map `is_procedure` statements, or in the generic parser, plus making a per-statement fallback failure fatal. This is an outward-facing action, so it needs your approval before I open an issue.
2. **Work around in the schema.** Declare the procedure as `CREATE FUNCTION ... RETURNS void`. This changes the test schema, which `docs/plan.md` section 3 requires to be a procedure. I do not recommend it.
3. **Keep the result as a finding.** The bake-off reports psqldef as failing on the procedure, with this evidence. This is the current state.

I recommend option 3 for the bake-off, and option 1 as a separate step once you approve.
