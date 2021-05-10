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

locked() {
  pgrep swaylock &>/dev/null
}

keep_clight() {
  busctl --user --expect-reply=false \
         set-property  org.clight.clight \
                      /org/clight/clight/Conf/Backlight \
                       org.clight.clight.Conf.Backlight \
           NoAutoCalib "b" "$1"
}

clight_kept() {
  busctl --user \
         get-property  org.clight.clight \
                      /org/clight/clight/Conf/Backlight \
                       org.clight.clight.Conf.Backlight \
           NoAutoCalib \
  | grep -q true
}

case "$1" in
  idle )
    locked && $0 dpms_off
    keep_clight false
    ;;
  active )
    locked && $0 dpms_on
    keep_clight true
    ;;
  dpms_on )
    swaymsg 'output * dpms on'
    ;;
  dpms_off )
    swaymsg 'output * dpms off'
    ;;
  lock_battery )
    if acpi --ac-adapter | grep -q "off-line"; then
      lock
      sleep "$GRACE"
      locked && $0 dpms_off
    fi
    ;;
  lock_ac )
    if acpi --ac-adapter | grep -q "on-line"; then
      lock
      sleep "$GRACE"
      locked && $0 dpms_off
    fi
    ;;
  lock )
    lock
    keep_clight false
    ;;
esac
