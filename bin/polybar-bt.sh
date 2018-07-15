#!/usr/bin/env bash

if [[ $(bluetoothctl show) =~ 'No default' ]]; then
  echo "" # Bluetooth disabled
elif [[ $(bluetoothctl info | grep -c 'Connected:.*yes') -eq 0 ]]; then
  echo "" # Bluetoothe enabled but not connected
else
  echo "" # Bluetooth connected
fi
