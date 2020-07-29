#!/bin/bash


if [ ! -f /tmp/autostart ]; then
	bspc rule -a discord desktop="^4"
	discord & 2>&1 /dev/null
	echo discord >> /tmp/autostart

	bspc rule -a Firefox --one-shot desktop="^1"
	firefox &
	echo firefox >> /tmp/autostart

	bspc rule -a Thunderbird --one-shot desktop="^5"
	thunderbird &
	echo thunderbird >> /tmp/autostart

	# setup for scratchpad terminal
	bspc rule -a Alacritty --one-shot sticky=on state=floating hidden=on
	alacritty --class Alacritty &
	echo alacritty >> /tmp/autostart

	# conky
	conky -d &> /tmp/conky.log
	echo conky >> /tmp/autostart

	# skippy-xd
	skippy-xd --start-daemon &
	echo skippy-xd >> /tmp/autostart

	# handle unstable connection
	#~/Documents/scripts/reload.sh & 2>&1 /dev/null

fi
