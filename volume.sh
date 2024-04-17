#!/bin/bash

TYPE=$1 # +, -


change_volume() {
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%$1
}

if [[ $TYPE = "+" || $TYPE = "-" ]]; then
	change_volume $TYPE
	polybar-msg hook volume-control 1
fi
