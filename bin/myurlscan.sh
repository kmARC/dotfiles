#!/usr/bin/env bash
# set -euo pipefail

TMPFILE="$(mktemp -t --suffix=.SUFFIX myurlscan_sh.XXXXXX)"
trap "rm -f '$TMPFILE'" 0               # EXIT
trap "rm -f '$TMPFILE'; exit 1" 2       # INT
trap "rm -f '$TMPFILE'; exit 1" 1 15    # HUP TERM


echo $(</dev/stdin) > $TMPFILE
url=$(w3m -dump -o display_link_number=true -T text/html $TMPFILE | awk -F' ' '/^\['$1'/{print $2}')
echo URL: $url
cat $TMPFILE
xdg-open "$url"

