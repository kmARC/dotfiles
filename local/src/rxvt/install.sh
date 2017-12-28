#!/usr/bin/env bash

apt-get -y source rxvt-unicode-256color

cd rxvt-unicode-9.22/

# cp ../sgr-mouse-mode.diff debian/patches/16_sgr_mouse_mode.diff
# echo "16_sgr_mouse_mode.diff" >> debian/patches/series
# patch -d src/ < debian/patches/16_sgr_mouse_mode.diff
patch -d src/ < ../sgr-mouse-mode.diff

debuild -b -uc -us

cd ..

sudo dpkg -i rxvt-unicode-256color_*
