#!/bin/bash

# This program takes a command as a string argument, and while
# that command is running, the firewall zone is set to FedoraServer

interface="wlp2s0"

# setZone takes 1 parameter: zone name (e.g. "FedoraServer")
function setZone() {
  sudo firewall-cmd --zone=$1 --change-interface=$interface
  printf "Setting %s to zone %s\n" $interface $1
}

originalZone=`sudo firewall-cmd --get-zone-of-interface=$interface`

printf "Original zone of %s detected for interface %s\n" $originalZone $interface

setZone "trusted"
trap 'setZone '"$originalZone" EXIT
eval $@
