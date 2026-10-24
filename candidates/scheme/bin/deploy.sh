#!/usr/bin/env bash
# Deploys database/ with scheme. The SQL is the desired state. scheme loads it into a clean
# dev database to normalise it, then diffs the target against it and applies the changes.
# scheme starts a Docker container for the dev database by default; --dev-url points it at a
# scratch database on the same server instead.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"

work="candidates/scheme/working_folder"
mkdir -p "$work"
dev_url="${DATABASE_URL%/*}/${DATABASE_URL##*/}_dev"

scripts/ci/create-db.sh "$dev_url"
scripts/ci/desired-state.sh database > "$work/desired.sql"

scheme apply \
  --url "$DATABASE_URL" \
  --dev-url "$dev_url" \
  --schema "$work/desired.sql" \
  --dir "$work/migrations" \
  --auto-approve
