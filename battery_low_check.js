#!/usr/bin/env node 
const { exec } = require('child_process');

let hasBeenWarned = false;
const BATTERY_THRESHOLD = 20;

setInterval(() => {
	 exec("upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep --color=never -E \"state|to\ full|to\ empty|percentage\"", (err, stdout, stderr) => {
	 if(err) return console.error(err);
	 if(stderr) console.log(stderr);
	 //trims out other info to only take battery percentage
	 const percentage = /\d+%/.exec(stdout)[0].trim();
	 //converts to number
	 const percentInNumber = parseInt(/\d+/.exec(percentage)[0]);

	 if(percentInNumber <= BATTERY_THRESHOLD && !hasBeenWarned) {
			exec('notify-send -u critical "Battery Low Warning" "Battery low! Please plug-in to your charger"', () => {});
			hasBeenWarned = true;
	 } else if (percentInNumber > BATTERY_THRESHOLD && hasBeenWarned) {
			hasBeenWarned = false;
	 }

	})
}, 10 * 1000); //check every 30 second
