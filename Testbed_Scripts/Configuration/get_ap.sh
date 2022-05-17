#!/bin/bash

# This script is meant to obtain the SSID's of the access points of each specified node 

dev=()
if [ -z "$@" ]
then

# This section is meant to run if the script is run without any command line arguments and will ask for user input that specify the range of nodes
echo "Naming convention is 10.1.1.x"
echo "Input each corresponding ip to be pinged"
echo "i.e., for devices 10.1.1.101 to 10.1.1.104, input 101 102 103 104"
read -a ip
echo ${ip[@]}
for i in "${ip[@]}"
do
	ssh pi@10.1.1.$i sudo iwconfig wlan0 | awk -F ':' '/ESSID:/ {print $2;}'
done

else

while [ "$#" -gt 0 ];
do
case "$1" in 
	# In order to obtain the SSID's of a large group of nodes, run this command with the flag -r and the maximum and minumum values of the node range. Ex: For nodes 101 
	# through 106, run "bash get_ap.sh -r 101 for 106"
	-r) var1="$2"; 
	var2="$3";
	i=$var1
	for (( i=$var1; i<=$var2; i++ ))
	do
	ssh pi@10.1.1.$i sudo iwconfig wlan0 | awk -F ':' '/ESSID:/ {print $2;}'
	done
	;;
	# In order to obtain the SSID's of an individual node, run this command with the flag -l and the the specific node value. Ex: For node 101, 
	# run "bash get_ap.sh -l 101"
	-l) new=( "$@" )
	echo ${new[@]}
	for (( i=1; i<=${#new[@]}-1; i++))
	do
	i2=$i+1
	ssh pi@10.1.1.${new[i]} sudo iwconfig wlan0 | awk -F ':' '/ESSID:/ {print $2;}'
	done
	;;
esac
break
done
fi

