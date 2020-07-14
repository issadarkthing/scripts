#!/bin/bash

PASSWD_LIST=$(find ~/.password-store -name "*.gpg" | sed "s|/home/terra/.password-store/||" | rev | cut -f 2- -d '.' | rev)
ICON=/usr/share/icons/Paper/24x24/apps/keepassx2.png
PASSWD=$(echo "$PASSWD_LIST" | dmenu -c -l 10)


if [ -n "$PASSWD" ]; then

	PASS=$(gpg -d ~/.password-store/"$PASSWD".gpg)

	#if decryption succeeds
	if [ "$?" -eq 0 ]; then
		echo "$PASS" | xclip -sel clip
		notify-send -i "$ICON" "copied to clipboard" "clipboard will be cleared in 45 seconds"
		sleep 45
		echo " " | xclip -sel clip
		notify-send	-i "$ICON" "timed out" "clipboard cleared"
	fi

fi
