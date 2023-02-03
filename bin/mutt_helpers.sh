#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

function _query_keychain() {
  local service="$1"
  local account="$2"
  if [[ $(uname) == "Darwin"* ]]; then
    security find-generic-password -w -s "$service" -a "$account"
  else
    secret-tool lookup "$service" "$account"
  fi
}

function mailboxes() {
  local from=$1
  echo -n "'=INBOX' "
  find "$HOME/.mutt/$from" -type d -name cur ! -wholename '*INBOX*' | sort | sed "s#\(.*\)/\(.*\)/cur#'=\2' #g" | tr -d '\n'
}

function smtp_pass() {
  local kind="$1"
  local from="$2"
  _query_keychain "$kind"-pass "$from"
}

function query_command() {
  local kind="$1"
  local from="$2"
  local query="$3"
  local pass
  local username
  if [[ "$kind" == "owa" ]]; then
    pass=$(smtp_pass "$kind" "$from")
    username=$(my_username "$kind" "$from")
    echo ""
    ldapsearch -H ldap://localhost:1389 \
               -x \
               -D"$username" \
               -w"$pass" \
               -b 'ou=people' \
               "(|(sn=$query*)(mail=$query*)(givenName=$query*))" \
               'mail' \
               'title' \
      | awk -F': ' \
            '/^uid/{uid=$2; getline; mail=$2; getline; title=$2; printf("%s\t%s\t%s\n",tolower(mail),uid,title)}'
  else
    khard email -a "$from" -p "$query"
  fi
}

function my_username() {
  local kind="$1"
  local from="$2"
  if [[ "$kind" == "owa" ]]; then
    _query_keychain "$kind"-username "$from"
  else
    echo "$from"
  fi
}

function query_id() {
  local kind="$1"
  local from="$2"
  local query="$3"
  local pass
  local username
  pass=$(smtp_pass "$kind" "$from")
  username=$(my_username "$kind" "$from")
  echo ""
  ldapsearch -H ldap://dctrading01.trading.imc.intra:3268 \
             -b 'DC=trading,DC=imc,DC=intra' \
             -E pr=1000/noprompt \
             "(|(sn=$query*)(mail=$query*)(givenName=$query*))" 
}

$1 "${@:2}"

