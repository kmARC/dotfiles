#!/usr/bin/env bash

echo "$(date +%T) $1" >> /tmp/idle.log

GRACE=5
LAPTOP=eDP-1

lock () {
  local immediately=$1
  local params=()
  if [ -z "$immediately" ]; then
    params+=(--fade-in "$GRACE.0" --grace "$GRACE")
  fi
  if ! pgrep swaylock &>/dev/null; then
    swaylock --daemonize \
             --screenshots \
             --indicator \
             --clock \
             --color 000000aa \
             --effect-blur 15x3 \
             --effect-vignette 0.1:0.9 \
             "${params[@]}"
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
    swaymsg "output $LAPTOP dpms on"
    ;;
  dpms_off )
    swaymsg "output $LAPTOP dpms off"
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
    lock "${2:-}"
    keep_clight false
    ;;
  suspend_battery )
    if acpi --ac-adapter | grep -q "off-line"; then
      systemctl suspend
    fi
    ;;
  suspend_ac )
    if acpi --ac-adapter | grep -q "on-line"; then
      systemctl suspend
    fi
    ;;
esac
