#!/usr/bin/env bash

# IBM Spyware
sudo systemctl start besclient
sudo systemctl start rtvscand
/opt/ibm/ibmsam/bin/ibmsaml -q &
/opt/ibm/c4eb/wst/bin/wst-applet &
/opt/Symantec/symantec_antivirus/savtray &
