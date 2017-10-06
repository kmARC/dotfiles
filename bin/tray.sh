#!/usr/bin/env bash

PID_HIDEIT=$(pgrep -f bash.*hideIt)
PID_TRAY=$(pgrep stalonetray)

kill "$PID_HIDEIT"
kill "$PID_TRAY"

VALUES=($(xwininfo -root -tree \
          | grep -i polybar \
          | sed 's/^.*\ \([0-9]\+\)x\([0-9]\+\)[+-]\([0-9]\+\)[+-]\([0-9]\+\).*$/\1 \2 \3 \4/'))

GEOMETRY="1x1+$((VALUES[0] / 2 + VALUES[2] + 190))+${VALUES[3]}"
REGION="$((VALUES[0]/ 2 + VALUES[2]+ 190))x0+300+35"

(
    stalonetray --geometry "$GEOMETRY" &
    sleep 5
    ~/.local/src/hideIt.sh/hideIt.sh --name "stalonetray" -d top \
                                     --peek 0 --region "$REGION" &
) &

