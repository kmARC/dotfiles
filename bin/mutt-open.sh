#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.cache/mutt"
echo "mutt-opening $*"

URI=$1
if [ -f "$URI" ]; then
  URI=$HOME/.cache/mutt/$(basename "$URI")
  cp -f "$1" "$URI"
fi

if [[ $OSTYPE == 'darwin'* ]]; then
  exec open "$URI" 2>/dev/null &
else
  exec xdg-open "$URI" 2>/dev/null &
fi

