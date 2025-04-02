#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

BW_SESSION="$(cat "$XDG_RUNTIME_DIR"/bw-session || true)"
export BW_SESSION
if ! bw unlock --check; then
  bw unlock --raw > "$XDG_RUNTIME_DIR"/bw-session
  BW_SESSION="$(cat "$XDG_RUNTIME_DIR"/bw-session)"
  export BW_SESSION
fi
GARMIN_PASSWORD="$(bw get password garmin.com)"
GARMIN_USERNAME="$(bw get username garmin.com)"

export GARMIN_PASSWORD
export GARMIN_USERNAME

if [ "${#@}" -gt 0 ]; then
  withings-sync "$@"
else
  withings-sync --fromdate "$(date +%Y-%m-%d)"
fi


