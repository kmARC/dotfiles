#!/usr/bin/env bash

pkill -TERM -f 'python.*mopidy'
python -m mopidy --config ~/.config/mopidy/mopidy.conf:~/.pdotfiles/mopidy.conf &

