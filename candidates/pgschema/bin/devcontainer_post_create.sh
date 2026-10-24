#!/usr/bin/env bash
# Installs pgschema with the Go toolchain into ~/.local/bin.
set -euo pipefail
mkdir -p "$HOME/.local/bin"
GOBIN="$HOME/.local/bin" go install github.com/pgplex/pgschema@latest
test -x "$HOME/.local/bin/pgschema"
echo "pgschema: installed"
