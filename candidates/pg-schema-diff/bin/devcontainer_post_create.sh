#!/usr/bin/env bash
# Builds pg-schema-diff from source with the Go toolchain on PATH, into ~/.local/bin.
set -euo pipefail
mkdir -p "$HOME/.local/bin"
if ! command -v go >/dev/null; then
  echo "pg-schema-diff: needs the Go toolchain on PATH" >&2
  exit 1
fi
GOBIN="$HOME/.local/bin" go install github.com/stripe/pg-schema-diff/cmd/pg-schema-diff@latest
test -x "$HOME/.local/bin/pg-schema-diff"
echo "pg-schema-diff: installed $("$HOME/.local/bin/pg-schema-diff" --version 2>&1 | head -1 || true)"
