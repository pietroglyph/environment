#!/usr/bin/env bash

WORD=$(cat $(dirname $(readlink -f $0))/google-10000-english-usa.txt | dmenu -p "Choose a word")
if [[ $WORD == "" ]]; then
	exit 1
fi
thesauromatic $WORD | dmenu -p "Synonyms"
