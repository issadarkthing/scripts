#!/bin/bash


if [ ! -f /tmp/autostart ]; then

	bspc rule -a Thunderbird --one-shot desktop="^5"
	thunderbird &
	echo thunderbird >> /tmp/autostart

	# setup for scratchpad terminal
	bspc rule -a Alacritty --one-shot sticky=on state=floating hidden=on
	alacritty --title quick-term &
	echo alacritty >> /tmp/autostart

	# conky
	# conky -d &> /tmp/conky.log
	# echo conky >> /tmp/autostart

	# skippy-xd
	# skippy-xd --start-daemon &
	# echo skippy-xd >> /tmp/autostart

	# handle unstable connection
	#~/Documents/scripts/reload.sh & 2>&1 /dev/null

	# create xob bar
	mkfifo /tmp/xobpipe
	tail -f /tmp/xobpipe | xob -t 4000 &

fi
