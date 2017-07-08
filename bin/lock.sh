#!/usr/bin/env bash

echo "locking screen..."
source "$HOME/.colors.kmarc"

B=$(_html $color00)99 # blank
C=$(_html $color04)99 # clear ish
D=$(_html $color05)99 # default
T=$(_html $color06)99 # text
W=$(_html $color07)99 # wrong
V=$(_html $color07)99 # verifying

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
