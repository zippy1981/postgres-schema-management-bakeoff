#!/usr/bin/env bash
# Control: applies database/ in sorted path order with psql. Expected to fail on the
# alphabetical traps, which shows what a naive loader does.
set -euo pipefail
cd "$(dirname "$0")/../../.."
scripts/ci/desired-state.sh database | psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -q
