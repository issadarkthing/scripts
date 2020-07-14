!/bin/bash


# this script hides polybar if fullscreen
# shows polybar if not
# triggered when switching workspace

FOCUSED=$(xprop -root _NET_ACTIVE_WINDOW | awk -F' ' '{print $NF}')


#check if current focused window is fullscreen
if xprop -id ${FOCUSED} _NET_WM_STATE | grep -q _NET_WM_STATE_FULLSCREEN; then
	polybar-msg cmd hide
else
	polybar-msg cmd show
fi
