#!/bin/bash

#################################################################### 
# get_wlan_ip.sh
#
# Author: Victoria Planchart
#
# Description: This script indicates the wlan0 or eth0 IP address of the given nodes.
#
# Input: bash get_wlan_ip.sh -i 192 or 10 -r 101 115 (this will get the IPs of the nodes from 101 to 115)
#	 bash get_wlan_ip.sh -i 192 or 10 -a, enter, then type specific node's IP (101 104 107 112)
#
# **For Help, enter -h**
#
####################################################################

help()
{
	echo "	-u [OPTIONAL] = input the RPis username"
	echo "	-i = input either 192 for the wlan0 IP address or 10 for the eth0 IP address of the RPis"
	echo "	-r = input the maximum and minimum values of the node range. Ex: For nodes 101 through 106, type -r 101 106"
	echo "  -a = type in -a with no inputs, enter, and then enter specific RPis"
}

no_range()
{
	read -a ip
}

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

uname=ucanlab

while getopts 'hi:ur:a' OPTION; do
	case "$OPTION" in
		h)
			help;;
		i)
			interface=$OPTARG;;
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
	echo "$interface IP Address for $i:"
	ssh $uname@"10.1.1.$i" ip addr | grep "inet $interface" | awk '{print $2}'
i=$((i + 1))
done

