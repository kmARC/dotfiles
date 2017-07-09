#!/usr/bin/env bash

# Hide tray
transset -n stalonetray 0

# Kill panel while reconfiguring monitors
killall -q polybar

MONS=($(xrandr | awk '/ connected /{print $1}'))
MODE=$1

# Prints largest resolution mode
function largest_res {
    xrandr | awk -v PAT="^$1" '$0 ~ PAT {getline; print $1}'
}

# Prints common resolution of multiple monitors
function common_res {
    xrandr | sort -rn \
           | awk '{print $1}' \
           | uniq -d \
           | head -1
}

function is_primary {
    xrandr | grep "$1" \
           | grep primary \
           > /dev/null
}

# Focus the first desktops on all displays to prevent stale / removed desktops
CUR=$(bspc query -D -d)
# bspc desktop -f 6
bspc desktop -f 1

# Configure monitors
if [[ ${#MONS[@]} == 2 && $MODE != 'mirror' ]]; then
    # Choose primary and secondary
    if [[ $MODE == 'reverse' ]]; then
        PRI=${MONS[0]}
        SEC=${MONS[1]}
    else
        PRI=${MONS[1]}
        SEC=${MONS[0]}
    fi

    # Detect resolutions
    MOD_PRI=$(largest_res "$PRI")
    MOD_SEC=$(largest_res "$SEC")

    echo "Setting up monitors: primary   - $PRI ($MOD_PRI)"
    echo "                     secondary - $SEC ($MOD_SEC)"
    # Enable second monitor
    if ! is_primary $PRI; then
        xrandr --output "$PRI" --off
    fi
    xrandr --output "$SEC" --mode "$MOD_SEC" \
           --output "$PRI" --mode "$MOD_PRI" --left-of "$SEC" --primary
    # Move around desktops
    for desktop in 1 2 3 4 5; do
        bspc desktop $desktop -m "$PRI"
    done
    for desktop in 6 7 8 9 0; do
        bspc desktop $desktop -m "$SEC"
    done
    # Fix desktop order
    bspc monitor "$PRI" -o 1 2 3 4 5
    bspc monitor "$SEC" -o 6 7 8 9 0
    # Remove tray space from secondary monitor
    bspc config -m "$SEC" top_padding 0
else
    # Select primary monitor
    PRI=${MONS[0]}
    # Detect mirroring setting and set up monitors
    if [[ ${#MONS[@]} == 2 && $MODE == 'mirror' ]]; then
        SEC=${MONS[1]}
        MOD_PRI=$(common_res)
        MOD_SEC=$MOD_PRI
        xrandr --output "$SEC" --off
    else
        MOD_PRI=$(largest_res "$PRI")
    fi
    echo "Setting up monitor: $PRI ($MOD_PRI)"
    xrandr --output "$PRI" --mode "$MOD_PRI" --primary
    # Move around desktops
    for desktop in 1 2 3 4 5 6 7 8 9 0; do
        bspc desktop $desktop -m "$PRI"
    done
    if [[ ${#MONS[@]} == 2 && $MODE == 'mirror' ]]; then
        xrandr --output "$PRI" --mode "$MOD_PRI" --rate 60 --primary \
               --output "$SEC" --mode "$MOD_SEC" --rate 60 --same-as "$PRI"
        bspc monitor "$SEC" -r
    fi
    # Fix desktop order
    bspc monitor "$PRI" -o 1 2 3 4 5 6 7 8 9 0
fi

# Switch off not connected but still active monitors
ACTIVE_MONS=($(xrandr --listactivemonitors | awk '/[0-9]:/{ print $4}'))
for AMON in "${ACTIVE_MONS[@]}"; do
    REMOVE=1
    for CMON in "${MONS[@]}"; do
        [[ "$CMON" == "$AMON" ]] && REMOVE=0
    done
    [[ "$REMOVE" -eq 1 ]] && xrandr --output $AMON --off
done

for monitor in $PRI $SEC; do
    # Remove auto-created desktops (e.g. their name is not a digit)
    for desktop in $(bspc query -T -m "$monitor" | jq -r '.desktops[].name' \
                                                 | grep -v '^[0-9]$'); do
        bspc desktop "$desktop" -r
    done
done

# Set wallpaper
~/.fehbg

# Set X keyboard related settings
setxkbmap us,hu ,102_qwerty_dot_dead -option "grp:alt_shift_toggle,caps:ctrl_modifier"

# Set X mouse related settings
for ID in $(xinput | grep pointer \
                   | grep -Eiv 'Virtual|Touch|Track' \
                   | sed 's/^.*id=\([0-9]*\).*$/\1/g'); do
    xinput set-button-map "$ID" 3 2 1
done

# Configure synaptics touchpad
synclient HorizTwoFingerScroll=1
synclient TapButton3=2

# Fix Java nonreparenting WM issue
~/bin/java_nonreparenting_wm_hack.sh

# Help polybar by calculating it's desired width
echo $(( $(xrandr | grep primary \
                  | sed -r 's/^.*[^0-9]([0-9]+)x[0-9]+.*$/\1/g') - 16 )) \
    > /tmp/polybar-width.txt
polybar -m | grep '+0+0' | cut -d':' -f1 \
    > /tmp/polybar-monitor.txt

bspc desktop -f "$CUR"

# Spawn panel
while pgrep -x polybar >/dev/null; do sleep 0.5; done
polybar -r kmarc >> /dev/null 2>&1 &

# Position and show stalonetray
xdo move -N stalonetray -x $(($(cat /tmp/polybar-width.txt) / 2 - 290))
(
    sleep 1
    xdo above -t "$(xdo id -n polybar)" "$(xdo id -n stalonetray)"
    transset -n stalonetray 0.5
)

# Setting WM name to something java compatible
wmname LG3D
