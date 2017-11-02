#!/usr/bin/env bash

declare -A theme_shell
declare -A theme_xdefaults

cat "${1:-/dev/stdin}" > "$HOME/.theme.Xresources"

while read -r line; do
  entry=( $line )
  key=${entry[0]}
  val=${entry[1]}
  theme_shell[$key]=${val:1:2}/${val:3:2}/${val:5:2}
  theme_xdefaults[$key]=$val
done < <(sort "${1:-/dev/stdin}" | awk -F '*.' '/*./{ print $2 }' | sed 's/:\s*/ /')

function _html() {
    echo "#${1//\//}"
}

{
    echo export theme_color0=${theme_shell[color0]}
    echo export theme_color1=${theme_shell[color1]}
    echo export theme_color2=${theme_shell[color2]}
    echo export theme_color3=${theme_shell[color3]}
    echo export theme_color4=${theme_shell[color4]}
    echo export theme_color5=${theme_shell[color5]}
    echo export theme_color6=${theme_shell[color6]}
    echo export theme_color7=${theme_shell[color7]}
    echo export theme_color8=${theme_shell[color8]}
    echo export theme_color9=${theme_shell[color9]}
    echo export theme_color10=${theme_shell[color10]}
    echo export theme_color11=${theme_shell[color11]}
    echo export theme_color12=${theme_shell[color12]}
    echo export theme_color13=${theme_shell[color13]}
    echo export theme_color14=${theme_shell[color14]}
    echo export theme_color15=${theme_shell[color15]}
    echo export theme_foreground=${theme_shell[foreground]}
    echo export theme_background=${theme_shell[background]}
    # echo "#define theme_foreground_alt $(_html "$color_foreground_alt")"

    echo export theme_html_color0="$(_html "${theme_shell[color0]}")"
    echo export theme_html_color1="$(_html "${theme_shell[color1]}")"
    echo export theme_html_color2="$(_html "${theme_shell[color2]}")"
    echo export theme_html_color3="$(_html "${theme_shell[color3]}")"
    echo export theme_html_color4="$(_html "${theme_shell[color4]}")"
    echo export theme_html_color5="$(_html "${theme_shell[color5]}")"
    echo export theme_html_color6="$(_html "${theme_shell[color6]}")"
    echo export theme_html_color7="$(_html "${theme_shell[color7]}")"
    echo export theme_html_color8="$(_html "${theme_shell[color8]}")"
    echo export theme_html_color9="$(_html "${theme_shell[color9]}")"
    echo export theme_html_color10="$(_html "${theme_shell[color10]}")"
    echo export theme_html_color11="$(_html "${theme_shell[color11]}")"
    echo export theme_html_color12="$(_html "${theme_shell[color12]}")"
    echo export theme_html_color13="$(_html "${theme_shell[color13]}")"
    echo export theme_html_color14="$(_html "${theme_shell[color14]}")"
    echo export theme_html_color15="$(_html "${theme_shell[color15]}")"
    echo export theme_html_foreground="$(_html "${theme_shell[foreground]}")"
    echo export theme_html_background="$(_html "${theme_shell[background]}")"
    # echo "#define theme_foreground_alt "$("_html ""$color_foreground_alt")""
} > "$HOME/.theme.bashrc"

# Write X resource defines
{
    echo "theme_color0:     ${theme_xdefaults[color0]}"
    echo "theme_color1:     ${theme_xdefaults[color1]}"
    echo "theme_color2:     ${theme_xdefaults[color2]}"
    echo "theme_color3:     ${theme_xdefaults[color3]}"
    echo "theme_color4:     ${theme_xdefaults[color4]}"
    echo "theme_color5:     ${theme_xdefaults[color5]}"
    echo "theme_color6:     ${theme_xdefaults[color6]}"
    echo "theme_color7:     ${theme_xdefaults[color7]}"
    echo "theme_color8:     ${theme_xdefaults[color8]}"
    echo "theme_color9:     ${theme_xdefaults[color9]}"
    echo "theme_color10:    ${theme_xdefaults[color10]}"
    echo "theme_color11:    ${theme_xdefaults[color11]}"
    echo "theme_color12:    ${theme_xdefaults[color12]}"
    echo "theme_color13:    ${theme_xdefaults[color13]}"
    echo "theme_color14:    ${theme_xdefaults[color14]}"
    echo "theme_color15:    ${theme_xdefaults[color15]}"
    echo "theme_foreground: ${theme_xdefaults[foreground]}"
    echo "theme_background: ${theme_xdefaults[background]}"
    # echo "#define theme_foreground_alt $(_html "$color_foreground_alt")"

    echo "#define theme_color0     ${theme_xdefaults[color0]}"
    echo "#define theme_color1     ${theme_xdefaults[color1]}"
    echo "#define theme_color2     ${theme_xdefaults[color2]}"
    echo "#define theme_color3     ${theme_xdefaults[color3]}"
    echo "#define theme_color4     ${theme_xdefaults[color4]}"
    echo "#define theme_color5     ${theme_xdefaults[color5]}"
    echo "#define theme_color6     ${theme_xdefaults[color6]}"
    echo "#define theme_color7     ${theme_xdefaults[color7]}"
    echo "#define theme_color8     ${theme_xdefaults[color8]}"
    echo "#define theme_color9     ${theme_xdefaults[color9]}"
    echo "#define theme_color10    ${theme_xdefaults[color10]}"
    echo "#define theme_color11    ${theme_xdefaults[color11]}"
    echo "#define theme_color12    ${theme_xdefaults[color12]}"
    echo "#define theme_color13    ${theme_xdefaults[color13]}"
    echo "#define theme_color14    ${theme_xdefaults[color14]}"
    echo "#define theme_color15    ${theme_xdefaults[color15]}"
    echo "#define theme_foreground ${theme_xdefaults[foreground]}"
    echo "#define theme_background ${theme_xdefaults[background]}"
    # echo "#define theme_foreground_alt $(_html "$color_foreground_alt")"

} > "$HOME/.theme.defines.Xresources"

xrdb -load "$HOME/.Xresources"

# clean up
unset printf_template
unset printf_template_var

