#!/usr/bin/env bash
# Deploys database/ with pgschema. pgschema manages one schema per run and needs that schema
# to exist, so the schema files are applied with psql first. Then, for each schema, that
# schema's files in sorted path order are the desired state, and pgschema plans and applies
# the difference. Its embedded Postgres validates the desired state.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"
source scripts/ci/db-parts.sh "$DATABASE_URL"
export PGPASSWORD="$PG_PASSWORD"

work="candidates/pgschema/working_folder"
mkdir -p "$work"

for file in database/Schemas/*.sql; do
  psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -q -f "$file"
done

for file in database/Schemas/*.sql; do
  schema="$(basename "$file" .sql)"
  find database -path database/Schemas -prune -o -name "${schema}.*.sql" -print0 \
    | sort -z | xargs -0 --no-run-if-empty cat > "$work/${schema}.sql"
  echo "pgschema: applying schema ${schema}"
  pgschema apply --auto-approve --no-color \
    --host "$PG_HOST" --port "$PG_PORT" --user "$PG_USER" --db "$PG_DB" \
    --schema "$schema" --file "$work/${schema}.sql"
done
