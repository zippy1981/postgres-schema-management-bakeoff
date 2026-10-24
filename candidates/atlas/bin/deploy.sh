#!/usr/bin/env bash
# Deploys database/ with Atlas. The SQL source is the desired state. Atlas uses a dev
# database to normalise it, then applies the changes to the target.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"

work="candidates/atlas/working_folder"
mkdir -p "$work"
# Atlas refuses a server without SSL unless sslmode is set. CI's Postgres has no SSL.
target_url="${DATABASE_URL}?sslmode=disable"
dev_url="${DATABASE_URL%/*}/${DATABASE_URL##*/}_dev?sslmode=disable"

scripts/ci/create-db.sh "$dev_url"
scripts/ci/desired-state.sh database > "$work/desired.sql"

atlas schema apply \
  --url "$target_url" \
  --dev-url "$dev_url" \
  --to "file://$work/desired.sql" \
  --auto-approve
