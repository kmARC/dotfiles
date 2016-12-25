#!/usr/bin/env bash

pactl set-source-mute "$(pacmd list-sources|awk '/\* index:/{ print $3 }')" toggle
