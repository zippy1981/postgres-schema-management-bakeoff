#!/usr/bin/env bash
# Downloads the pinned pgmold release binary into ~/.local/bin and checks it against the
# release's checksum file.
set -euo pipefail
version="0.34.17"
base="https://github.com/fmguerreiro/pgmold/releases/download/v${version}"
asset="pgmold-x86_64-unknown-linux-gnu.tar.gz"
mkdir -p "$HOME/.local/bin"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -sSfL "${base}/${asset}" -o "$tmp/${asset}"
curl -sSfL "${base}/checksums-sha256.txt" -o "$tmp/checksums.txt"
(cd "$tmp" && grep " ${asset}\$" checksums.txt | sha256sum -c -)
tar -xzf "$tmp/${asset}" -C "$HOME/.local/bin" pgmold
chmod +x "$HOME/.local/bin/pgmold"
echo "pgmold: $("$HOME/.local/bin/pgmold" --version)"
