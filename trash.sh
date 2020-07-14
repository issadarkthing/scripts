#!/bin/bash


# moves file to trash folder instead
trash() {

	# removes permanently
	if [ $1 = "-p" ]; then
		shift
		for item in "$@"; do
			[ -d $item ] && rm -rf $item
			[ -f $item ] && rm $item
		done
	else
		for item in "$@"; do
			touch $item
			mv $item ~/.local/share/Trash/files
		done
	fi
}

# moves latest item to current dir
untrash() {
	local DELETED_FILE=$(ls -Alt ~/.local/share/Trash/files | sed -n '2p' | tr -s ' ' | cut -d' ' -f9)
	mv  ~/.local/share/Trash/files/$DELETED_FILE "$(pwd)"
}


