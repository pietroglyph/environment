#!/bin/bash
if [[ $(pacman -Qu) ]]; then
	echo "<span color='yellow' font='FontAwesome'></span> <span color='yellow'>Updates avaliable</span>"
fi
