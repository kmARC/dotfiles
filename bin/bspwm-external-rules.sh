#!/usr/bin/env bash

#! /bin/sh

wid=$1
class=$2
instance=$3

# echo $wid, $class, $instance > /tmp/bspwm-debug.txt

if [ "$class" = Slack ]; then
    if [[ "$(xprop -id "$wid" WM_NAME)" == *"Call Minipanel"* ]]; then
        echo "state = floating"
    fi
fi
