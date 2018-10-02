#!/usr/bin/env bash

echo ""
ldapsearch -h localhost \
           -p 1389 \
           -x \
           -D$user \
           -w$pass \
           -b 'ou=people' \
           "(|(sn=$1*)(mail=$1*)(givenName=$1*))" \
           'mail' \
           'title' \
  | awk -F': ' \
        '/^uid/{uid=$2; getline; mail=$2; getline; title=$2; printf("%s\t%s\t%s\n",tolower(mail),uid,title)}'
