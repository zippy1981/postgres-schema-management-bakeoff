#!/usr/bin/env bash
# Deploys database/ with pg-schema-diff. The directory is the desired schema, and the tool
# plans and applies the changes to the target database.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"

pg-schema-diff apply --from-dsn "$DATABASE_URL" --to-dir database
