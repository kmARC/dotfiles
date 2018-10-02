#!/usr/bin/env bash

pkill -TERM mopidy
python2.7 -m mopidy --config ~/.config/mopidy/mopidy.conf:~/.pdotfiles/mopidy.conf &

