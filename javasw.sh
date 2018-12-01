#!/bin/bash

sudo update-alternatives --config java
sudo update-alternatives --config javac
#export DEFAULT_JAVA_HOME="$(readlink -f /etc/alternatives/jvm)"
#printf "Enter the JAVA_HOME path (%s): " $DEFAULT_JAVA_HOME
#read -i=$DEFAULT_JAVA_HOME JAVA_HOME
#echo $JAVA_HOME
