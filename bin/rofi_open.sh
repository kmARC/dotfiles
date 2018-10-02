#!/usr/bin/env bash

# List all the non-hidden files from $HOME n a rofi-window and xdg-open the
# selected
FILE=$(locate -r "^${HOME}.*\\..*" \
          | grep -v '/\.' \
          | rofi -dmenu -i) \
       && xdg-open "$FILE"

