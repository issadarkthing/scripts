#!/bin/bash

currDate=`date +"%D-%R"`
cd ~/.config && git add . && git commit -m $currDate && git push origin master
