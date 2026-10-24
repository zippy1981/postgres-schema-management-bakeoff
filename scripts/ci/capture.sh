#!/usr/bin/env bash
# Captures the schema dump and the list of Postgres objects for one candidate database.
# CI runs this with `if: always()`, so it must work even when the deploy failed or the
# database does not exist. A missing dump is recorded as a placeholder, not skipped.
#
# Usage: scripts/ci/capture.sh <candidate-dir> <database-url>
set -uo pipefail

candidate_dir="$1"
database_url="$2"
results="${candidate_dir}/test_results"
mkdir -p "$results"

echo "== capture $(date -u +%FT%TZ)" >> "${results}/test_logs.log"
pg_dump --version >> "${results}/test_logs.log" 2>&1

# Deterministic schema-only dump (docs/plan.md section 2).
if pg_dump --schema-only --no-owner --no-privileges --no-comments --no-tablespaces \
  --dbname="$database_url" --file="${results}/sql_dump.sql" 2>"${results}/pg_dump.err"; then
  echo "pg_dump: ok" >> "${results}/test_logs.log"
else
  printf -- '-- pg_dump failed; see pg_dump.err\n' > "${results}/sql_dump.sql"
  echo "pg_dump: failed (exit recorded in pg_dump.err)" >> "${results}/test_logs.log"
fi

# Every object in user schemas, one per line, tab separated.
psql "$database_url" -X -A -t -F $'\t' -f "$(dirname "$0")/objects.sql" \
  > "${results}/objects.tsv" 2>"${results}/objects.err"
echo "objects: $(wc -l < "${results}/objects.tsv") row(s)" >> "${results}/test_logs.log"
