#!/bin/sh
echo `date` "$1 $2 $3" >> /tmp/redshift.txt
case $1 in
    period-changed)
        notify-send "Redshift" "Period changed from $2 to $3"

        case $3 in
          daytime|none)
            gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=Adwaita/g"      $HOME/.config/gtk-3.0/settings.ini
            sed --follow-symlinks -i "s/^Net\/ThemeName.*/Net\/ThemeName \"Adwaita\"/g"   $HOME/.xsettingsd ; pkill xsettingsd
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=\"Adwaita\"/g"  $HOME/.gtkrc-2.0
            sed --follow-symlinks -i "s/^colors:\s\+\*\\(light\|dark\\)/colors: *light/g" $HOME/.config/alacritty.yml
            ;;
          night|transition)
            gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=Adwaita-dark/g"     $HOME/.config/gtk-3.0/settings.ini
            sed --follow-symlinks -i "s/^Net\/ThemeName.*/Net\/ThemeName \"Adwaita-dark\"/g"  $HOME/.xsettingsd ; pkill xsettingsd
            sed --follow-symlinks -i "s/^gtk-theme-name=.*/gtk-theme-name=\"Adwaita-dark\"/g" $HOME/.gtkrc-2.0
            sed --follow-symlinks -i "s/^colors:\s\+\*\\(light\|dark\\)/colors: *dark/g"      $HOME/.config/alacritty.yml
            ;;
        esac

esac

