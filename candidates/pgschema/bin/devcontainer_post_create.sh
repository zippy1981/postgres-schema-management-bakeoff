#!/usr/bin/env bash
# Downloads the pinned pgschema release binary into ~/.local/bin and checks it against the
# release's checksum file.
set -euo pipefail
version="1.13.3"
base="https://github.com/pgplex/pgschema/releases/download/v${version}"
asset="pgschema-${version}-linux-amd64"
mkdir -p "$HOME/.local/bin"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -sSfL "${base}/${asset}" -o "$tmp/${asset}"
curl -sSfL "${base}/pgschema-${version}-checksums.txt" -o "$tmp/checksums.txt"
(cd "$tmp" && grep " ${asset}\$" checksums.txt | sha256sum -c -)
install -m 0755 "$tmp/${asset}" "$HOME/.local/bin/pgschema"
echo "pgschema: $("$HOME/.local/bin/pgschema" --version)"
