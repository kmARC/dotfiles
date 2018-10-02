#!/usr/bin/env bash

# PID_HIDEIT=($(pgrep -f bash.*hideIt))
# PID_TRAY=$(pgrep stalonetray)
# WID_TRAY=$(xwininfo -root -tree \
#            | awk '/"stalonetray"/{ print $1 }')
PID_TRAY=$(pgrep xfce4-panel)
WID_TRAY=$(xwininfo -root -tree \
           | awk '/"xfce4-panel"/{ print $1 }')

# for p in "${PID_HIDEIT[@]}"; do
#     echo killing $p hideit
#     kill "$p"
# done

# Sleep a bit until stalonetray comes back
sleep 0.5

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

BAR_WIDTH=$(cat /tmp/polybar-width.txt)
BAR_HEIGHT=${VALUES[1]}
BAR_X=${VALUES[2]}
BAR_Y=${VALUES[3]}

POS_X=$((BAR_WIDTH / 2 + BAR_X + 90))
POS_Y=${BAR_Y}
echo $BAR_WIDTH
echo $BAR_X
echo $POS_X  $POS_Y
GEOMETRY="1x1+${POS_X}+${POS_Y}"
REGION="${POS_X}x${POS_Y}+200+${BAR_HEIGHT}"

if [ -z "$PID_TRAY" ]; then
    echo starting window
    xfce4-panel -d &
else
    echo moving window
    xdotool windowmove "${WID_TRAY}" "${POS_X}" "${POS_Y}"
fi

# hideIt.sh --name '^stalonetray$' -d top --peek 0 --region "$REGION"
