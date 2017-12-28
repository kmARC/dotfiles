#!/usr/bin/env bash

echo "locking screen..."
source "$HOME/.theme.bashrc"

B=${theme_html_color0}ee # blank
C=${theme_html_color0}99 # clear ish
D=${theme_html_color4}99 # default
T=${theme_html_color4}99 # text
W=${theme_html_color1}99 # wrong
V=${theme_html_color3}99 # verifying

xset dpms 5 5 5

(sleep 1; xset dpms force off) &

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
-B=12341234 \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%Y-%m-%d, %A" \
\
--nofork

xset dpms 300 300 300

# --veriftext="Drinking verification can..."
# --wrongtext="Nope!"
# --textsize=20
# --modsize=10
# --timefont=comic-sans
# --datefont=monofur
# etc
