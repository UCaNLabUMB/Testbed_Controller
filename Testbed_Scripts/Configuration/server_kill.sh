#!/bin/bash

#################################################################### 
# server_kill.sh
#
# Author: Victoria Planchart
#
# Description: This script kills the open ports in the specified pi.
#
# Input:  enter username and IP suffix with their respective flags followed by the ports' number to be killed separated by a space.
# example:bash server_kill.sh -u ucanlab -a 201 1168 1125 1142 1136
#
# **For Help, enter -h**
#
####################################################################


help()
{
	echo "-a = input the suffix of the pi's IP address. (-a 201 for IP: 10.1.1.201)"
	echo "-u = input pi's username"
	echo "enter ports' numbers separted by a space"
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

ssh $uname@10.1.1.$ip kill -9 $1 $2 $3 $4 $5 $6 $7 $8 $9
