#!/usr/bin/env bash
set -euo pipefail

echo "$@"

if [ -f "$1" ]; then
  TMP=$(basename "$1")
  TMP=~/.cache/mutt.tmp."${TMP##*.}"
  TMP="${TMP%%__}"

  cp -f "$1" "$TMP"
  xdg-open "$TMP" 2>/dev/null
else
  xdg-open "$1" 2>/dev/null
fi

