#!/usr/bin/env bash
# Downloads apgdiff into ~/.local/share/apgdiff and links the jar. Needs a Java runtime.
set -euo pipefail
command -v java >/dev/null || { echo "apgdiff: needs a Java runtime on PATH" >&2; exit 1; }
share="$HOME/.local/share/apgdiff"
mkdir -p "$share"
curl -sSfL https://www.apgdiff.com/download/apgdiff-2.7.0.zip -o "$share/apgdiff.zip"
unzip -o -q "$share/apgdiff.zip" -d "$share"
jar="$(find "$share" -name 'apgdiff*.jar' ! -name apgdiff.jar | head -1)"
test -n "$jar"
ln -sf "$jar" "$share/apgdiff.jar"
echo "apgdiff: $(basename "$jar")"
