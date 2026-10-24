#!/usr/bin/env bash
# Builds pgquarrel from source into ~/.local/bin. Needs the libpq headers (pg_config).
set -euo pipefail
mkdir -p "$HOME/.local/bin"
if ! command -v pg_config >/dev/null; then
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq libpq-dev
fi
src="candidates/pgquarrel/working_folder/src"
rm -rf "$src"
mkdir -p "$(dirname "$src")"
git clone --depth 1 https://github.com/eulerto/pgquarrel "$src"
make -C "$src"
cp "$src/pgquarrel" "$HOME/.local/bin/pgquarrel"
echo "pgquarrel: built from $(git -C "$src" rev-parse --short HEAD)"
