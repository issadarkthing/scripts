#!/bin/bash

WIKI_PATH=~/.local/share/nvim/vimwiki/html

declare -A WIKIS

shopt -s globstar nullglob
for file in "$WIKI_PATH"/*.html; do

	WIKI_NAME=$(basename -s .html "$file")
	WIKIS[$WIKI_NAME]=$file

done

# shellcheck disable=SC2046
WIKI=$(basename -s .html $(find "$WIKI_PATH"/*.html) | dmenu -c)

[[ -z $WIKI ]] && exit 1

surf "${WIKIS[$WIKI]}"

