#!/usr/bin/env bash

declare -A theme_shell
declare -A theme_xdefaults

while read -r line; do
  entry=( $line )
  key=${entry[0]}
  val=${entry[1]}
  echo "key: $key val: $val"
  theme_shell[$key]=$val
  if [[ ${val:0:1} == '$' ]]; then
    theme_xdefaults[$key]=${theme_xdefaults[${val:1}]}
  else
    theme_xdefaults[$key]="#${val:0:2}${val:3:2}${val:6:2}"
  fi
done < <(sed 's/=/ /' "$HOME/.base16_theme" | awk '/^color/{ print $1, $2 }' | sed 's/\"//g')

function _html() {
    echo "#${1//\//}"
}

{
    echo export theme_color0=${theme_shell[color00]}
    echo export theme_color1=${theme_shell[color01]}
    echo export theme_color2=${theme_shell[color02]}
    echo export theme_color3=${theme_shell[color03]}
    echo export theme_color4=${theme_shell[color04]}
    echo export theme_color5=${theme_shell[color05]}
    echo export theme_color6=${theme_shell[color06]}
    echo export theme_color7=${theme_shell[color07]}
    echo export theme_color8=${theme_shell[color08]}
    echo export theme_color9=${theme_shell[color09]}
    echo export theme_color10=${theme_shell[color10]}
    echo export theme_color11=${theme_shell[color11]}
    echo export theme_color12=${theme_shell[color12]}
    echo export theme_color13=${theme_shell[color13]}
    echo export theme_color14=${theme_shell[color14]}
    echo export theme_color15=${theme_shell[color15]}
    echo export theme_foreground=${theme_shell[color_foreground]}
    echo export theme_background=${theme_shell[color_background]}
    # echo "#define theme_foreground_alt $(_html "$color_foreground_alt")"

    echo export theme_html_color0="$(_html "${theme_shell[color00]}")"
    echo export theme_html_color1="$(_html "${theme_shell[color01]}")"
    echo export theme_html_color2="$(_html "${theme_shell[color02]}")"
    echo export theme_html_color3="$(_html "${theme_shell[color03]}")"
    echo export theme_html_color4="$(_html "${theme_shell[color04]}")"
    echo export theme_html_color5="$(_html "${theme_shell[color05]}")"
    echo export theme_html_color6="$(_html "${theme_shell[color06]}")"
    echo export theme_html_color7="$(_html "${theme_shell[color07]}")"
    echo export theme_html_color8="$(_html "${theme_shell[color08]}")"
    echo export theme_html_color9="$(_html "${theme_shell[color09]}")"
    echo export theme_html_color10="$(_html "${theme_shell[color10]}")"
    echo export theme_html_color11="$(_html "${theme_shell[color11]}")"
    echo export theme_html_color12="$(_html "${theme_shell[color12]}")"
    echo export theme_html_color13="$(_html "${theme_shell[color13]}")"
    echo export theme_html_color14="$(_html "${theme_shell[color14]}")"
    echo export theme_html_color15="$(_html "${theme_shell[color15]}")"
    echo export theme_html_foreground="$(_html "${theme_shell[color_foreground]}")"
    echo export theme_html_background="$(_html "${theme_shell[color_background]}")"
    # echo "#define theme_foreground_alt "$("_html ""$color_foreground_alt")""
} > "$HOME/.theme.bashrc"

# Write X resource defines
{
    echo "theme_color0:     ${theme_xdefaults[color00]}"
    echo "theme_color1:     ${theme_xdefaults[color01]}"
    echo "theme_color2:     ${theme_xdefaults[color02]}"
    echo "theme_color3:     ${theme_xdefaults[color03]}"
    echo "theme_color4:     ${theme_xdefaults[color04]}"
    echo "theme_color5:     ${theme_xdefaults[color05]}"
    echo "theme_color6:     ${theme_xdefaults[color06]}"
    echo "theme_color7:     ${theme_xdefaults[color07]}"
    echo "theme_color8:     ${theme_xdefaults[color08]}"
    echo "theme_color9:     ${theme_xdefaults[color09]}"
    echo "theme_color10:    ${theme_xdefaults[color10]}"
    echo "theme_color11:    ${theme_xdefaults[color11]}"
    echo "theme_color12:    ${theme_xdefaults[color12]}"
    echo "theme_color13:    ${theme_xdefaults[color13]}"
    echo "theme_color14:    ${theme_xdefaults[color14]}"
    echo "theme_color15:    ${theme_xdefaults[color15]}"
    echo "theme_foreground: ${theme_xdefaults[color_foreground]}"
    echo "theme_background: ${theme_xdefaults[color_background]}"
    # echo "#define theme_foreground_alt $(_html "$color_foreground_alt")"

    echo "#define theme_color0     ${theme_xdefaults[color00]}"
    echo "#define theme_color1     ${theme_xdefaults[color01]}"
    echo "#define theme_color2     ${theme_xdefaults[color02]}"
    echo "#define theme_color3     ${theme_xdefaults[color03]}"
    echo "#define theme_color4     ${theme_xdefaults[color04]}"
    echo "#define theme_color5     ${theme_xdefaults[color05]}"
    echo "#define theme_color6     ${theme_xdefaults[color06]}"
    echo "#define theme_color7     ${theme_xdefaults[color07]}"
    echo "#define theme_color8     ${theme_xdefaults[color08]}"
    echo "#define theme_color9     ${theme_xdefaults[color09]}"
    echo "#define theme_color10    ${theme_xdefaults[color10]}"
    echo "#define theme_color11    ${theme_xdefaults[color11]}"
    echo "#define theme_color12    ${theme_xdefaults[color12]}"
    echo "#define theme_color13    ${theme_xdefaults[color13]}"
    echo "#define theme_color14    ${theme_xdefaults[color14]}"
    echo "#define theme_color15    ${theme_xdefaults[color15]}"
    echo "#define theme_foreground ${theme_xdefaults[color_foreground]}"
    echo "#define theme_background ${theme_xdefaults[color_background]}"
    # echo "#define theme_foreground_alt $(_html "$color_foreground_alt")"

} > "$HOME/.theme.defines.Xresources"

xrdb -load "$HOME/.Xresources"

# Stalonetray
source "$HOME/.theme.bashrc"
sed -i "s/^tint_color.*$/tint_color \"${theme_html_color0}\"/" "$HOME/.stalonetrayrc"

# clean up
unset printf_template
unset printf_template_var

