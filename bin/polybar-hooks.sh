#!/usr/bin/env bash
set -euo pipefail

HOOKS=(bluetooth dnd)

while true; do
  for hook in "${HOOKS[@]}"; do
    polybar-msg -p "$(pgrep polybar)" hook "$hook" 1 2>/dev/null
  done
  sleep 5
done


