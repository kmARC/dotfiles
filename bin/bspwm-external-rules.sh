#!/usr/bin/env bash

#! /bin/sh

wid=$1
class=$2
instance=$3
wmname=$(xprop -id "$wid" _NET_WM_NAME)

{
  echo "ID: $wid, class: $class, instance: $instance"
  echo " \`--> type: $(xprop -id "$wid" _NET_WM_WINDOW_TYPE)"
  echo " \`--> state: $(xprop -id "$wid" _NET_WM_STATE)"
  echo " \`--> wmname: $wmname"
} >> /tmp/bspwm-debug.txt

if [[ "$(xprop -id "$wid" _NET_WM_STATE)" == *"_NET_WM_STATE_ABOVE"* ]]; then
    echo "border = off state = floating"
elif [[ "$(xprop -id "$wid" _NET_WM_WINDOW_TYPE)" == *"_NET_WM_WINDOW_TYPE_DIALOG"* ]]; then
    echo "state = floating"
elif [[ "$(xprop -id "$wid" _NET_WM_WINDOW_TYPE)" == *"_NET_WM_WINDOW_TYPE_NORMAL"* ]]; then
    echo "state = tiled"
fi

if [[ $class =~ Slack ]]; then
    if [[ "$wmname" == *"Call Minipanel"* ]]; then
        echo "state = floating"
    fi
elif [ -z "$class" ]; then
    if [[ $wmname =~ Spotify ]]; then
      echo "desktop = 8 follow = on"
    fi
fi
