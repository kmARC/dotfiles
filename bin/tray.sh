#!/usr/bin/env bash

PID_HIDEIT=$(pgrep -f bash.*hideIt)
PID_TRAY=$(pgrep stalonetray)
WID_TRAY=$(xwininfo -root -tree \
           | awk '/"stalonetray"/{ print $1 }')

for p in "${PID_HIDEIT[@]}"; do
    echo kill "$p"
    kill $p
done

VALUES=($(xwininfo -root -tree \
          | grep -i polybar \
          | sed 's/^.*\ \([0-9]\+\)x\([0-9]\+\)[+-]\([0-9]\+\)[+-]\([0-9]\+\).*$/\1 \2 \3 \4/'))


POS_X=$((VALUES[0] / 2 + VALUES[2] + 190))
GEOMETRY="1x1+${POS_X}+{VALUES[3]}"
REGION="0x0+1920+24"

(
    if [ -z "$PID_TRAY" ]; then
        stalonetray --geometry "$GEOMETRY" &
    else
        echo xdotool windowmove ${WID_TRAY} ${POS_X} ${VALUES[3]}
        xdotool windowmove ${WID_TRAY} ${POS_X} ${VALUES[3]}
    fi
    sleep 5
    ~/.local/src/hideIt.sh/hideIt.sh --name '^stalonetray$' -d top \
                                     --peek 0 --region "$REGION" &
) &

