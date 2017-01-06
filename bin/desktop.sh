#!/usr/bin/env bash
MONS=($(xrandr | awk '/\sconnected\s/{print $1}'))
# NODES=$(bspc query -N | wc -l)
MODE=$1

# Initialization
if [[ $(bspc query -D | wc -l) != 10 ]]; then
    bspc monitor -d 1 2 3 4 5 6 7 8 9 0
fi

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

for monitor in $PRI $SEC; do
    # Remove auto-created desktops (e.g. their name is not a digit)
    for desktop in $(bspc query -T -m "$monitor" | jq -r '.desktops[].name' \
                                                 | grep -v '^[0-9]$'); do
        bspc desktop "$desktop" -r
    done
done

# Fix XFCE's workspace numbering
xfconf-query -c xfwm4 -p /general/workspace_count -r -R
xfconf-query -c xfwm4 -p /general/workspace_count -n -t int -s 10
xfconf-query -c xfwm4 -p /general/workspace_names -r -R
xfconf-query -c xfwm4 -p /general/workspace_names --create \
    -t string -s 1 -t string -s 2 -t string -s 3 -t string -s 4 -t string -s 5 \
    -t string -s 6 -t string -s 7 -t string -s 8 -t string -s 9 -t string -s 0

# Add tray space on primary monitor
bspc config -m "$PRI" top_padding 24

# Set wallpaper
~/.fehbg

# Set X keyboard related settings
setxkbmap us,hu ,102_qwerty_dot_dead -option "grp:alt_shift_toggle,caps:ctrl_modifier"
xcape -t 250 -e 'Caps_Lock=Escape'

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
