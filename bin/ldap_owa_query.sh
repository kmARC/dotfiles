#!/usr/bin/env bash

echo ""
ldapsearch -h localhost \
           -p 1389 \
           -x \
           -D$1 \
           -w$2 \
           -b 'ou=people' \
           "(|(sn=$3*)(mail=$3*)(givenName=$3*))" \
           'mail' \
           'title' \
  | awk -F': ' \
        '/^uid/{uid=$2; getline; mail=$2; getline; title=$2; printf("%s\t%s\t%s\n",tolower(mail),uid,title)}'
