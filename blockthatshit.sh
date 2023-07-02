#!/usr/bin/env bash

source BLOCKED_SITES
add_wikiepdia() {
	BLOCKED_SITES+=("wikipedia.org" "en.wikipedia.org" "en.m.wikipedia.org")
}
if [[ "$1" != "--allow-wikipedia" && "$1" != "-w" ]]; then
	add_wikiepdia
else
	CONFIRM_STRING="I understand the risks"
	read -er -i 'I do not want to enable access to Wikipedia' -p "Please confirm that you would like to enable access to Wikipedia, in spite of its significant procrastination potential (type \"$CONFIRM_STRING\" to confirm): "
	if [[ "$REPLY" != "$CONFIRM_STRING" ]]; then add_wikiepdia; fi
fi

for SITE in "${BLOCKED_SITES[@]}"
do
	iptables -A OUTPUT -p tcp -m string --string "$SITE" --algo kmp -j REJECT
done
