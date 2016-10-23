#!/usr/bin/env bash
MONS=($(xrandr | awk '/\sconnected\s/{print $1}'))
# NODES=$(bspc query -N | wc -l)
MODE=$1

# First init
# if [[ $NODES -eq 0 ]]; then
#bspc monitor -d 1 2 3 4 5 6 7 8 9 0
# fi

# Prints largest resolution mode
function largest_res {
    xrandr | awk -v PAT="$1" '$0 ~ PAT {getline; print $1}'
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
        xrandr --output "$SEC" --mode "$MOD_SEC" \
               --output "$PRI" --mode "$MOD_PRI" --same-as "$SEC" --primary
    else
        MOD_PRI=$(largest_res "$PRI")
        xrandr --output "$PRI" --mode "$MOD_PRI"
    fi
    # Move around desktops
    for desktop in 1 2 3 4 5 6 7 8 9 0; do
        bspc desktop $desktop -m "$PRI"
    done
    # Fix desktop order
    bspc monitor "$PRI" -o 1 2 3 4 5 6 7 8 9 0
fi

# Remove auto-created desktops (e.g. their name is not a digit)
for desktop in $(bspc query -T -m | jq -r '.desktops[].name' \
                                  | grep -v '^[0-9]$'); do
    bspc desktop "$desktop" -r
done


# Fix XFCE's workspace numbering
xfconf-query -c xfwm4 -p /general/workspace_count -s 10
xfconf-query -c xfwm4 -p /general/workspace_names -r
xfconf-query -c xfwm4 -p /general/workspace_names \
    -s 1 -s 2 -s 3 -s 4 -s 5 -s 6 -s 7 -s 8 -s 9 -s 0

# Add tray space on primary monitor
bspc config -m "$PRI" top_padding 24
