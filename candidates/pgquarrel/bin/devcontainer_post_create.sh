#!/usr/bin/env bash
# Builds pgquarrel from source with CMake and installs it into ~/.local/bin.
# Needs cmake, make and the PostgreSQL server headers (pg_config, libpgport).
set -euo pipefail
for tool in cmake make git; do
  command -v "$tool" >/dev/null || { echo "pgquarrel: needs $tool on PATH" >&2; exit 1; }
done
# The server development package provides pg_config and libpgport.a, which the build needs.
sudo apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq postgresql-server-dev-all
src="candidates/pgquarrel/working_folder/src"
rm -rf "$src"
mkdir -p "$(dirname "$src")"
git clone --depth 1 https://github.com/eulerto/pgquarrel "$src"
cmake -S "$src" -B "$src/build" -DCMAKE_INSTALL_PREFIX="$HOME/.local" -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build "$src/build" --parallel
cmake --install "$src/build"
echo "pgquarrel: installed from $(git -C "$src" rev-parse --short HEAD)"
