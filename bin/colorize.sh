#!/usr/bin/env bash

##############
#  Settings  #
##############
# Alpha level determines transparency.  It's  a  linear  between  0  (completely
# tranclucent) and 255 (completely opaque)
ALPHA_LEVEL=180

# A base theme color for highlights, selections links, icons on the bar. Check
# http://chriskempson.com/projects/base16/ for further reference, here are some
# commonly used colors:
# 8  Red
# 9  Orange
# 10 Yellow
# 11 Green
# 12 Cyan
# 13 Blue
# 14 Magenta
THEME=13

# Computation {{{
declare -A base
declare -A map
alpha_hex=$(printf '%x' "$ALPHA_LEVEL")

map[0]=0
map[1]=18
map[2]=19
map[3]=8
map[4]=20
map[5]=7
map[6]=21
map[7]=15
map[8]=1
map[9]=16
map[10]=3
map[11]=2
map[12]=6
map[13]=4
map[14]=5
map[15]=17

function _html() {
    echo "#$2${1//\//}"
}

function _argb() {
    echo "argb:$2${1//\//}"
}

function _rgba() {
    echo "rgba:${1//\//00\/}00/${2}00"
}

while read -r line; do
  e=($line)
  base[$(printf "%d" "0x${e[3]}")]="${e[0]}/${e[1]}/${e[2]}"
done < <(sed -n 's%^.*\([0-fA-F]\{2\}\)/\([0-fA-F]\{2\}\)/\([0-fA-F]\{2\}\).*Base\ \([0-F]\{2\}\).*$%\1 \2 \3 \4%p' < "$HOME/.base16_theme" | sort -k4 | uniq)

# }}}

# Bash variables {{{
{
    for i in $(seq 0 15); do
        printf "export base%.2x_html=%s\n" "$i" "$(_html ${base[$i]})"
    done
    printf "export theme_html=%s\n" "$(_html ${base[$THEME]})"
    printf "export theme=%s\n" "${map[$THEME]}"
} > "$HOME/.theme.bashrc"
# }}}

# Xresources {{{
{
    for i in $(seq 0 15); do
        printf "base%.2x: %s\n" "$i" "$(_html ${base[$i]})"
        printf "#define base%.2x %s\n" "$i" "$(_html ${base[$i]})"
        printf "base%.2x_argb: %s\n" "$i" "$(_argb ${base[$i]} $alpha_hex)"
        printf "#define base%.2x_argb %s\n" "$i" "$(_argb ${base[$i]} $alpha_hex)"
        printf "base%.2x_ahtml: %s\n" "$i" "$(_html ${base[$i]} $alpha_hex)"
        printf "#define base%.2x_ahtml %s\n" "$i" "$(_html ${base[$i]} $alpha_hex)"
        printf "base%.2x_rgba: %s\n" "$i" "$(_rgba ${base[$i]} $alpha_hex)"
        printf "#define base%.2x_rgba %s\n" "$i" "$(_rgba ${base[$i]} $alpha_hex)"
    done
    printf "theme: %s\n" "$(_html ${base[$THEME]})"
    printf "#define theme %s\n" "$(_html ${base[$THEME]})"
} > "$HOME/.theme.defines.Xresources"
# }}}

# # Firefox {{{
# # Write userChrome.css
# cat > "$HOME"/.mozilla/firefox/*/chrome/userChrome.css <<EOF
# :root:-moz-lwtheme-brighttext {
#   --chrome-background-color: $(_html "${base[0]}")!important; /* base00 */
#   --chrome-color: $(_html "${base[5]}")!important; /* base06 */
#   --chrome-secondary-background-color: $(_html "${base[1]}")!important; /* base02 */
#   --url-and-searchbar-background-color: $(_html "${base[0]}")!important; /* base01 */
# }

# .tabbrowser-tab[visuallyselected="true"]:-moz-lwtheme {
#   color: $(_html "${base[07]}")!important;
# }
# EOF
# # }}}

# # GTK theme {{{
# cat > "$HOME/.themes/colors.rc" << EOF
# gtk-color-scheme = "bg_color:$(_html ${base[6]})"
# gtk-color-scheme = "fg_color:$(_html ${base[0]})"
# gtk-color-scheme = "base_color:$(_html ${base[7]})"
# gtk-color-scheme = "text_color:$(_html ${base[0]})"
# gtk-color-scheme = "selected_bg_color:$(_html ${base[$THEME]})"
# gtk-color-scheme = "selected_fg_color:$(_html ${base[1]})"
# gtk-color-scheme = "tooltip_bg_color:$(_html ${base[4]})"
# gtk-color-scheme = "tooltip_fg_color:$(_html ${base[1]})"
# gtk-color-scheme = "titlebar_bg_color:$(_html ${base[7]})"
# gtk-color-scheme = "titlebar_fg_color:$(_html ${base[0]})"
# gtk-color-scheme = "menubar_bg_color:$(_html ${base[0]})"
# gtk-color-scheme = "menubar_fg_color:$(_html ${base[5]})"
# gtk-color-scheme = "toolbar_bg_color:$(_html ${base[6]})"
# gtk-color-scheme = "toolbar_fg_color:$(_html ${base[0]})"
# gtk-color-scheme = "menu_bg_color:$(_html ${base[1]})"
# gtk-color-scheme = "menu_fg_color:$(_html ${base[5]})"
# gtk-color-scheme = "panel_bg_color:$(_html ${base[0]})"
# gtk-color-scheme = "panel_fg_color:$(_html ${base[5]})"
# gtk-color-scheme = "link_color:$(_html ${base[13]})"
# EOF
# # }}}

# Clean up {{{
unset printf_template
unset printf_template_var
# }}}

# Apply changes {{{
xrdb -load "$HOME/.Xresources"
# }}}

# vim: fdm=marker fdl=0 fen fdc=2
