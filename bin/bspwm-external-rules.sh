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
  debug "case 1"
  [[ ${props[0],,} == *call\ minipanel* ]] && echo "state = floating sticky = true"
elif [[ ${props[1]} == *_SKIP_TASKBAR*_SKIP_PAGER* ]]; then
  debug "case 2"
  echo "border = false"
elif [[ ${props[1]} == *_STATE_ABOVE*              ]]; then
  debug "case 3"
  echo "state = floating"
  echo "border = false"
elif [[ ${props[2]} == *_TYPE_DIALOG*              ]]; then
  debug "case 4"
  echo "state = floating"
elif [[ "${props[3]}" =~ 0x3,\ 0x.,\ 0x0,\ 0x.,\ 0x. ]]; then
  debug "case 5"
  echo "state = floating"
elif [[ "${props[0]}" == *Loading\ Microsoft\ Teams* ]]; then
  debug "case 6"
  echo "border = true"
elif [ -z "$class" ]; then
  debug "case 7"
  [[ ${props[0],,} == *spotify* ]] && echo "desktop = 8 follow = on"
fi

