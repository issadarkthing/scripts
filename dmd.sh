#!/bin/bash

# dmenu music downloader

DATA=~/.local/share/dmd

URL=$(cat $DATA/urls | dmenu -c -l 10 -F)

for x in `cat $DATA/urls`; do
	[ "$x" == "$URL" ] && notify-send "Download failed" "This video/audio has been downloaded before" && exit 1
done

if [ -n "$URL" ]; then

	notify-send -h string:x-canonical-private-synchronous:dmd \
		"Downloading audio" "$URL"

	youtube-dl -x --audio-format mp3 \
		-o "~/Music/%(artist)s - %(track)s.%(ext)s" $URL && notify-send \
		-h string:x-canonical-private-synchronous:dmd \
		"Download completed" "$URL"

	echo $URL >> $DATA/urls

fi

