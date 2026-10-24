#!/usr/bin/env bash
# Deploys database/ with pgdelta schema apply. The directory of SQL files is loaded into a
# shadow database first, which is where the tool resolves order, then the target is converged.
set -euo pipefail
cd "$(dirname "$0")/../../.."
scripts/ci/create-db.sh "${DATABASE_URL%/*}/${DATABASE_URL##*/}_shadow"

pgdelta schema apply \
  --dir database \
  --shadow "${DATABASE_URL%/*}/${DATABASE_URL##*/}_shadow" \
  --target "$DATABASE_URL"
