#!/usr/bin/env bash
# Exports PG_HOST, PG_PORT, PG_USER, PG_PASSWORD and PG_DB from a postgresql:// URL,
# for tools that take connection flags instead of a URL.
# Usage: source scripts/ci/db-parts.sh "$DATABASE_URL"
eval "$(python3 - "$1" <<'PY'
import shlex
import sys
import urllib.parse

url = urllib.parse.urlsplit(sys.argv[1])
parts = {
    "PG_HOST": url.hostname or "localhost",
    "PG_PORT": str(url.port or 5432),
    "PG_USER": url.username or "postgres",
    "PG_PASSWORD": url.password or "",
    "PG_DB": url.path.lstrip("/"),
}
for key, value in parts.items():
    print(f"export {key}={shlex.quote(value)}")
PY
)"
