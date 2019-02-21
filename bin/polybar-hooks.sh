#!/usr/bin/env bash
HOOKS=(bluetooth dnd)

while true; do
  for hook in "${HOOKS[@]}"; do
    polybar-msg -p "$(pgrep polybar)" hook "$hook" 1
  done
  sleep 5
done


