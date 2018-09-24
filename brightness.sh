#!/bin/bash

BRIGHTNESS_CHANGE_MIN_DELAY=1 # In seconds
MIN_BRIGHTNESS=100
BRIGHTNESS_CHANGE_DIVISOR=5
BRIGHTNESS_TARGET_FILE=/sys/class/backlight/intel_backlight/brightness

curBrightness=$(cat $BRIGHTNESS_TARGET_FILE)
maxBrightness=$(($(cat /sys/class/backlight/intel_backlight/max_brightness)-$MIN_BRIGHTNESS))

function echoBrightnessPercent() {
  echo $(echo "$curBrightness $maxBrightness" | awk '{printf "%.0f", ($1/$2)*100}')%
}

if [ -e "$(dirname "$0")/lastRun" ];
then
  lastRun=`cat "$(dirname "$0")/lastRun"`
  now="$(date +%s)"
  if [[ $((now-lastRun)) < $BRIGHTNESS_CHANGE_MIN_DELAY ]]; then
    echoBrightnessPercent
    exit
  fi
fi

echo "$(date +%s)" > "$(dirname "$0")/lastRun"

argument=$1
case $BLOCK_BUTTON in
  4) argument="+" ;;
  5) argument="-" ;;
esac

if [[ $argument = "+" ]];
then
  let curBrightness+=maxBrightness/BRIGHTNESS_CHANGE_DIVISOR
elif [[ $argument = "-" ]];
then
  let curBrightness-=maxBrightness/BRIGHTNESS_CHANGE_DIVISOR
fi

curBrightness=$((curBrightness > maxBrightness ? maxBrightness : curBrightness))
curBrightness=$((curBrightness < 0 ? 0 : curBrightness))

# The brightness file must be chown'ed
echo $(($curBrightness+$MIN_BRIGHTNESS)) > $BRIGHTNESS_TARGET_FILE

echoBrightnessPercent
