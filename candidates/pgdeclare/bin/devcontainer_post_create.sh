#!/usr/bin/env bash
# Installs pgdeclare as a uv tool, into ~/.local/bin.
set -euo pipefail
uv tool install pgdeclare
pgdeclare --help >/dev/null
echo "pgdeclare: installed"
