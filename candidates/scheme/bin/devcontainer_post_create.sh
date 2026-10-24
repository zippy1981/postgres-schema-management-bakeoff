#!/usr/bin/env bash
# Builds the pinned scheme release from source with the Go toolchain on PATH, into ~/.local/bin.
# scheme publishes a tag but no release binaries.
set -euo pipefail
mkdir -p "$HOME/.local/bin"
if ! command -v go >/dev/null; then
  echo "scheme: needs the Go toolchain on PATH" >&2
  exit 1
fi
GOBIN="$HOME/.local/bin" go install github.com/nvcnvn/scheme/cmd/scheme@v0.0.1
test -x "$HOME/.local/bin/scheme"
echo "scheme: installed v0.0.1 at $HOME/.local/bin/scheme"
