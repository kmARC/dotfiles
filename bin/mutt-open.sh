#!/usr/bin/env sh
set -euo pipefail

echo $@
TMP=$(basename $1)
TMP=~/.cache/mutt.tmp."${TMP##*.}"
TMP="${TMP%%__}"
cp -f "$1" "$TMP"
xdg-open "$TMP" 2>/dev/null
