#!/bin/bash

#################################################################### 
# server_status.sh
#
# Author: Victoria Planchart
#
# Description: This script checks for open ports in the specified pi.
#
# Input: enter username and IP suffix with their respective flags.
# example: bash server_status.sh -u ucanlab -a 101 (for address 10.1.1.101)
#
# **For Help, enter -h**
#
####################################################################

#############################
#####     Functions     #####
#############################
#------------------------------------------------------------------------------------

help()
{
	echo ""
	echo "	### Bash script to check for active iperf servers (pid shown in last col) ###"
	echo "	-a = input the suffix of the pi's IP address. (-a 101 for IP: 10.1.1.101)"
	echo "	-u [OPTIONAL] = client's username (e.g., '-u uname') (default: ucanlab)"
	echo ""
	exit
}



#############################
#####   Setup Params    #####
#############################
#---------------------------------------------------------------------------------------------
# Set default parameters

uname=ucanlab # default

#------------------------------------------------------------------------------------
# Get arguments and set appropriate parameters

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



#############################
#####     Main Code     #####
#############################
#------------------------------------------------------------------------------------

ssh $uname@10.1.1.$ip netstat -l -p | grep iperf
