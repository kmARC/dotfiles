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

monitor_bell="$(tmux show-option -gv monitor-bell)"
tmux set-option -g monitor-bell off

# Check every pane for the running command and try to update the environment variables
for pane in $(tmux list-panes -a -F '#{pane_id}'); do
  variables=$(for var in "${!SSH_VARS[@]}"; do
                printf "%s=\"%s\" " "$var" "${SSH_VARS[$var]}"
              done)
  bash_cmd="export $variables"

  log "$(tmux display -t "$pane" -p "#{window_index}.#{pane_index}") command: $(pane_cmd)"

  if is_bash; then 
    nop
  else
    if is_vim; then
      commands=$(for var in "${!SSH_VARS[@]}"; do
                   printf "let \$%s=\"%s\" | " "$var" "${SSH_VARS[$var]}"
                 done)
      tmux send-keys -t "$pane" Escape Escape ":${commands%|*} | call histdel(':', '.*SSH_.*')" Enter
      # sleep 0.5
    fi

    # If not in a shell, then background the app (C-z) and bring to the foreground after
    tmux send-keys -t "$pane" C-z
    sleep 0.1
    tmux send-keys -t "$pane" C-c
    bash_cmd+="; fg"
  fi

  tmux send-keys -t "$pane" C-u "  $bash_cmd" Enter
done
tmux set-option -g monitor-bell "$monitor_bell"
