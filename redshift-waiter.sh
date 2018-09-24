#!/bin/bash

# Waits a while for an internet connection. If none is found, then it starts redshift with a predefined latitude and longitude.

export LATLONG="47.606209:-122.332069"
export WAIT

export isConnected=false
export redShifted=false

function fallback() {
  sleep 3
  if $isConnected; then return; fi
  redShifted=true
  redshift -l $LATLONG $@
}

fallback &

while ! $isConnected;
do
  for interface in $(ls /sys/class/net/ | grep -v lo);
  do
    if [[ $(cat /sys/class/net/$interface/carrier) = 1 ]]; then onLine=1; fi
  done
  if ! [[ $onLine ]]; then isConnected=true; fi
done

if $redShifted;
then
  r="-r"
  echo "Killing older redshift..."
  pkill redshift
fi

redshift $r $@
