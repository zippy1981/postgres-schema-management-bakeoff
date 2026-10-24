#!/usr/bin/env bash
# Deploys database/ with psqldef. The SQL is the desired state, and psqldef computes and
# applies the changes to the target database.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"
source scripts/ci/db-parts.sh "$DATABASE_URL"

work="candidates/psqldef/working_folder"
mkdir -p "$work"
scripts/ci/desired-state.sh database > "$work/desired.sql"

psqldef -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -W "$PG_PASSWORD" "$PG_DB" < "$work/desired.sql"
