#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

# Constants
domain="https://www.migros.ch"
url="$domain/de/genossenschaften/migros-zuerich/standorte/gastronomie/migros-restaurants.html"

# Calculate week number
week=$(( $(date +%W) + 1))
# Determine pdf link
pdf=$(curl $url | grep "<a.*$week.*pdf" | awk -F'"' '{ print $2; exit}')

TMPFILE="$(mktemp -t --suffix=.pdf lunch_menu_sh.XXXXXX)"
trap "rm -f '$TMPFILE'" 0               # EXIT
trap "rm -f '$TMPFILE'; exit 1" 2       # INT
trap "rm -f '$TMPFILE'; exit 1" 1 15    # HUP TERM

# Debug
echo $domain$pdf on $TMPFILE

# Download and open
curl -o "$TMPFILE" "$domain$pdf"
xdg-open "$TMPFILE"

# Ensure xdg-open sucessfully opened the file
sleep 2
