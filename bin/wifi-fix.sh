#!/usr/bin/env bash
sudo rmmod iwlmvm
sudo rmmod iwlwifi
sudo modprobe iwlwifi
sleep 3
sudo iwlist wlp3s0 s
