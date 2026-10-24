#!/usr/bin/env bash
# Deploys database/ with migra. A shadow database is loaded from the desired state, and
# migra diffs the empty target against it. The diff is then applied to the target.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"

work="candidates/migra/working_folder"
mkdir -p "$work"
shadow_url="${DATABASE_URL%/*}/${DATABASE_URL##*/}_shadow"

scripts/ci/create-db.sh "$DATABASE_URL"
scripts/ci/create-db.sh "$shadow_url"
scripts/ci/desired-state.sh database > "$work/desired.sql"

echo "migra: loading desired state into the shadow database"
psql "$shadow_url" -v ON_ERROR_STOP=1 -q -f "$work/desired.sql"

echo "migra: diffing the empty target against the shadow"
status=0
migra --unsafe "$DATABASE_URL" "$shadow_url" > "$work/migration.sql" || status=$?
# migra exits 2 when it found differences, which is expected here.
if (( status > 2 )); then
  echo "migra: failed with exit ${status}" >&2
  exit "$status"
fi

echo "migra: applying $(wc -l < "$work/migration.sql") line(s) to the target"
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -q -f "$work/migration.sql"
