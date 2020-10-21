#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

sudo systemctl stop bluetooth
sleep 3
pulseaudio -k
sleep 3
bluetoothctl connect 2C:41:A1:49:42:52

