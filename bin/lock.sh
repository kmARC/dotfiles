#!/usr/bin/env bash

echo "locking screen..."
source "$HOME/.theme.bashrc"

B=${theme_html_color0}99 # blank
C=${theme_html_color0}99 # clear ish
D=${theme_html_color12}99 # default
T=${theme_html_color12}99 # text
W=${theme_html_color9}99 # wrong
V=${theme_html_color3}99 # verifying

i3lock                \
--insidevercolor=$C   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--textcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--keyhlcolor=$W       \
--bshlcolor=$W        \
\
--screen 0            \
--blur 8              \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%A, %m %Y" \

# --veriftext="Drinking verification can..."
# --wrongtext="Nope!"
# --textsize=20
# --modsize=10
# --timefont=comic-sans
# --datefont=monofur
# etc
