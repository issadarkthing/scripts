#!/bin/bash

IMGPATH=/tmp/screenshot-$(date +%F_%T).png
SAVEPATH=~/Pictures/screenshots/screenshot-$(date +%F_%T).png

if [[ -z $1 ]]; then
	scrot -sf "$IMGPATH" -e "xclip -selection c -t image/png -i $IMGPATH";
	notify-send -i "$IMGPATH" -u low "System" "Selective screenshot taken"
elif [[ $1 == "a" ]]; then
	scrot "$SAVEPATH" -e "xclip -selection c -t image/png -i $IMGPATH"
	notify-send -i "$SAVEPATH" -u low "System" "Fullscreen screenshot taken"
else
	echo "Invalid argument"
fi


