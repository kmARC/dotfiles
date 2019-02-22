#!/usr/bin/env sh
set -euo pipefail

TMP=~/.cache/mutt.tmp."${1##*.}"
cp -f "$1" "$TMP"
xdg-open "$TMP" 2>/dev/null
