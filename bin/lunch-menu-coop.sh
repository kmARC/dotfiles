#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

# Get your coop's location from https://www.coop-restaurant.ch/de/restaurantfinder.html
location=${COOP_RESTAURANT_LOCATION:-4630}

# Constants
domain="https://www.coop-restaurant.ch/"
url="$domain/de/menueseite.vst$location.restaurant.html"

if [ "$(uname)" == 'Darwin' ]; then
  open=open
else
  open=xdg-open
fi

# Calculate week number
week=$(( $(date +%W) ))
# Determine pdf link
pdf=$(curl -L $url | grep "<a.*${week}_${location}_de.pdf" | awk -F'"' '{ print $2; exit}')

TMPFILE="$(mktemp -t --suffix=.pdf lunch_menu_sh.XXXXXX)"
trap "rm -f '$TMPFILE'" 0               # EXIT
trap "rm -f '$TMPFILE'; exit 1" 2       # INT
trap "rm -f '$TMPFILE'; exit 1" 1 15    # HUP TERM

# Debug
echo https:$pdf on $TMPFILE

# Download and open
curl -o "$TMPFILE" "https:$pdf"
$open "$TMPFILE"

# Ensure xdg-open sucessfully opened the file
sleep 2
