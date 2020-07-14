#!/bin/bash


# simple bspwm script to hide polybar if there is
# window in fullscreen and show if there is none


# checks if there is fullscreen window
bspc query -N -n .fullscreen -d focused

# checks last command if successfull
if [ $? -eq 0 ]; then
	polybar-msg cmd hide
else
	polybar-msg cmd show
fi
