#!/usr/bin/env bash
# Installs scheme with the Go toolchain into ~/.local/bin.
set -euo pipefail
mkdir -p "$HOME/.local/bin"
GOBIN="$HOME/.local/bin" go install github.com/nvcnvn/scheme/cmd/scheme@latest
test -x "$HOME/.local/bin/scheme"
echo "scheme: installed"
