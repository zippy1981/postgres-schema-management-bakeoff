#!/usr/bin/env bash
# Deploys database/ with pgmold. The SQL file is the desired state, and pgmold plans the
# change against the live database, then applies it.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"

work="candidates/pgmold/working_folder"
mkdir -p "$work"
scripts/ci/desired-state.sh database > "$work/schema.sql"

pgmold apply -s "sql:$work/schema.sql" -d "$DATABASE_URL"
