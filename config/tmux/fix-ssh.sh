#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

# redirect everything to /tmp/k.txt
exec >> /tmp/tmux-ssh-debug.log 2>&1

function log() {
  echo "[$(date -Iseconds)] $*"
}

function pane_cmd() {
  tmux display -p -t "$pane" '#{pane_current_command}'
}

function is_vim() {
  pane_cmd | grep -iqE "(^|\/)g?(view|n?vim?x?)(diff)?$"
}

function is_bash() {
  pane_cmd | grep -iqE "(^|\/)bash$"
}

declare -A SSH_VARS=(
  [SSH_AUTH_SOCK]="$SSH_AUTH_SOCK"
  [SSH_CLIENT]="$SSH_CLIENT"
  [SSH_CONNECTION]="$SSH_CONNECTION"
  [SSH_TTY]="${SSH_TTY:-}"
)

# Check if environment variables are up-to-date
if grep -iqE "$(echo "${SSH_VARS[@]}" | md5sum)" /tmp/tmux-ssh-settings.md5; then
  log "SSH settings are up-to date"
  exit 0
fi
echo "${SSH_VARS[@]}" | md5sum > /tmp/tmux-ssh-settings.md5

# Check every pane for the running command and try to update the environment variables
for pane in $(tmux list-panes -a -F '#{pane_id}'); do
  variables=$(for var in "${!SSH_VARS[@]}"; do
                printf "%s=\"%s\" " "$var" "${SSH_VARS[$var]}"
              done)
  bash_cmd="export $variables"

  if ! is_bash; then 
    log "not bash: $(pane_cmd)"

    if is_vim; then
      commands=$(for var in "${!SSH_VARS[@]}"; do
                   printf "let \$%s=\"%s\" | " "$var" "${SSH_VARS[$var]}"
                 done)
      tmux send-keys -t "$pane" Escape ":${commands%|*} | call histdel(':', '.*SSH_.*')" Enter
      sleep 0.5
    fi

    # If not in a shell, then background the app (C-z) and bring to the foreground after
    tmux send-keys -t "$pane" C-z C-c
    bash_cmd+="; fg"
    sleep 1.0
  fi

  tmux send-keys -t "$pane" C-u "  $bash_cmd" Enter
done

