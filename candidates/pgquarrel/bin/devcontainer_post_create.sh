#!/usr/bin/env bash
# Builds pgquarrel from source with CMake and installs it into ~/.local/bin.
# Needs cmake, make and the libpq headers (pg_config).
set -euo pipefail
for tool in cmake make git; do
  command -v "$tool" >/dev/null || { echo "pgquarrel: needs $tool on PATH" >&2; exit 1; }
done
if ! command -v pg_config >/dev/null; then
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq libpq-dev
fi
src="candidates/pgquarrel/working_folder/src"
rm -rf "$src"
mkdir -p "$(dirname "$src")"
git clone --depth 1 https://github.com/eulerto/pgquarrel "$src"
cmake -S "$src" -B "$src/build" -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build "$src/build" --parallel
cmake --install "$src/build"
echo "pgquarrel: installed from $(git -C "$src" rev-parse --short HEAD)"
