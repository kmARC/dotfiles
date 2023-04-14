#!/bin/env bash
echo `date` "$1 $2 $3" >> /tmp/gammastep.txt
case $1 in
    period-changed)
        notify-send "Gammastep" "Period changed from $2 to $3"

        case $3 in
          transition|daytime|none)
            gsettings set org.gnome.desktop.interface gtk-theme 'Arc'
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=Arc/g"         $HOME/.config/gtk-3.0/settings.ini
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=\"Arc\"/g"     $HOME/.gtkrc-2.0
            sed --follow-symlinks -i "s/\\(&colorscheme.*\\)dark\\(.*\\)/\1light\2/g"   $HOME/.config/alacritty.yml
            sed --follow-symlinks -i '/# DynamicBackground/{n;s/.*/background-color=#00000099/}' $HOME/.config/mako/config
            sed --follow-symlinks -i '/# DynamicForeground/{n;s/.*/text-color=#ffffff/}' $HOME/.config/mako/config
            sed --follow-symlinks -i 's/light.rasi/dark.rasi/'                           $HOME/.config/rofi/config.rasi
            if [[ ! "$2" =~ (transition|daytime|none) ]]; then
              swaymsg output '*' bg ~/Pictures/Wallpaper.jpg fill

              export bg='#ffffff'
              export black='#ebebeb'
              export br_black='#cdcdcd'
              export white='#878787'
              export fg='#474747'
              export br_white='#282828'

              export red='#d6000c'
              export green='#1d9700'
              export yellow='#c49700'
              export blue='#0064e4'
              export magenta='#dd0f9d'
              export cyan='#00ad9c'
              export orange='#d04a00'
              export violet='#7f51d6'

              export br_red='#bf0000'
              export br_green='#008400'
              export br_yellow='#af8500'
              export br_blue='#0054cf'
              export br_magenta='#c7008b'
              export br_cyan='#009a8a'
              export br_orange='#ba3700'
              export br_violet='#6b40c3'

              swaymsg client.focused          $blue $blue $bg $blue
              swaymsg client.focused_inactive $bg $bg $fg $blue
              swaymsg client.unfocused        $bg $bg $fg $blue
            fi
            ;;
          night)
            gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=Arc-Dark/g"     $HOME/.config/gtk-3.0/settings.ini
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=\"Arc-Dark\"/g" $HOME/.gtkrc-2.0
            sed --follow-symlinks -i "s/\\(&colorscheme.*\\)light\\(.*\\)/\1dark\2/g"    $HOME/.config/alacritty.yml
            sed --follow-symlinks -i '/# DynamicBackground/{n;s/.*/background-color=#ffffffbb/}' $HOME/.config/mako/config
            sed --follow-symlinks -i '/# DynamicForeground/{n;s/.*/text-color=#000000/}' $HOME/.config/mako/config
            sed --follow-symlinks -i 's/dark.rasi/light.rasi/'                           $HOME/.config/rofi/config.rasi
            if [[ "$2" =~ (none|transition|daytime) ]]; then
              swaymsg output '*' bg ~/Pictures/Wallpaper-dark.jpg fill

              export bg='#181818'
              export black='#252525'
              export br_black='#3b3b3b'
              export white='#777777'
              export fg='#b9b9b9'
              export br_white='#dedede'

              export red='#ed4a46'
              export green='#70b433'
              export yellow='#dbb32d'
              export blue='#368aeb'
              export magenta='#eb6eb7'
              export cyan='#3fc5b7'
              export orange='#e67f43'
              export violet='#a580e2'

              export br_red='#ff5e56'
              export br_green='#83c746'
              export br_yellow='#efc541'
              export br_blue='#4f9cfe'
              export br_magenta='#ff81ca'
              export br_cyan='#56d8c9'
              export br_orange='#fa9153'
              export br_violet='#b891f5'

              swaymsg client.focused          $blue $blue $bg $blue
              swaymsg client.focused_inactive $bg $bg $fg $blue
              swaymsg client.unfocused        $bg $bg $fg $blue
            fi
            ;;
        esac
esac
makoctl reload
killall -10 vim

