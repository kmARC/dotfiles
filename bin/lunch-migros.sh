#!/usr/bin/env bash

DOMAIN=https://www.migros.ch
PAGE=$DOMAIN/de/genossenschaften/migros-zuerich/standorte/gastronomie/migros-restaurants.html
PDF_PATH=$(curl "$PAGE" | awk -F'"' "/KW$(date +%W).2018.pdf/{ print \$2 }")

evince "${DOMAIN}${PDF_PATH}"
