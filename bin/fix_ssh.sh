#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

eval export "$(tmux show-environment SSH_AUTH_SOCK)"
