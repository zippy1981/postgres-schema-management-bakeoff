#!/usr/bin/env bash
# Reproduces why psqldef drops sales.set_order_status. Runs psqldef in each parser mode
# against a fresh database for each case, and reports whether the procedure or the
# function was created, and whether psqldef exited 0.
#
# Usage: scripts/investigate/psqldef-procedure.sh <psqldef-binary> <admin-database-url>
# Example: scripts/investigate/psqldef-procedure.sh ./psqldef postgresql://postgres:postgres@localhost:5432/postgres
set -uo pipefail

psqldef="$1"
admin_url="$2"
base="${admin_url%/*}"
source "$(dirname "$0")/../ci/db-parts.sh" "$admin_url"
work="$(mktemp -d)"

cat > "${work}/procedure.sql" <<'SQL'
CREATE SCHEMA sales;
CREATE TABLE sales.order_header (order_id integer PRIMARY KEY, status text NOT NULL DEFAULT 'new');
CREATE PROCEDURE sales.set_order_status (p_order_id integer, p_status text)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE sales.order_header SET status = p_status WHERE order_id = p_order_id;
END;
$$;
SQL

cat > "${work}/function_and_procedure.sql" <<'SQL'
CREATE SCHEMA sales;
CREATE TABLE sales.t (id integer PRIMARY KEY);
CREATE FUNCTION sales.add_one(x integer) RETURNS integer LANGUAGE sql AS 'SELECT x + 1';
CREATE PROCEDURE sales.p() LANGUAGE plpgsql AS $$ BEGIN END $$;
SQL

cat > "${work}/function_only.sql" <<'SQL'
CREATE SCHEMA sales;
CREATE FUNCTION sales.add_one(x integer) RETURNS integer LANGUAGE sql AS 'SELECT x + 1';
SQL

count() { psql "${base}/$1" -Atc "SELECT count(*) FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace WHERE n.nspname = 'sales' AND p.prokind = '$2'" 2>/dev/null; }

printf '%-22s %-8s %-4s %-12s %-12s %s\n' case mode exit functions procedures warnings
for case in procedure function_and_procedure function_only; do
  for mode in auto generic pgquery; do
    db="psqldef_${case}_${mode}"
    psql "$admin_url" -q -c "DROP DATABASE IF EXISTS ${db}" -c "CREATE DATABASE ${db}" >/dev/null 2>&1
    PGPASSWORD="$PG_PASSWORD" PSQLDEF_PARSER="$mode" "$psqldef" -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" --apply "$db" \
      < "${work}/${case}.sql" > "${work}/${case}_${mode}.log" 2>&1
    rc=$?
    printf '%-22s %-8s %-4s %-12s %-12s %s\n' "$case" "$mode" "$rc" \
      "$(count "$db" f)" "$(count "$db" p)" "$(grep -c WARN "${work}/${case}_${mode}.log")"
  done
done
echo "logs: ${work}"
