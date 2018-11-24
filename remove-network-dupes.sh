#!/bin/bash

nmcli con | gawk '
match($0, /(^.* [0-9])( .*)/, capture) {
    system("nmcli con delete \""capture[1]"\"")
}
'
