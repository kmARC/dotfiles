#!/usr/bin/env bash

echo "$(date +%T) $1" >> /tmp/idle.log

GRACE=3

lock () {
  if ! pgrep swaylock &>/dev/null; then
    swaylock --daemonize \
             --screenshots \
             --clock \
             --fade-in 1.0 \
             --effect-blur 15x3 \
             --effect-vignette 0.1:0.9 \
             --grace "$GRACE"
  fi
}

case "$1" in
  dpms_on )
    if pgrep swaylock &>/dev/null; then
      swaymsg 'output * dpms on'
      brightnessctl -d 'tpacpi::kbd_backlight' -r
    fi
    ;;
  dpms_off )
    if pgrep swaylock &>/dev/null; then
      swaymsg 'output * dpms off'
      if [ "$(brightnessctl -d 'tpacpi::kbd_backlight' get)" -ne 0 ]; then
        brightnessctl -d 'tpacpi::kbd_backlight' -s set 0
      else
        brightnessctl -d 'tpacpi::kbd_backlight' set 0
      fi
    fi
    ;;
  lock_battery )
    if acpi --ac-adapter | grep -q "off-line"; then
      lock
      sleep "$GRACE"
      $0 dpms_off
    fi
    ;;
  lock_ac )
    if acpi --ac-adapter | grep -q "on-line"; then
      lock
      sleep "$GRACE"
      $0 dpms_off
    fi
    ;;
  lock )
    lock
    ;;
  brightness_down )
    if acpi --ac-adapter | grep -q "off-line"; then
      brightnessctl set -s 5%
    else
      brightnessctl get -s
    fi
    ;;
  brightness_back )
    brightnessctl -r
    ;;
esac
