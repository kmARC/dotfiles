#!/usr/bin/env bash

WINDOW_ID=$(wmctrl -l | grep 'tmux.*Session' | grep $HOSTNAME | awk '{print $1}')

if [ ! -z "$WINDOW_ID" ]; then
    echo "exists"
    # Window exist, switch to it
    bspc node -f $WINDOW_ID
    tmux select-window -t music
else
    echo "not exists"
    x-terminal-emulator -ls -e bash -ci 'tmux attach -t Session \; find-window music'
fi
