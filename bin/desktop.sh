#!/usr/bin/env bash

# xbacklight -set 0 -time 500

BUILTIN_MON=${BUILTIN_MON:-eDP1}
MONS=($(xrandr | grep "$BUILTIN_MON" | awk '/ connected /{print $1}'))
MONS+=($(xrandr | grep -v "$BUILTIN_MON" | awk '/ connected /{print $1}'))
POSITION=${1:-left-of}

function debug {
  [ "x$DEBUG" != "x" ] && echo "$*"
}

# Prints largest resolution mode
function largest_res {
    xrandr | awk -v PAT="^$1 " '$0 ~ PAT {getline; print $1}'
}

# Prints common resolution of multiple monitors
function common_res {
    xrandr | sort -rn \
           | awk '{print $1}' \
           | uniq -d \
           | head -1
}

# Determines if given monitor is primary
function is_primary {
    xrandr | grep "$1 " \
           | grep primary \
           > /dev/null
}

# Focus the first desktops on all displays to prevent stale / removed desktops
CUR=$(bspc query -D -d)
bspc desktop -f 1

# Configure monitors
if [[ ${#MONS[@]} == 1 || $POSITION == 'mirror' ]]; then
    # Select primary monitor
    PRI=${MONS[0]}
    MOD_PRI=$(largest_res "$PRI")

    # Detect mirroring setting and set up monitors
    if [[ ${#MONS[@]} == 2 ]]; then
        SEC=${MONS[1]}
        MOD_PRI=$(common_res)
        MOD_SEC=${MOD_PRI}i
        xrandr --output "$SEC" --off
    fi
    echo "Setting up monitor: $PRI ($MOD_PRI)"
    xrandr --output "$PRI" --mode "$MOD_PRI" --primary

    # Move around desktops
    for desktop in 1 2 3 4 5 6 7 8 9 0; do
        bspc desktop $desktop -m "$PRI"
    done

    # Enable / disable monitors
    if [[ ${#MONS[@]} == 2 ]]; then
        xrandr --output "$PRI" --mode "$MOD_PRI" --rate 60 --primary \
               --output "$SEC" --mode "$MOD_SEC" --rate 60 --same-as "$PRI"
        bspc monitor "$SEC" -r
    fi

    # Fix desktop order
    bspc monitor "$PRI" -o 1 2 3 4 5 6 7 8 9 0

    # Set preferred brightness
    xbacklight -set 20 -time 500

    # Save primary monitor for polybar
    echo "$PRI" > /tmp/polybar-monitor.txt

else
    # Choose primary and secondary
    PRI=${MONS[1]}
    SEC=${MONS[0]}

    # Detect resolutions
    MOD_PRI=$(largest_res "$PRI")
    MOD_SEC=$(largest_res "$SEC")

    echo "Setting up monitors: primary   - $PRI ($MOD_PRI)"
    echo "                     secondary - $SEC ($MOD_SEC)"

    # Enable second monitor
    if ! is_primary "$PRI"; then
        xrandr --output "$PRI" --off
    fi
    xrandr --output "$SEC" --mode "$MOD_SEC" \
           --output "$PRI" --mode "$MOD_PRI" --"$POSITION" "$SEC" --primary

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

    # Set preferred brightness
    xbacklight -set 100 -time 500

    # Save primary monitor for polybar
    echo "$PRI" > /tmp/polybar-monitor.txt
fi

# Switch off not connected but still active monitors
ACTIVE_MONS=($(xrandr --listactivemonitors | awk '/[0-9]:/{ print $4}'))
for AMON in "${ACTIVE_MONS[@]}"; do
    REMOVE=1
    for CMON in "${MONS[@]}"; do
        [[ "$CMON" == "$AMON" ]] && REMOVE=0
    done
    [[ "$REMOVE" -eq 1 ]] && xrandr --output "$AMON" --off
done

# Remove unrecognized monitors, e.g. monitors that show up by bspc but not
# actually connected
BSPC_MON_IDS=($(bspc query -M))
for BMON in "${BSPC_MON_IDS[@]}"; do
  REMOVE=1
  for CMON in "${MONS[@]}"; do
    [[ "$CMON" == "$(bspc query -m "$BMON" -M --names)" ]] && REMOVE=0
  done
  if [[ "$REMOVE" -eq 1 ]]; then
    # Evacuate desktops before removal
    EVAC_DESKTOPS=($(bspc query -D -m "$BMON"))
    for ED in "${EVAC_DESKTOPS[@]}"; do
      bspc desktop "$ED" -m "$PRI";
    done
    # Remove the monitor
    bspc monitor "$BMON" -r
  fi
done

for monitor in $PRI $SEC; do
    # Remove auto-created desktops (e.g. their name is not a digit)
    for desktop in $(bspc query -T -m "$monitor" | jq -r '.desktops[].name' \
                                                 | grep -v '^[0-9]$'); do
        bspc desktop "$desktop" -r
    done
done

# Add tray space on primary monitor
bspc config -m "$PRI" top_padding 28
# Remove tray space from secondary monitor
[ -n "$SEC" ] && bspc config -m "$SEC" top_padding 0

# Set wallpaper
~/.fehbg

# Set X keyboard related settings
OPTIONS="grp:shifts_toggle,caps:ctrl_modifier"
setxkbmap -layout us,hu -variant ,102_qwerty_dot_dead -model pc105 -option -option "$OPTIONS"

MAC_KB=$(xinput | grep "Logitech Craft.*keyboard" \
                | sed 's/^.*id=\([0-9]*\).*$/\1/g')
if [ -n "$MAC_KB" ]; then
  echo "Found a MAC Keyboard! ID: $MAC_KB - Remapping"
  OPTIONS="$OPTIONS,altwin:swap_alt_win,altwin:alt_super_win"
  setxkbmap -device "$MAC_KB" -layout us,hu -variant ,102_qwerty_dot_dead -model pc105 -option -option "$OPTIONS"
  xmodmap -e 'keycode 94 = grave asciitilde'
fi

# Set X mouse related settings
for ID in $(xinput | grep "pointer" \
                   | grep -Eiv 'Virtual|Touch|Track|Synaptics' \
                   | sed 's/^.*id=\([0-9]*\).*$/\1/g'); do
    xinput set-button-map "$ID" 3 2 1
done

# Configure synaptics touchpad
synclient HorizTwoFingerScroll=1
synclient TapButton1=1
synclient TapButton2=3
synclient TapButton3=2
synclient ClickPad=1

# Focus previously focused desktop
bspc desktop -f "$CUR"

# Spawn polybar
if ! pgrep -x polybar >/dev/null; then
  polybar -r kmarc &
else
  touch -m "$HOME"/.config/polybar/config
fi

# Fix Java nonreparenting WM issue
~/bin/java_nonreparenting_wm_hack.sh

# Set up pulseaudio outputs properly
SINK=$(pactl list sinks | awk -v RS="" -F'#' '{ print $2 }' | tail -n0)
SINK_INPUTS=($(pactl list sink-inputs | awk -F'#' '/^Sink Input/{ print $2 }'))
for input in "${SINK_INPUTS[@]}"; do
  pactl move-sink-input "$input" "$SINK"
done

sleep 1

# Cleanup buggy unknown monitors
for unknown in $(xrandr | awk '/unknown/{ print $1 }'); do
  xrandr --output "$unknown" --auto
done
