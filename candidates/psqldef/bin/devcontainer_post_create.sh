#!/usr/bin/env bash
# Downloads the psqldef (sqldef for PostgreSQL) binary into ~/.local/bin.
set -euo pipefail
mkdir -p "$HOME/.local/bin"
curl -sSfL https://github.com/sqldef/sqldef/releases/latest/download/psqldef_linux_amd64.tar.gz \
  | tar -xz -C "$HOME/.local/bin" psqldef
chmod +x "$HOME/.local/bin/psqldef"
echo "psqldef: $("$HOME/.local/bin/psqldef" --version 2>&1 | head -1 || true)"
