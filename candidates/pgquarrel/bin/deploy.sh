#!/usr/bin/env bash
# Deploys database/ with pgquarrel. pgquarrel compares two databases, so the desired state
# is loaded into a scratch database first. The ALTER script that turns the target into the
# desired state is then applied to the target.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"

work="candidates/pgquarrel/working_folder"
mkdir -p "$work"
desired_url="${DATABASE_URL%/*}/${DATABASE_URL##*/}_desired"

scripts/ci/create-db.sh "$desired_url"
scripts/ci/desired-state.sh database > "$work/desired.sql"
psql "$desired_url" -v ON_ERROR_STOP=1 -q -f "$work/desired.sql"

pgquarrel --source-dbname "$DATABASE_URL" --target-dbname "$desired_url" > "$work/alter.sql"
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -q -f "$work/alter.sql"
