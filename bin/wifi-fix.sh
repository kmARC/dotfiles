#!/usr/bin/env bash
IFACE=wlp3s0

nmcli device disconnect $IFACE
sudo rmmod iwlmvm
sudo rmmod iwlwifi
echo "Removed wireless modules"
sleep 3
sudo modprobe iwlwifi
echo "Added wireless modules"
sleep 3
sudo iwlist $IFACE s
