#!/usr/bin/env bash

pkill -TERM mopidy
mopidy --config ~/.config/mopidy/mopidy.conf:~/.pdotfiles/mopidy.conf &

