#!/usr/bin/env bash

[ -z "$1" ] && exit -1

DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v1.0.0/$1.zip"
TARGET_DIR="fonts/dotbot/"
TARGET_FILE="$TARGET_DIR/$1.zip"

if [ ! -f "$TARGET_FILE" ]; then
    wget "$DOWNLOAD_URL" -O "$TARGET_FILE"
    unzip "$TARGET_FILE" -d "$TARGET_DIR"

fi
