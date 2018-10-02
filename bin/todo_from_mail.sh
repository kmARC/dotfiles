#!/usr/bin/env bash
stdin=$(cat)

to="$(echo "$stdin" | awk -F': ' '/To:/{ print $2 }')"
to=${to,,}

context="@email"
[ -z "${to##*mark@korondi.ch*}" ]          && context="@KCC"
[ -z "${to##*mark@opsible.com*}" ]         && context="@Opsible"
[ -z "${to##*mark.korondi@acronis.com*}" ] && context="@Acronis"

email="$(echo "$stdin" | awk -F': ' '/From:/{ print $2 }')"
subject="$(echo "$stdin" | awk -F': ' '/Subject:/{ print $2 }')"

[ -n "$1" ] && rest=" $1"

todo.sh add "$context $(date +%Y-%m-%d) Follow up on '$subject' (from $email)$rest"
