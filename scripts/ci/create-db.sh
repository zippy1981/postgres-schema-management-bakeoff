#!/usr/bin/env bash
# Drops and recreates the database named in a postgresql:// URL, connecting through
# the server's postgres database.
# Usage: scripts/ci/create-db.sh <database-url>
set -euo pipefail

url="$1"
admin_url="${url%/*}/postgres"
name="${url##*/}"
psql "$admin_url" -v ON_ERROR_STOP=1 -q \
  -c "DROP DATABASE IF EXISTS \"${name}\"" \
  -c "CREATE DATABASE \"${name}\""
