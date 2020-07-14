#!/bin/bash

type=$1 # +, -
icon=/usr/share/icons/Paper/24x24/status/stock_volume-max.png


changevolume() {

	MSG=$(amixer -D pulse sset Master 5%$1 \
		    | tail -n 1 \
			 | grep -o "[0-9]\+" \
			 | tail -n 1)
	PROGRESSBAR=$(getprogstr 20 "█" "░" "$MSG")
	VOLUME="Volume: $MSG% $PROGRESSBAR"
	notify-send "Master volume" "$VOLUME" \
	-i $icon -u low \
	-h string:x-canonical-private-synchronous:anything
	play -q /usr/share/sounds/Yaru/stereo/audio-volume-change.oga 2> /dev/null
}

if [[ $type = "+" || $type = "-" ]]; then
	changevolume $type
	polybar-msg hook volume-control 1
elif [[ $type = "mute" ]]; then
	# toggle mute
	msg=$(amixer -D pulse set Master 1+ toggle \
	| tail -n 1 \
	| cut -d" " -f8)
	volume="Volume: $msg";
	notify-send "Master volume" "$volume" \
	-i $icon -u low \
	-h string:x-canonical-private-synchronous:anything

	play -q /usr/share/sounds/Yaru/stereo/audio-volume-change.oga 2> /dev/null
else
	CURRENTVOLUME=$(amixer -D pulse sset Master 0%+ \
		    | tail -n 1 \
			 | grep -o "[0-9]\+" \
			 | tail -n 1)
	PROGRESSBAR=$(getprogstr \
		20 "-" "-" $CURRENTVOLUME "/")
	echo $CURRENTVOLUME $PROGRESSBAR
fi



