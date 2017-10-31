#!/usr/bin/env bash
IFACE=$(ifconfig | awk -F':' '/^wl/{ print $1; exit }')

nmcli device disconnect "$IFACE"
sudo rmmod iwlmvm
sudo rmmod iwlwifi
echo "Removed wireless modules"
sleep 3
sudo modprobe iwlwifi
echo "Added wireless modules"
sudo systemctl restart NetworkManager
sleep 3
sudo iwlist "$IFACE" s
