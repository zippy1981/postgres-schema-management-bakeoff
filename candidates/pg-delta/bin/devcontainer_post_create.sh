#!/usr/bin/env bash
# Installs the pgdelta CLI (@supabase/pg-delta) globally with npm.
set -euo pipefail
npm install -g @supabase/pg-delta
pgdelta --help >/dev/null
echo "pg-delta: installed"
