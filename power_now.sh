#!/usr/bin/env bash

units "$(cat /sys/class/power_supply/BAT0/current_now) uA * $(cat /sys/class/power_supply/BAT0/voltage_now) uV" W --compact -1
