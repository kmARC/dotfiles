#!/usr/bin/env sh
>&2 echo "xdg-open $*" >> /tmp/reverse-ssh-browser.log
ssh reverse-ssh "xdg-open $*"
