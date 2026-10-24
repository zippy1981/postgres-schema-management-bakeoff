#!/usr/bin/env bash
# Deploys database/ with pgquarrel. It compares an empty dump with the desired-state dump,
# and the resulting ALTER script is applied to the target.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"

work="candidates/pgquarrel/working_folder"
mkdir -p "$work"
scripts/ci/desired-state.sh database > "$work/desired.sql"
: > "$work/empty.sql"

pgquarrel --source-dump "$work/empty.sql" --target-dump "$work/desired.sql" > "$work/alter.sql"
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -q -f "$work/alter.sql"
