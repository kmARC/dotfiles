#!/usr/bin/env bash

#! /bin/sh

wid=$1
class=$2
instance=$3

echo "$wid, $class, $instance" >> /tmp/bspwm-debug.txt

if [ "$class" = Slack ]; then
    if [[ "$(xprop -id "$wid" WM_NAME)" == *"Call Minipanel"* ]]; then
        echo "state = floating"
    fi
elif [[ $class =~ Vivaldi|Firefox ]]; then
    if [[ "$(xprop -id "$wid" WM_NAME)" == *"Pushbullet"* ]]; then
        echo "state = floating"
    fi
elif [[ $class =~ Chromium-browser ]]; then
    if [[ "$(xprop -id "$wid" WM_NAME)" == *"Popcorn Time"* ]]; then
        echo "desktop = 8 follow = on"
    fi
elif [ -z "$class" ]; then
    wmname=$(xprop -id "$wid" WM_NAME)
    if [[ $wmname =~ not\ found ]]; then
        echo "not found!" >> /tmp/bspwm-debug.txt
        echo "state = floating"
        (
            sleep 0.5
            wmname=$(xprop -id "$wid" WM_NAME)
            if [[ "$wmname" == *"Spotify"* ]]; then
                echo "move around spotify window" >> /tmp/bspwm-debug.txt
                bspc node "$wid" --state tiled --focus --desktop 8
            else
                bspc node "$wid" --state tiled --focus
            fi
        ) &
    fi
fi
