#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

PKGs() {
  pacman -Q | grep -Ee '-(bzr|cvs|darcs|git|hg|svn)'
}

OLD=$(PKGs)

echo "Upgrading the following packages: "
PKGs
echo "OK? "
read -r

yay -Syu $(PKGs | cut -d' ' -f1)

NEW=$(PKGs)

diff -u --color=always <(echo "$OLD") <(echo "$NEW") | /usr/share/git/diff-highlight/diff-highlight


