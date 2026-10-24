#!/usr/bin/env bash
# Installs the pinned pgdeclare release with uv into ~/.local/bin.
set -euo pipefail
uv tool install pgdeclare==0.1.1
echo "pgdeclare: $(uv tool list | grep '^pgdeclare ' || echo 'not found')"
