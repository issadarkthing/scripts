#!/bin/bash

MON="eDP1"    # Discover monitor name with: xrandr | grep " connected"
STEP=5          # Step Up/Down brightnes by: 5 = ".05", 10 = ".10", etc.


CurrBright=$(xrandr --verbose --current | grep ^"$MON" -A5 | tail -n1)
CurrBright="${CurrBright##* }"  # Get brightness level with decimal place

Left=${CurrBright%%"."*}        # Extract left of decimal point
Right=${CurrBright#*"."}        # Extract right of decimal point

# trigger system notification when brightness changed
trigger() {

	local ROUNDED=$(python3 -c "print(int($1 * 100))")

	echo $ROUNDED > /tmp/xobpipe

	play -q /usr/share/sounds/Yaru/stereo/audio-volume-change.oga 2> /dev/null

}

getBrightness() {
	xrandr --verbose --current | grep ^"$MON" -A5 | tail -n1 | cut -d " " -f 2
}

initialBrightness=$(getBrightness)
ROUNDEDINITIALBRIGHTNESS=$(python3 -c "print(int($initialBrightness * 100))")

[[ $ROUNDEDINITIALBRIGHTNESS -ge 100 && $1 == "Up" ]] && exit 1

MathBright="0"
[[ "$Left" != 0 && "$STEP" -lt 10 ]] && STEP=10     # > 1.0, only .1 works
[[ "$Left" != 0 ]] && MathBright="$Left"00          # 1.0 becomes "100"
[[ "${#Right}" -eq 1 ]] && Right="$Right"0          # 0.5 becomes "50"
MathBright=$(( MathBright + Right ))

[[ "$1" == "Up" || "$1" == "+" ]] && MathBright=$(( MathBright + STEP ))
[[ "$1" == "Down" || "$1" == "-" ]] && MathBright=$(( MathBright - STEP ))
[[ "${MathBright:0:1}" == "-" ]] && MathBright=0    # Negative not allowed
[[ "$MathBright" -gt 100  ]] && MathBright=100      # Can't go over 9.99

if [[ "${#MathBright}" -eq 3 ]] ; then
    MathBright="$MathBright"000         # Pad with lots of zeros
    CurrBright="${MathBright:0:1}.${MathBright:1:2}"
else
    MathBright="$MathBright"000         # Pad with lots of zeros
    CurrBright=".${MathBright:0:2}"
fi

xrandr --output "$MON" --brightness "$CurrBright"   # Set new brightness

# Display current brightness
finalBrightness=$(getBrightness)
if (( $(echo "$initialBrightness != $finalBrightness" | bc -l) )); then
	trigger "$finalBrightness"

	# update polybar screen-brightness module
	polybar-msg hook screen-brightness 1
fi

ROUNDED=$(python3 -c "print(int($finalBrightness * 100))")
BRIGHT=$(~/Documents/scripts/getprogstr 20 "-" "-" "$ROUNDED" "/")
echo "$ROUNDED" "$BRIGHT"
