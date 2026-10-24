#!/usr/bin/env bash
# Deliberately fails after creating the schemas. It tests that CI still publishes the
# dump and the object list, and that the matrix reports the failure.
set -euo pipefail
for file in database/Schemas/*.sql; do
  echo "dummy-fail: applying $file"
  psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -q -f "$file"
done
echo "dummy-fail: intentional failure after the schemas were created" >&2
exit 1
