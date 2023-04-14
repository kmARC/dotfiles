#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

export BW_SESSION="$(bw unlock --raw)"
export GARMIN_PASSWORD="$(bw get password garmin.com)"
export GARMIN_USERNAME="$(bw get username garmin.com)"

if [ "${#@}" -gt 0 ]; then
  withings-sync "$@"
else
  withings-sync --fromdate "$(date +%Y-%m-%d)"
fi


