#!/usr/bin/env bash
# Deploys database/ with pgdeclare. pgdeclare reads <sql-dir>/schemas/ recursively. It builds
# the files in a scratch plan database on the same server, retrying statements that fail on a
# missing dependency, then diffs and applies the difference.
# pgdeclare creates each schema passed with --schema itself, and a CREATE SCHEMA in the files
# then fails as a duplicate. So every schema under database/Schemas/ is passed with --schema,
# and working_folder/sql/schemas links every other folder of database/ (links, not copies,
# per ADR 0004).
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"

work="candidates/pgdeclare/working_folder"
rm -rf "$work/sql"
mkdir -p "$work/sql/schemas"
for dir in database/*/; do
  name="$(basename "$dir")"
  [[ "$name" == "Schemas" ]] && continue
  ln -s "../../../../../database/${name}" "$work/sql/schemas/${name}"
done

schema_args=()
schemas=()
for file in database/Schemas/*.sql; do
  schema="$(basename "$file" .sql)"
  schema_args+=(--schema "$schema")
  schemas+=("$schema")
done

# pgdeclare writes the DDL it applies with unqualified names, so the managed schemas must be on
# the search_path of both the plan and target connections. Without this, every table, foreign
# key and view fails with "relation ... does not exist".
search_path="$(IFS=,; echo "${schemas[*]}"),public"
export PGOPTIONS="-c search_path=${search_path}"

pgdeclare apply --verbose \
  --database-url "$DATABASE_URL" \
  --sql-dir "$work/sql" \
  "${schema_args[@]}"
