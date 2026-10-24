#!/usr/bin/env bash
# Builds the Markdown bake-off report from the per-candidate artifacts.
# Usage: scripts/ci/report.sh <artifacts-dir>
set -uo pipefail

root="$1"

echo "# Bake-off report"
echo
echo "Generated $(date -u +%FT%TZ) from the Candidates workflow."
echo
echo "| Candidate | Create | Install | Deploy | Objects | Dump lines |"
echo "|---|---|---|---|---|---|"

for dir in "$root"/candidate-*/; do
  [[ -d "$dir" ]] || continue
  name="$(basename "$dir")"
  name="${name#candidate-}"
  status_of() { grep "^$1=" "${dir}status.txt" 2>/dev/null | cut -d= -f2; }
  objects="$(wc -l < "${dir}objects.tsv" 2>/dev/null || echo 0)"
  dump="$(wc -l < "${dir}sql_dump.sql" 2>/dev/null || echo 0)"
  echo "| ${name} | $(status_of create) | $(status_of install) | $(status_of deploy) | ${objects} | ${dump} |"
done

echo
echo "## Objects per candidate"
for dir in "$root"/candidate-*/; do
  [[ -d "$dir" ]] || continue
  name="$(basename "$dir")"
  name="${name#candidate-}"
  echo
  echo "<details><summary>${name}</summary>"
  echo
  echo "| Schema | Name | Kind |"
  echo "|---|---|---|"
  awk -F'\t' '{ printf "| %s | %s | %s |\n", $1, $2, $3 }' "${dir}objects.tsv" 2>/dev/null
  echo
  echo "</details>"
done
