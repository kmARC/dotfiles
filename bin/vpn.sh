#!/usr/bin/env bash
PASS=$(secret-tool lookup private-key-password 'Mark Korondi')
sudo openconnect \
    -c .cisco/certificates/client/oro.pem \
    -k .cisco/certificates/client/private/oro.key \
    -p "$PASS" \
    --csd-wrapper=/usr/share/ibm-config-NetworkManager-openconnect/ohsd.py \
    --no-xmlpost \
    https://sasvpn.emea.ibm.com/
