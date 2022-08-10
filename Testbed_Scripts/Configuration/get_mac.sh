#!/bin/bash

#################################################################### 
# get_mac.sh
#
# Author: Victoria Planchart
#
# Description: This script indicates the eth0, eth1 or wlan0 MAC address of the given node's IP addresses.
#
# Input: bash get_mac.sh -n (either eth0, eth1 or wlan0) -l (for specific nodes) or -r (for node's range)
# Example: for range from 101 to 115 type -r 101,115
#	   for specific nodes type -l 101,104,107,112,115
#	   for a specific network interface parameter, enter "-n" followed by either eth0, eth1 or wlan0. e.g: bash get_mac.sh -n eth1
#
####################################################################

#-------------------------------------------------------------------

help()
{
	echo "	### Bash script to get eth1, eth0 or wlan0 MAC addresses for testbed nodes ###"
	echo "	---------------------------------------------------------------------------------------"
	echo "	-n = input the network interface eth1, eth0 or wlan0 (e.g., bash get_mac.sh -n eth0)"
	echo "	-r = range of testbed node addresses (e.g., bash get_mac.sh -r 103,107)"
	echo "	-l = list of testbed node addresses (e.g., bash get_mac.sh -l 103,105,109)"
	echo "	-u [OPTIONAL] = input client's username if the deffault one (ucanlab) is not used"
	exit
}

#-------------------------------------------------------------------

# Creates array from command line inputs
addresses_no_range()
{
	IFS=','
	read -ra ip <<< "$OPTARG"
}

#-------------------------------------------------------------------

# Parse input and create ip array from arg1 through arg2
addresses_range()
{
	IFS=','
	read -ra temp <<< "$OPTARG"
	index=0
	for (( i=${temp[0]}; i<=${temp[1]}; i++ ))
	do
		ip[$index]=$i
		index=$((index+1))
	done
}

#-------------------------------------------------------------------
# Set default parameters

uname=ucanlab # default

#-------------------------------------------------------------------
# Get arguments and set appropriate parameters

while getopts 'hn:ur:l:' OPTION; do
	case "$OPTION" in
		h)
			help;;
		n)
			network_interface=$OPTARG;;
		r)
			addresses_range;;
		l)
			addresses_no_range;;
		u)
			uname=$OPTARG;;
	esac
done


#############################
#####     Main Code     #####
#############################
#-------------------------------------------------------------------

i=0
for i in "${ip[@]}"
do

# if statement checks which RPi is in server mode by looking for eth1 address
if ssh ucanlab@"10.1.1.$i" [ ! -d /sys/class/net/$network_interface ]
then
	echo "Network Interface not found for $i"
else
	echo "$network_interface MAC Address for $i:"
	ssh $uname@"10.1.1.$i" cat /sys/class/net/$network_interface/address
fi
i=$((i + 1))
done

