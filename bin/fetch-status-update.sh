#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

if [ "$(date +%A)" == Monday ]; then
  HOUR_DIFF=$(( 3 * 24 + 12 ))
else
  HOUR_DIFF=$(( 1 * 24 + 12 ))
fi

if [ -z "${SKIP_JIRA:-}" ]; then
  echo '##########'
  echo '#  JIRA  #'
  echo '##########'
  jira issue list --plain \
                  --assignee "$(git config user.email)" \
                  --updated "-${HOUR_DIFF}h" \
                  --columns "key,summary,status,updated"
fi

if [ -z "${SKIP_GERRIT:-}" ]; then
  echo '############'
  echo '#  GERRIT  #'
  echo '############'
  ssh gerrit -p29418 \
             gerrit query --format JSON -- \
                    "-age:${HOUR_DIFF}h" "and" "owner:me" |
  jq -r  '[.project, .subject, (.lastUpdated | strftime("%Y-%m-%d %H:%M")?)] | @sh' \
    | xargs printf "%s  %-80.80s  %s\n"

fi
