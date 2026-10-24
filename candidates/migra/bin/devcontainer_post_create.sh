#!/usr/bin/env bash
# Installs migra and the psycopg2 driver it needs, with uv, into ~/.local/bin.
set -euo pipefail
uv tool install --with psycopg2-binary migra
echo "migra: $(uv tool list | grep '^migra ' || echo 'not found')"
