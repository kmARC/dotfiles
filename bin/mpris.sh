#!/usr/bin/env bash


# shellcheck source=/home/kmarc/.theme.bashrc
source "$HOME/.theme.bashrc"

prefix="%{F${base0d_html}}"

# check for spotify
if (playerctl -l | grep spotify) &>/dev/null; then
    player_status=$(playerctl status)
    metadata="$(playerctl metadata artist) - $(playerctl metadata title)"
else
    mpc_output=$(mpc status -f %title% + %name%)
    player_status=$(echo "$mpc_output" | awk 'FNR==2{print $1}')
    metadata=$(echo "$mpc_output" | head -1)
fi

# Foreground color formatting tags are optional
if [[ ${player_status,,} =~ .*playing.* ]]; then
    echo "$prefix%{F${base05_html}}%{O9}$metadata %{F-}"
elif [[ ${player_status,,} =~ .*paused.* ]]; then
    echo "$prefix%{F${base05_html}}%{O9}$metadata %{F-}"
else
    echo ""
fi
