#!/usr/bin/env bash
# Compares one candidate's object list with the reference in expected-objects.tsv, which is
# the ordered-psql run. Writes objects.diff and exits non-zero when the lists differ, so a
# deploy that exits 0 can still fail here. psqldef's silent parser fallback is the first case.
#
# Usage: scripts/ci/verify-objects.sh <candidate-dir>
set -uo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
results="$1/test_results"
mkdir -p "$results"

if diff <(sort "${root}/scripts/ci/expected-objects.tsv") <(sort "${results}/objects.tsv") > "${results}/objects.diff"; then
  echo "verify: objects match the reference"
else
  echo "verify: objects differ from the reference (see objects.diff)" >&2
  exit 1
fi
