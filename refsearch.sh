#!/usr/bin/env bash

LANG="$1"
if [[ "$1" == "cpp" ]]; then
	LANG_FRIENDLY="C++"
elif [[ "$1" == "c" ]]; then
	LANG_FRIENDLY="C"
else
	echo "Unrecognized language code"
	exit 1
fi
cd "/home/declan/Documents/cppreference/reference/en/$LANG/"

QUERY=$(echo "" | bemenu -p "Search $LANG_FRIENDLY Documentation")
if [[ "$QUERY" == "" ]]; then
	exit 0
fi

if [[ "$2" != "all" ]]; then
	#EXCLUDE_PRE="/"
	EXCLUDE_POST="!header/"
fi
FILENAME=$(fzf -f "$EXCLUDE_PRE$QUERY $EXCLUDE_POST" | head -1)

# Is running firefox directly noticeably faster?
xdg-open "$FILENAME"
