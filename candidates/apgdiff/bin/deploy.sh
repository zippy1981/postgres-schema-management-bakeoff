#!/usr/bin/env bash
# Deploys database/ with apgdiff. It compares an empty dump with the desired-state dump,
# and the resulting ALTER script is applied to the target.
set -euo pipefail
cd "$(dirname "$0")/../../.."

work="candidates/apgdiff/working_folder"
mkdir -p "$work"
scripts/ci/desired-state.sh database > "$work/desired.sql"
: > "$work/empty.sql"

java -jar "$HOME/.local/share/apgdiff/apgdiff.jar" "$work/empty.sql" "$work/desired.sql" > "$work/alter.sql"
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -q -f "$work/alter.sql"
