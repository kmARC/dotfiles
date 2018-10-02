#!/usr/bin/env bash

# Selects a timezone based on the name of the city provided.
# Example: timezone.sh Zurich

wanted=$(timedatectl list-timezones | grep -i "$1")

sudo timedatectl set-timezone "$wanted"

