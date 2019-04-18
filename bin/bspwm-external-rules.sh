#!/usr/bin/env bash

wid=$1
class=$2
instance=$3

debug() { echo "$@" >> /tmp/bspwm-debug.txt; }

IFS=$'\n' props=($(xprop -id "$wid" _NET_WM_NAME \
                                    _NET_WM_STATE \
                                    _NET_WM_WINDOW_TYPE \
                                    _MOTIF_WM_HINTS))

debug "ID: $wid, class: $class, instance: $instance"
debug " \`--> state:  ${props[1]}"
debug " \`--> type:   ${props[2]}"
debug " \`--> hints:  ${props[3]}"
debug " \`--> wmname: ${props[0]}"

if   [[ $class == Slack ]]; then
  [[ ${props[0],,} == *call\ minipanel* ]] && echo "state = floating sticky = true"
elif [[ ${props[1]} == *"_NET_WM_STATE_ABOVE"*          ]]; then
  echo "state = floating"
elif [[ ${props[2]} == *"_NET_WM_WINDOW_TYPE_DIALOG"*   ]]; then
  echo "state = floating"
elif [ -z "$class" ]; then
  [[ ${props[0],,} == *spotify* ]] && echo "desktop = 8 follow = on"
fi

