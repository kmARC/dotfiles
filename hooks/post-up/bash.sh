#!/usr/bin/env bash

SOURCE_LINE="source $HOME/.bashrc.kmarc"

if ! grep -Fxq "$SOURCE_LINE" "$HOME/.bashrc"; then
    echo "$SOURCE_LINE" >> "$HOME/.bashrc"
fi
