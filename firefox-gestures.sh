#!/usr/bin/env bash

if [[ $(xdotool search --onlyvisible --class "firefox") != $(xdotool getwindowfocus) ]]; then
	echo "Error: run this command while Firefox is focused" 1>&2
	exit 1
fi

if [[ $1 == "tab" ]]; then
	if [[ $2 == "left" ]]; then
		xdotool key Ctrl+Page_Up
	elif [[ $2 == "right" ]]; then
		xdotool key ctrl+Page_Down
	else
		echo "Error: tab takes one argument [left, right]" 1>&2
	fi
else
	echo "Error: this command requires at least one argument for the gesture type" 1&>2
fi
