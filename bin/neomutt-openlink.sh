#!/usr/bin/env bash
set -euo pipefail

URL=$(awk '/\['"$1"'\][ ]+http/{ print $2; exit }' < /dev/stdin)
firefox "$URL"

