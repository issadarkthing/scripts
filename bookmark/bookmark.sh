#!/bin/bash

URL_PATH=~/Documents/scripts/bookmark/urls
BOOKMARK_HISTORY=~/Documents/scripts/bookmark/bookmark_history
ICON=/usr/share/icons/Paper/24x24/apps/accessories-ebook-reader.png

# open url using dmenu
if [ -z "$1" ]; then

	URL=$(dmenu -l 10 -c < $URL_PATH)
	[ -n "$URL" ] && echo "$URL" >> "$BOOKMARK_HISTORY" && firefox -new-tab "$URL"

# add bookmark
elif [ "$1" == "-a" ]; then

	shift

	for url in "$@"; do
		EXISTS=false

		# check if link exists
		while read -r link; do
			[ "$link" = "$url" ] && EXISTS=true
		done < $URL_PATH

		[ "$EXISTS" = true ] && echo "$url already added!"
		[ "$EXISTS" = false ] && echo "$url" >> $URL_PATH && echo "$1 added!"
	done

# add bookmark using dmenu
elif [ "$1" == "-p" ]; then

	URL=$(dmenu -F -l 1 -p "url" -c < $URL_PATH)

	EXISTS=false

	# check if link exists
	while read -r link; do
		[ "$link" = "$URL" ] && EXISTS=true
	done < $URL_PATH

	[ "$EXISTS" = true ] && notify-send -i "$ICON" "URL already exists" "Provided link will not be added"
	[ -n "$URL" ] && [ "$EXISTS" = false ] && echo "$URL" >> $URL_PATH && notify-send -i "$ICON" "URL added" "$URL"


else

	echo -e "-a to add bookmark\
		\nno argument for dmenu"

fi
