#!/usr/bin/env bash
set -euo pipefail

WID_TRAY=$(xwininfo -root -tree \
           | awk '/"xfce4-panel"/{ print $1 }' \
           | head -n1)

# Wait until polybar is appearing and resized
for try in {1..10}; do
    VALUES=($(xwininfo -root -tree \
              | grep -i polybar-kmarc \
              | sed 's/^.*\ \([0-9]\+\)x\([0-9]\+\)[+-]\([0-9]\+\)[+-]\([0-9]\+\).*$/\1 \2 \3 \4/'))
    if [ -z "${VALUES[0]}" ]; then
        echo "Waiting for polybar ($try)"
        sleep 0.5
    else
        break
    fi
done

BAR_W=${VALUES[0]}
BAR_X=${VALUES[2]}
BAR_Y=${VALUES[3]}

POS_X=$((BAR_W / 2 + BAR_X - 290))
POS_Y=$BAR_Y

echo "Moving tray to position $POS_X, $POS_Y"
xdotool windowmove "$WID_TRAY" "$POS_X" "$POS_Y"
