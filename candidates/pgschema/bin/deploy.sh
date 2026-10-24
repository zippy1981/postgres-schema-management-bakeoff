#!/usr/bin/env bash
# Deploys database/ with pgschema. pgschema manages one schema per run, so it runs once for
# each schema in the test tree. The desired state is one SQL file, which pgschema plans against
# the live schema and applies.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"
source scripts/ci/db-parts.sh "$DATABASE_URL"
export PGPASSWORD="$PG_PASSWORD"

work="candidates/pgschema/working_folder"
mkdir -p "$work"
scripts/ci/desired-state.sh database > "$work/schema.sql"

for schema in sales inventory audit; do
  echo "pgschema: applying schema $schema"
  pgschema apply --host "$PG_HOST" --port "$PG_PORT" --user "$PG_USER" --db "$PG_DB" \
    --schema "$schema" --file "$work/schema.sql" --auto-approve
done
