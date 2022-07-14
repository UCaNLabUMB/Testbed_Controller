#!/bin/bash

#################################################################### 
# server_status.sh
#
# Author: Victoria Planchart
#
# Description: This script checks for open ports in the specified pi.
#
# Input: enter username and IP suffix with their respective flags.
# example: bash server_status.sh -u ucanlab -a 201 (for address 10.1.1.201)
#
# **For Help, enter -h**
#
####################################################################


help()
{
	echo "-a = input the suffix of the pi's IP address. (-a 201 for IP: 10.1.1.201)"
	echo "-u = input pi's username"
}


while getopts 'ha:u:' OPTION; do
	case "$OPTION" in
		h)
			help;;
		a)
			ip=$OPTARG;;
		u)
			uname=$OPTARG;;
	esac
done

ssh $uname@10.1.1.$ip netstat -l -p | grep iperf
