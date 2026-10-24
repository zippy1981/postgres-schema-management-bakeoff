#!/usr/bin/env bash
# Deploys database/ with scheme. The SQL file is the desired state. scheme loads it into a
# clean database to normalise it, then computes and applies the diff.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"

work="candidates/scheme/working_folder"
mkdir -p "$work"
scripts/ci/desired-state.sh database > "$work/schema.sql"

scheme apply --file "$work/schema.sql" --url "$DATABASE_URL" --dev-url "${DATABASE_URL%/*}/${DATABASE_URL##*/}_dev"
