#!/bin/bash

# my wifi sucks so i had to reload whenever its disconnected

while [ 1 ]; do
	ping -c3 google.com

	if [ $? -ne 0 ]; then
		nmcli radio wifi off
		nmcli radio wifi on
		sleep 30
	fi
done
