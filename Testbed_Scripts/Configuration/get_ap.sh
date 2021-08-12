#!/bin/bash

var={$1..$2}
for ip in $(seq $1 $2); do 
	echo 10.1.1.$ip
	ssh pi@10.1.1.$ip sudo iwconfig wlan0 | awk -F ':' '/ESSID:/ {print $2;}'
done
exit

