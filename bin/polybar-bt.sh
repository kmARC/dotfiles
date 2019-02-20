#!/usr/bin/env bash

if [[ $(bluetoothctl show) =~ Powered:\ no ]]; then
  echo "" # Bluetooth disabled
elif [[ $(bluetoothctl info | grep -c 'Connected:.*yes') -eq 0 ]]; then
  echo "" # Bluetooth enabled but not connected
else
  echo "" # Bluetooth connected
fi
