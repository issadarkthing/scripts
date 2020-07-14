#!/bin/bash

if [ -z "$(bspc query -N -n .focused.fullscreen -d focused)" ]; then
	bspc node focused.tiled -t fullscreen
	~/Documents/scripts/bsphide.sh
	polybar-msg cmd hide
else
	bspc node focused.fullscreen -t tiled
	~/Documents/scripts/bspunhide.sh
	polybar-msg cmd show
fi

