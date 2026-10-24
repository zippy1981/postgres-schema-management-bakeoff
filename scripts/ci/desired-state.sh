#!/usr/bin/env bash
# Prints every SQL file under database/ concatenated in sorted path order.
# This is the naive order: no dependency analysis. Candidates that need an ordered
# desired state get this output, and must handle the alphabetical traps themselves.
#
# Usage: scripts/ci/desired-state.sh [database-dir]
set -euo pipefail

root="${1:-database}"
find "$root" -name '*.sql' -print0 | sort -z | while IFS= read -r -d '' file; do
  printf -- '-- %s\n' "$file"
  cat "$file"
  printf '\n'
done
