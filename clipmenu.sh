#!/bin/bash


while clipnotify; do

	COPIEDTEXT=$(xsel -b)
	if [[ ! -d $HOME/.local/share/clipmenu ]]; then
		mkdir -p "$HOME"/.local/share/clipmenu
	fi

done
