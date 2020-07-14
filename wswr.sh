#!/bin/bash


# toggle wswr
toggle() {
	# force to float 
	bspc rule -a Wswr --one-shot state=floating

	# check if wswr window exists
	IS_WSWR=$(bspc query -T -d focused | jq '.root | recurse(.firstChild, .secondChild) | if .client.className == "Wswr" then true else empty end')

	# toggle between spawning and killing
	[[ $IS_WSWR == "true" ]] && pkill wswr

	# show screenshots of workspaces
	WORKSPACE=$(wswr -to /tmp/wswr/*)
	LEN=$(wc -l <<< "$WORKSPACE")

	# check if no workspace selected
	# or selected workspace is more than one
	if [[ -z $WORKSPACE ]] || [[ $LEN -gt 1 ]]; then
		exit
	fi

	# switch to workspace
	bspc desktop -f "$(basename "$WORKSPACE" .png)"
}


# update ss of the workspace
update() {

	WORKSPACE=$(bspc query -D -d focused)

	# ensures the directory exists
	[[ ! -d /tmp/wswr ]] && mkdir /tmp/wswr


	# delete old ss
	[[ -f /tmp/wswr/"$WORKSPACE".png ]] && rm /tmp/wswr/"$WORKSPACE".png

	scrot "/tmp/wswr/$WORKSPACE.png"
}


take_ss() {
	# get workspace id from event
	WORKSPACE=$1	

	# get current workspace id
	CURR_WORKSPACE=$(bspc query -D -d .focused)


	# preventing from taking screenshot of wswr window
	IS_WSWR=$(bspc query -T -d focused | jq '.root | recurse(.firstChild, .secondChild) | if .client.className == "Wswr" then true else empty end')


	[[ $IS_WSWR == "true" ]] && pkill wswr

	# ensures the directory exists
	[[ ! -d /tmp/wswr ]] && mkdir /tmp/wswr

	# go to changed node workspace
	bspc desktop -f "$WORKSPACE"

	# delete old ss
	[[ -f /tmp/wswr/"$WORKSPACE".png ]] && rm /tmp/wswr/"$WORKSPACE".png

	# take ss of the current workspace
	scrot --delay 2 "/tmp/wswr/$WORKSPACE.png"

	# go to previous desktop
	bspc desktop -f "$CURR_WORKSPACE"
}

full_update() {

	# gets the id of occupied desktops
	local DESKTOPS
	DESKTOPS=$(bspc query -D -d .occupied)

	for desktop in $DESKTOPS; do 

		take_ss "$desktop"

	done
}

run() {

	bspc subscribe node all | while read -r line; do

		# gets event name
		EVENT=$(awk '{print $1}' <<< "$line")


		if  [[ $EVENT == 'node_add' ]] || [[ $EVENT == 'node_remove' ]] || 
			[[ $EVENT == 'node_swap' ]] || [[ $EVENT == 'node_transfer' ]] || 
			[[ $EVENT == 'node_focus' ]]; then


			# check the amount of node in current workspace
			COUNT=$(bspc query -N -n '.window.!hidden' -d focused | wc -l)

			# get workspace id
			WORKSPACE=$(awk '{print $3}' <<< "$line")

			# if there is no node in current workspace
			# delete screenshot from /tmp/wswr
			if [[ $COUNT -eq 0 ]]; then

				[[ -f /tmp/wswr/"$WORKSPACE".png ]] && rm /tmp/wswr/"$WORKSPACE".png
				continue

			fi

			take_ss "$WORKSPACE"

		fi

	done 

}

usage() {
 echo "usage: wswr [-t|-u|-r|-h]"
 echo "-t toggle wswr window"
 echo "-u force update current window"
 echo "-r listen to bspc subscribe event (this is a blocking process)"
 echo "-h print help message"
}


while getopts "turUh" opts; do

	case "${opts}" in
		t) toggle;;
		u) update;;
		r) run;;
		U) full_update;;
		h | *) usage;;
	esac

done
