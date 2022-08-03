#!/bin/bash

#################################################################### 
# get_mac.sh
#
# Author: Victoria Planchart
#
# Description: This script indicates the eth0, eth1 or wlan0 MAC address of the given node's IP addresses.
#
# Input: bash get_mac.sh -n (either eth0, eth1 or wlan0) -a (for specific nodes) or -r (for node's range)
# Example: for range from 101 to 115 type -r 101 115
#	   for specific nodes type -a, enter, 101 104 107 112 115
#	   for a specific network interface parameter, enter "-n" followed by either eth0, eth1 or wlan0. e.g: bash get_mac.sh -n eth1
#
####################################################################

help()
{
	echo "	-n = input the network interface (eth1, eth0 or wlan0)"
	echo "	-r = input the maximum and minimum values of the node range. Ex: For nodes 101 through 106, type -r 101 106"
	echo "	-a = type in -a with no inputs, enter, and then enter specific RPis (101 103 105 108)"
	echo "	-u [OPTIONAL] = input client's username if the deffault one (ucanlab) is not used"
}

# creates array from command line
no_range()
{
	read -a ip
}

# creates array from $var1 to $var2
range()
{
	for (( i=$var1; i<=$var2; i++ ))
	do
		ip[$i]=$i
	done
}

var1="$4"; 
var2="$5";
i=$var1

uname=ucanlab # deffault

while getopts 'hn:ur:a' OPTION; do
	case "$OPTION" in
		h)
			help;;
		n)
			network_interface=$OPTARG;;
		r)
			range;;
		a)
			no_range;;
		u)
			uname=$OPTARG;;
	esac
done

i=0
for i in "${ip[@]}"
do
# if statement checks which pi is in server mode by looking for eth1 address
if ssh ucanlab@"10.1.1.$i" [ ! -d /sys/class/net/$network_interface ]
then
	echo "Network Interface not found for $i"
else
	echo "$network_interface MAC Address for $i:"
	ssh $uname@"10.1.1.$i" cat /sys/class/net/$network_interface/address
fi
i=$((i + 1))
done
