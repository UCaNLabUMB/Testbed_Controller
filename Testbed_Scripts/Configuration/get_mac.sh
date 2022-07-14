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


if [ -z "$@" ]
then

echo "Input pi's IP address suffix to get MAC Address. For muliple IPs enter them separated by a space."
echo "For example: For IP 10.1.1.103, enter 103. For multiple addresses type: 102 103 105 106"
read -a ip
for i in "${ip[@]}"
do
        echo "MAC Address:"
	ssh ucanlab@"10.1.1.$i" cat /sys/class/net/eth0/address
done
fi
