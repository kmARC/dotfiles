#!/usr/bin/env bash
alacritty -e bash -c "\
     docker ps \
  && nmcli device modify docker0 ipv4.routes '11.112.0.0/16 172.17.0.2' \
  && x11docker --share /dev/net/tun \
               --sudouser \
               --dbus \
               --runasroot 'iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE' \
               --name f5vpn \
               -- \
               --sysctl net.ipv4.ip_forward=1 \
               --cap-add=NET_ADMIN \
               -- \
               f5vpn \
               f5vpn '$@' \
  && read"
