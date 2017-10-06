#!/usr/bin/env bash

ffmpeg -i "$1" -vcodec libx264 "${1%.*}.mp4"
