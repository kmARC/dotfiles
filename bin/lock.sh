#!/usr/bin/env bash

echo "locking screen..."
source "$HOME/.theme.bashrc"

B=${base00_html}ee # blank
C=${base00_html}99 # clear ish
D=${base04_html}99 # default
T=${base04_html}99 # text
W=${base08_html}99 # wrong
V=${base0a_html}99 # verifying

if [ "$1" == "nosuspend" ]; then
    NOFORK="--nofork"
    xset dpms 5 5 5
    (sleep 1; xset dpms force off) &
fi

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
--verifcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--keyhlcolor=$W       \
--bshlcolor=$W        \
\
--blur=0.2 \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%Y-%m-%d, %A" \
\
"$NOFORK"


if [ "$1" == "nosuspend" ]; then
    xset dpms 300 300 300
fi

# --veriftext="Drinking verification can..."
# --wrongtext="Nope!"
# --textsize=20
# --modsize=10
# --timefont=comic-sans
# --datefont=monofur
# etc
