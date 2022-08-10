#!/bin/bash

#################################################################### 
# server_kill.sh
#
# Author: Victoria Planchart
#
# Description: This script kills the open ports in the specified server node.
#
# Input: bash server_kill.sh -u ucanlab (OPTIONAL) -a 201 <<< "1168 1125 1142 1136"
#
# **For Help, enter -h**
#
####################################################################

#------------------------------------------------------------------------------------

help()
{
	echo "	-a = input the suffix of the pi's IP address. (-a 201 for IP: 10.1.1.201)"
	echo "	-p = input the ports' number to be killed. (-p 3031,3032,3239,3458)"
	echo "	-u [OPTIONAL] = input pi's username"
	exit
}


#---------------------------------------------------------------------------------------------
# Set default parameters

uname=ucanlab # default


#------------------------------------------------------------------------------------
# Get arguments and set appropriate parameters

while getopts 'ha:up:' OPTION; do
	case "$OPTION" in
		h)
			help;;
		a)
			ip=$OPTARG;;
		p)
			IFS=','
			read -ra ports <<< "$OPTARG";;
		u)
			uname=$OPTARG;;
	esac
done


#############################
#####     Main Code     #####
#############################
#------------------------------------------------------------------------------------

ssh $uname@10.1.1.$ip kill -9 ${ports[@]}

