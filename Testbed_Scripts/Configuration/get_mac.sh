#!/bin/bash

#################################################################### 
# get_mac.sh
#
# Author: Victoria Planchart
#
# Description: This script indicates the MAC address of the given IP addresses.
#
# Input: bash get_mac.sh enter, then enter the IP address suffix. 
# Example: for IP:10.1.1.102 enter 102. For multiple IP addresses enter 102 103 104
#
####################################################################


echo "Input pi's IP address suffix to get MAC Address. For muliple IPs enter them separated by a space."
echo "For example: For IP 10.1.1.103, enter 103. For multiple addresses type: 102 103 105 106"

read -a ip

network_interface=eth0 # deffault

while getopts 'hni:' OPTION; do
	case "$OPTION" in
		h)
			help;;
		ni)
			network_interface=$OPTARG;; 
	esac
done

for i in "${ip[@]}"
do
	if ssh ucanlab@"10.1.1.$i" [ ! -d /sys/class/net/$network_interface ]
	then
		echo "Network Interface not found"
	else
		echo "$network_interface MAC Address for $i:"
		ssh ucanlab@"10.1.1.$i" cat /sys/class/net/$network_interface/address
	fi
	i=$((i + 1))
done
