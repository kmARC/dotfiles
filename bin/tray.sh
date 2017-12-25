#!/usr/bin/env bash

PID_HIDEIT=$(pgrep -f bash.*hideIt)
PID_TRAY=$(pgrep stalonetray)
WID_TRAY=$(xwininfo -root -tree \
           | awk '/"stalonetray"/{ print $1 }')

for p in ${PID_HIDEIT[@]}; do
    kill "$p"
done

for try in {1..10}; do
    VALUES=($(xwininfo -root -tree \
              | grep -i polybar \
              | sed 's/^.*\ \([0-9]\+\)x\([0-9]\+\)[+-]\([0-9]\+\)[+-]\([0-9]\+\).*$/\1 \2 \3 \4/'))
    if [ -z "${VALUES[0]}" ]; then
        echo "Waiting for polybar ($try)"
        sleep 0.5
    else
        break
    fi
done

BAR_WIDTH=$(cat /tmp/polybar-width.txt)
BAR_HEIGHT=${VALUES[1]}
BAR_X=${VALUES[2]}
BAR_Y=${VALUES[3]}

POS_X=$((BAR_WIDTH / 2 + BAR_X + 190))
POS_Y=${BAR_Y}
GEOMETRY="1x1+${POS_X}+${POS_Y}"
REGION="${BAR_X}x${BAR_Y}+${BAR_WIDTH}+${BAR_HEIGHT}"

(
    if [ -z "$PID_TRAY" ]; then
        stalonetray --geometry "$GEOMETRY" &
    else
        xdotool windowmove "${WID_TRAY}" "${POS_X}" "${POS_Y}"
    fi
    ~/.local/src/hideIt.sh/hideIt.sh --name '^stalonetray$' -d top \
                                     --peek 0 --region "$REGION" &
) &

