#!/bin/bash

PASSWD_LIST=$(find ~/.password-store -name "*.gpg" \
	| sed "s|/home/terra/.password-store/||; s/.gpg$//g")
ICON=/usr/share/icons/matefaenza/apps/24/cryptkeeper.png
PASSWD=$(echo "$PASSWD_LIST" | dmenu -l 10)


if [ -n "$PASSWD" ]; then

	PASS=$(gpg -d ~/.password-store/"$PASSWD".gpg)

	# if decryption succeeds
	if [ "$?" -eq 0 ]; then
		echo -n "$PASS" | xclip -sel clip
		notify-send -i "$ICON" "copied to clipboard" "clipboard will be cleared in 45 seconds"
		sleep 45
		echo " " | xclip -sel clip
		notify-send	-i "$ICON" "timed out" "clipboard cleared"
	fi
fi
