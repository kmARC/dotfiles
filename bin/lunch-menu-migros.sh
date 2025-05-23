#!/usr/bin/env bash
set -Eeuo pipefail

trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

# Constants
DOMAIN="https://gastro.migros.ch"
URL="$DOMAIN/de/genossenschaften/zuerich/migros-restaurants.html"

out="${XDG_CACHE_HOME:-$HOME/.cache}/lunch-menu.pdf"

if [ "$(uname)" == 'Darwin' ]; then
  open=open
else
  open=xdg-open
fi

# Determine regex for the title string "Menü ab <day>. <month>"
regex_menu=$(LC_ALL=de_CH.UTF-8 date -d "last Monday" +'%d\.\s*%B')

# Determine pdf link
pdf=$(curl -L $URL | sed -n  's/.*<a.*href=.\([^"'"'""]\+\)..*title=.*$regex_menu.*/\1/gp")

# Download and open
curl -o "$out" "$DOMAIN/$pdf"
$open "$out"
