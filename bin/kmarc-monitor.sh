#!/usr/bin/env bash
export DISPLAY=:0
export XAUTHORITY=$HOME/.Xauthority
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "$USER")/bus

"$HOME"/bin/desktop.sh
