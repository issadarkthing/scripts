#!/bin/bash

IMGPATH=/tmp/screenshot-$(date +%F_%T).png
SAVEPATH=~/Pictures/screenshots/screenshot-$(date +%F_%T).png

if [[ -z $1 ]]; then
    # unhides cursor after being hidden by unclutter
    xdotool mousemove_relative 1 0
	scrot -s -f "$IMGPATH" -e "xclip -selection c -t image/png -i $IMGPATH";
elif [[ $1 == "a" ]]; then
    xdotool mousemove_relative 1 0
	scrot "$SAVEPATH" -e "xclip -selection c -t image/png -i $IMGPATH"
else
	echo "Invalid argument"
fi


