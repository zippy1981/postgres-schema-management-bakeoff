#!/usr/bin/env bash
# Deploys database/ with Atlas. The SQL source is the desired state. Atlas uses a dev
# database to normalise it, then applies the changes to the target.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"

work="candidates/atlas/working_folder"
mkdir -p "$work"
dev_url="${DATABASE_URL%/*}/${DATABASE_URL##*/}_dev"

scripts/ci/create-db.sh "$dev_url"
scripts/ci/desired-state.sh database > "$work/desired.sql"

atlas schema apply \
  --url "$DATABASE_URL" \
  --dev-url "$dev_url" \
  --to "file://$work/desired.sql" \
  --auto-approve
