#!/bin/bash

# Simple script to unhide all he nodes on a desktop

NODES=$(bspc query -N -n .hidden -d focused)
QUICKTERM=$(xdotool search --name quick-term)

# Show bar if it's running
if pgrep "polybar"; then
  polybar-msg cmd show
fi

# unhide other windows
for node in $NODES; do
	bspc node $node -g hidden=off
done

# hide sticky terminal back
bspc node "$QUICKTERM" -g hidden=on

