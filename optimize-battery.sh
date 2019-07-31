#!/usr/bin/env bash

sudo tlp start
echo 1 | sudo tee /sys/bus/pci/devices/0000\:01\:00.0/remove
sudo rfkill block bluetooth
