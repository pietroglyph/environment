#!/usr/bin/env bash

function killDiscord() {
	while :; do killall Discord; sleep 5; done
}

function timeboxedAuditoryWarning() {
	while :
	do
		SCRIPT_DIR="$(dirname $(readlink -f $0))"
		NUM=$(shuf -i 0-99 -n 1)
		if (( NUM < 3 )); then
		        aplay "$SCRIPT_DIR/timeboxed_warning.wav"
		elif (( NUM > 95 )); then
			notify-send "Are you on task? $(($SECONDS / 60)) minutes have elapsed since anti-procrastination script startup."
		fi

		sleep 30
	done
}

killDiscord &
timeboxedAuditoryWarning &
