#!/bin/bash

# list of words
WORD_PATH=/usr/share/dict/english-words

# get user input
WORD=$(dmenu -l 10 -c < $WORD_PATH)

# remove extra quotes in string
remove_quote() {
	tmp="${1%\"}"
	echo "${tmp#\"}"
}

# gets initial char from word
INIT=${WORD:0:1}

DATA=/usr/share/dict/englist-dict/"$INIT".json

# extract json data
DEFS=$(jq ".$WORD.meanings[] | .def" "$DATA" 2>/dev/null)
EXAMPLES=$(jq ".$WORD.meanings[] | .examples" "$DATA" 2>/dev/null)

# convert to array
readarray -t DEFS <<< "$DEFS"
readarray -t EXAMPLES <<< "$EXAMPLES"

for (( i=0; i<="${#DEFS[@]}"; i++ )); do

	# filter empty values
	[[ -z "${DEFS[$i]}" ]] && continue

	DEF=$(remove_quote "${DEFS[$i]}")
	EXAMPLE=$(remove_quote "${EXAMPLES[$i]}")

	[[ $EXAMPLE == "null" ]] && EXAMPLE=""
	
	# this helps us to read the prompt,
	# the higher the word, the longer the timeout
	WORDLENGTH=$(echo "$DEF $EXAMPLE" | wc -w)

	[ $WORDLENGTH -le 5 ] && TIMEOUT=5000
	[ $WORDLENGTH -gt 5 ] && TIMEOUT=10000
	[ $WORDLENGTH -gt 10 ] && TIMEOUT=15000
	[ $WORDLENGTH -gt 20 ] && TIMEOUT=25000


	notify-send -t "$TIMEOUT" "$DEF" "$EXAMPLE"

done
