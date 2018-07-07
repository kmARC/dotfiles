#!/usr/bin/env bash

# Courtesy of https://gist.github.com/briceburg/81d2c8d95a7cf4f61c0a
# Modifications by kmarc

# backlight brightness controls. use freely
# and adjust sysfs directory if not on toshiba
# $author Brice Burgess @iceburg 

sysfs="/sys/class/backlight/intel_backlight"
min=1
max=$(cat ${sysfs}/max_brightness)
step=25
level=$(cat ${sysfs}/brightness)

usage()
{
    script=${0##*/}
    echo
    echo "Invalid usage of ${script}!"
    echo "  $1"
    echo "----------------"
    echo "$script up     : increases brightness"
    echo "$script down   : decreases brightness"
    echo "$script set #  : sets brightness to # (integer)"
    echo "   min: $min max: $max"
    echo "----------------"
    echo

    exit 1
}

set_brightness()
{
    level=$1

    if [ $level -lt $min ] ; then
        level=$min
    elif [ $level -gt $max ] ; then
        level=$max
    fi

    echo $level > $sysfs/brightness
    sleep 0.1
    echo $level > $sysfs/brightness
}

case "$1" in
    up)
        let "level+=$step"
        set_brightness $level 
        ;;
    down)
        let "level-=$step"
        set_brightness $level 
        ;;
    set)
        if [[ ! $2 =~ ^[[:digit:]]+$ ]]; then
            usage "second argument must be an integer"
        fi
        set_brightness $2
        ;;
    max)
        set_brightness $max
        ;;
    *)
        usage "invalid argument"
esac

