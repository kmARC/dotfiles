#!/bin/sh
echo `date` "$1 $2 $3" >> /tmp/redshift.txt
case $1 in
    period-changed)
        notify-send "Redshift" "Period changed from $2 to $3"

        case $3 in
          daytime|none|transition)
            gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
            sed --follow-symlinks -i "s/^colors:\s\+\*\\(light\|dark\\)/colors: *light/g" $HOME/.config/alacritty.yml
            ;;
          night)
            gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
            sed --follow-symlinks -i "s/^colors:\s\+\*\\(light\|dark\\)/colors: *dark/g" $HOME/.config/alacritty.yml
            ;;
        esac

esac

