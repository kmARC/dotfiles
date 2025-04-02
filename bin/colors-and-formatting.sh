#!/usr/bin/env bash

# This porgram is free software.  It comes without any warranty, to 
# the extent permitted by applicable law.  You can redistribute it 
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar.  See
# http://sam.zoy.org/wtfp1/COPYING for more details.

#Backgournd
for clbg in {40..47} {100..107} 49; do
    #Foreground
    for clfg in {30..37} {90..97} 39; do
        # Formatting
        for attr in 0 1 2 3 4 5 7; do
            #Print the result
            printf "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
        done
        echo #New line
    done
done

echo -e '\e[1mBold\e[22m'
echo -e '\e[2mDimmed\e[22m'
echo -e '\e[3mItalic\e[23m'
echo -e '\e[4mUnderlined\e[24m'
echo -e '\e[4:3mCurly Underlined\e[4:0m'
echo -e '\e[4:3m\e[58;2;240;143;104mColored Curly Underlined\e[59m\e[4:0m'

exit 0
