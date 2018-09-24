#!/bin/bash
dnf check-upgrade > /dev/null
if [ $? -eq 100 ]; then
	echo "<span color='yellow' font='FontAwesome'></span> <span color='yellow'>Updates avaliable</span>"
fi
