#!/bin/bash

#################################################################### 
# get_wlan_ip.sh
#
# Author: Victoria Planchart
#
# Description: This script indicates the wlan0 or eth0 IP address of the given nodes.
#
# Input: bash get_wlan_ip.sh -i 192 or 10 -r 101,115 (this will get the IPs of the nodes from 101 to 115)
#	 bash get_wlan_ip.sh -i 192 or 10 -l 101,103,105,107,111 (for specific node's IP)
#
# **For Help, enter -h**
#
####################################################################

#-------------------------------------------------------------------

help()
{
	echo "	### Bash script to get eth0 or wlan0 IP addresses for testbed nodes ###"
	echo "	---------------------------------------------------------------------------------------"
	echo "	-i = input 192 for the wlan0 IP address or 10 for the eth0 IP address of the nodes"
	echo "	-r = range of testbed node addresses (e.g., bash get_wlan_ip.sh -r 103,107)"
	echo "	-l = list of testbed node addresses (e.g., bash get_wlan_ip.sh -l 103,105,109)"
	echo "	-u [OPTIONAL] = input the RPis username"
	exit
}

#-------------------------------------------------------------------

addresses_no_range()
{
	IFS=','
	read -ra ip <<< "$OPTARG"
}

#-------------------------------------------------------------------

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

while getopts 'hi:ur:l:' OPTION; do
	case "$OPTION" in
		h)
			help;;
		i)
			interface=$OPTARG;;
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
	echo "$interface IP Address for $i:"
	ssh $uname@"10.1.1.$i" ip addr | grep "inet $interface" | awk '{print $2}'
i=$((i + 1))
done

