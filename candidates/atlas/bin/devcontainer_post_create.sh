#!/usr/bin/env bash
# Downloads the Atlas CLI into ~/.local/bin.
set -euo pipefail
mkdir -p "$HOME/.local/bin"
curl -sSfL https://release.ariga.io/atlas/atlas-linux-amd64-latest -o "$HOME/.local/bin/atlas"
chmod +x "$HOME/.local/bin/atlas"
echo "atlas: $("$HOME/.local/bin/atlas" version | head -1)"
