#!/usr/bin/env bash
# Installs pgmold with cargo into ~/.local/bin.
set -euo pipefail
cargo install pgmold --locked --root "$HOME/.local"
test -x "$HOME/.local/bin/pgmold"
echo "pgmold: installed"
