#!/usr/bin/env bash
set -euo pipefail

WIDS_TRAY=$(xwininfo -root -children \
           | awk '/\s+0x[0-9]+ "xfce4-panel"/{ print $1 }')

# Wait until polybar is appearing and resized
for try in {1..10}; do
    VALUES=($(xwininfo -root -children \
              | awk '/polybar-kmarc/ \
                    { print gensub(/([0-9]+)x([0-9]+)[+-]([0-9]+)[+-]([0-9]+)/,\
                                   "\\1 \\2 \\3 \\4", "g", $5) }'))
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

POS_X=$((BAR_X + BAR_W - 800))
POS_Y=$BAR_Y

echo "Moving tray to position $POS_X, $POS_Y"
for id in $WIDS_TRAY; do
  xdotool windowmove "$id" "$POS_X" "$POS_Y"
done
