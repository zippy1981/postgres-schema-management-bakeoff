#!/usr/bin/env bash
# Runs each candidate's devcontainer hook after the container is created.
# Hooks live at candidates/<CANDIDATE_NAME>/bin/devcontainer_post_create.sh.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
cd "${repo_root}"

# nullglob makes an unmatched pattern expand to nothing instead of the literal pattern.
shopt -s nullglob
hooks=(candidates/*/bin/devcontainer_post_create.sh)
shopt -u nullglob

if [[ ${#hooks[@]} -eq 0 ]]; then
  echo "post_create: no candidate hooks found (candidates/*/bin/devcontainer_post_create.sh)"
  exit 0
fi

for hook in "${hooks[@]}"; do
  candidate="$(basename "$(dirname "$(dirname "${hook}")")")"
  echo "post_create: running candidate ${candidate}"
  rc=0
  bash "${hook}" || rc=$?
  if (( rc != 0 )); then
    echo "post_create: candidate ${candidate} failed with exit code ${rc}" >&2
    exit "${rc}"
  fi
done

echo "post_create: ran ${#hooks[@]} candidate hook(s) successfully"
