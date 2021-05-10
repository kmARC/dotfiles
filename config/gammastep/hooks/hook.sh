#!/bin/env bash
echo `date` "$1 $2 $3" >> /tmp/gammastep.txt
case $1 in
    period-changed)
        notify-send "Gammastep" "Period changed from $2 to $3"

        case $3 in
          transition|daytime|none)
            gsettings set org.gnome.desktop.interface gtk-theme 'Arc'
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=Arc/g"      $HOME/.config/gtk-3.0/settings.ini
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=\"Arc\"/g"  $HOME/.gtkrc-2.0
            sed --follow-symlinks -i "s/^colors:\s\+\*\\(light\|dark\\)/colors: *light/g" $HOME/.config/alacritty.yml
            sed --follow-symlinks -i '/# DynamicBackground/{n;s/.*/background-color=#00000099/}' $HOME/.config/mako/config
            sed --follow-symlinks -i '/# DynamicForeground/{n;s/.*/text-color=#ffffff/}' $HOME/.config/mako/config
            sed --follow-symlinks -i 's/light.rasi/dark.rasi/'                           $HOME/.config/rofi/config.rasi
            if [[ ! "$2" =~ (transition|daytime|none) ]]; then
              swaymsg output '*' bg ~/Pictures/Wallpaper.jpg fill
              swaymsg client.focused          '#000000' '#000000' '#ffffff'
              swaymsg client.focused_inactive '#ffffff' '#ffffff' '#000000'
              swaymsg client.unfocused        '#ffffff' '#ffffff' '#000000'
            fi
            ;;
          night)
            gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=Arc-Dark/g"     $HOME/.config/gtk-3.0/settings.ini
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=\"Arc-Dark\"/g" $HOME/.gtkrc-2.0
            sed --follow-symlinks -i "s/^colors:\s\+\*\\(light\|dark\\)/colors: *dark/g"         $HOME/.config/alacritty.yml
            sed --follow-symlinks -i '/# DynamicBackground/{n;s/.*/background-color=#ffffffbb/}' $HOME/.config/mako/config
            sed --follow-symlinks -i '/# DynamicForeground/{n;s/.*/text-color=#000000/}' $HOME/.config/mako/config
            sed --follow-symlinks -i 's/dark.rasi/light.rasi/'                           $HOME/.config/rofi/config.rasi
            if [[ "$2" =~ (none|transition|daytime) ]]; then
              swaymsg output '*' bg ~/Pictures/Wallpaper-dark.jpg fill
              swaymsg client.focused          '#ffffff' '#ffffff' '#000000'
              swaymsg client.focused_inactive '#000000' '#000000' '#ffffff'
              swaymsg client.unfocused        '#000000' '#000000' '#ffffff'
            fi
            ;;
        esac
esac
makoctl reload

