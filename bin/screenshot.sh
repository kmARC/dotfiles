#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

IMG="$HOME/Pictures/Screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"

grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)" "$IMG"
ksnip -e "$IMG" "$IMG"
