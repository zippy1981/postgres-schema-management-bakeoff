#!/usr/bin/env bash
# Deploys database/ with pgmold. pgmold parses the SQL files itself, so the tree is passed
# unchanged. It compares only the schemas named in --target-schemas, which defaults to public,
# so every schema under database/Schemas/ is named. --verify-after-apply fails the run if the
# database still differs from the files afterwards.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"

schemas="$(find database/Schemas -name '*.sql' -printf '%f\n' | sed 's/\.sql$//' | sort | paste -sd,)"
echo "pgmold: target schemas ${schemas}"

pgmold apply \
  --schema sql:database/ \
  --database "$DATABASE_URL" \
  --target-schemas "$schemas" \
  --verify-after-apply
