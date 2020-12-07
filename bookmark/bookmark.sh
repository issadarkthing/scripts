#!/usr/bin/env bash

URL_PATH=~/Documents/scripts/bookmark/urls
BOOKMARK_HISTORY=~/Documents/scripts/bookmark/bookmark_history
ICON=/usr/share/icons/Paper/24x24/apps/accessories-ebook-reader.png

# open url using dmenu
if [[ -z $1 ]]; then

	URL=$(dmenu -i -l 10 -c < $URL_PATH)

	# return if no url
	if [[ -n "$URL" ]]; then
		echo "$URL" >> "$BOOKMARK_HISTORY"

		# open in student container for google classroom
		if [[ $URL == *"classroom"* ]]; then
			firefox-container -n Student "$URL"
		else
			firefox -new-tab "$URL"
		fi
	fi
	

# add bookmark
elif [[ $1 == "-a" ]]; then

	shift

	for URL in "$@"; do

		EXISTS=false
		# check if link exists
		grep "^$URL$" "$URL_PATH" && EXISTS=true

		[[ $EXISTS == true ]] && echo "$URL already added!"
		[[ $EXISTS == false ]] && echo "$URL" >> $URL_PATH && echo "$1 added!"
	done

# add bookmark using dmenu
elif [[ $1 == "-p" ]]; then

	URL=$(dmenu -F -l 1 -p "url" -c < $URL_PATH)

	EXISTS=false

	# check if link exists
	grep "^$URL$" "$URL_PATH" && EXISTS=true

	[[ $EXISTS = true ]] && notify-send -i "$ICON" "URL already exists" "Provided link will not be added"
	[[ -n $URL ]] && [[ $EXISTS == false ]] && echo "$URL" >> $URL_PATH && notify-send -i "$ICON" "URL added" "$URL"


elif [[ $1 == "-h" ]]; then

	cat <<- EOF
		Simple url launcher.
		usage: 
		    bookmark [-p|-a URL]

		options:
		    -p add bookmark using dmenu
		    -a add bookmark from command line
	EOF

fi
