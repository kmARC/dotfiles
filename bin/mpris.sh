#!/usr/bin/env bash


# shellcheck source=/home/kmarc/.colors.kmarc
source "$HOME/.theme.bashrc"

prefix="%{F${theme_html_color6}}"

# check for spotify
playerctl -l 2>/dev/null | grep spotify > /dev/null
if [[ $? -eq 0 ]]; then
    player_status=$(playerctl -p spotify status 2> /dev/null)
else
    player_status=$(playerctl status 2> /dev/null)
fi

if [[ $? -eq 0 ]]; then
    metadata="$(playerctl metadata artist 2> /dev/null) - $(playerctl metadata title 2>/dev/null)"
fi

# Foreground color formatting tags are optional
if [[ $player_status = "Playing" ]]; then
    echo "$prefix%{F${theme_html_foreground}}%{O9}$metadata %{F-}"
elif [[ $player_status = "Paused" ]]; then
    echo "$prefix%{F${theme_html_foreground}}%{O9}$metadata %{F-}"
else
    echo "$prefix%{F${theme_html_foreground}}%{O9}●%{O1}●%{O1}●%{O1}●%{O1}●%{O1}●%{O1}●%{O1}●%{O1}●%{O1}●%{O1} %{F-}"
fi
