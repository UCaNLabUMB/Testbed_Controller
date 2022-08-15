#!/bin/bash

#################################################################### 
# server_kill.sh
#
# Author: Victoria Planchart
#
# Description: This script kills the open ports in the specified server node.
#
# Input: bash server_kill.sh -a 101 -p 5202,5204,5209
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
	echo "	### Bash script to kill iperf servers on desired node ###"
	echo "	-a = input the suffix of the pi's IP address. (-a 101 for IP: 10.1.1.101)"
	echo "	-p = input the pid number(s) of iperf processes to be killed. (-p 3031,3032,3458)"
	echo "	        CAUTION: can kill other processes if incorrect pid is given"
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

while getopts 'ha:u:p:' OPTION; do
	case "$OPTION" in
		h)
			help;;
		a)
			ip=$OPTARG;;
		p)
			IFS=','
			read -ra pids <<< "$OPTARG";;
		u)
			uname=$OPTARG;;
	esac
done



#############################
#####     Main Code     #####
#############################
#------------------------------------------------------------------------------------

ssh $uname@10.1.1.$ip kill -9 ${pids[@]}

