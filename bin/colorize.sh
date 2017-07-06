# Source colorscheme
# shellcheck source=/home/kmarc/.colors.kmarc
source "$1"

[ -z "$1" ] && exit -1;
# Write X resource defines
{
    for C in {00..15}; do
        VAR=color$C
        echo "#define $VAR $(_html "${!VAR}")"
    done
    echo "#define color_foreground $(_html $color_foreground)"
    echo "#define color_background $(_html $color_background)"
    echo "#define color_foreground_alt $(_html "$color_foreground_alt")"
} > ~/.Xresources.colors

# Write bash html defines
{
    for C in {00..15}; do
        VAR=color$C
        echo "export $VAR=$(_html "${!VAR}")"
    done
    echo "export color_foreground=$(_html $color_foreground)"
    echo "export color_background=$(_html $color_background)"
    echo "export color_foreground_alt=$(_html "$color_foreground_alt")"
} > ~/.bashrc.colors_html

xrdb -load "$HOME/.Xresources"
