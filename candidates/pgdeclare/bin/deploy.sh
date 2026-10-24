#!/usr/bin/env bash
# Deploys database/ with pgdeclare. pgdeclare reads the connection from libpq environment
# variables, so the URL is split into PG* variables first.
set -euo pipefail
cd "$(dirname "$0")/../../.."
export PATH="$HOME/.local/bin:$PATH"
source scripts/ci/db-parts.sh "$DATABASE_URL"
export PGHOST="$PG_HOST" PGPORT="$PG_PORT" PGUSER="$PG_USER" PGPASSWORD="$PG_PASSWORD" PGDATABASE="$PG_DB"

pgdeclare apply --dry-run
pgdeclare apply
