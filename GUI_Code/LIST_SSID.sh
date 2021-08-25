#!/bin/bash

# Clears essid.txt file
> essid.txt

# This script is meant to list out all known ESSID in the vicinity but excludes any that
# starts with  \x00 and save into a file called essid.txt
sudo iwlist wlan0 scan |grep -v -e "\x00"| awk -F ':' '/ESSID:/ {print $2;}'  >> essid.txt
cat essid.txt
