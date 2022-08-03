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


help()
{
	echo "-a = input the suffix of the pi's IP address. (-a 201 for IP: 10.1.1.201)"
	echo "-u [OPTIONAL] = input pi's username"
	echo "enter ports' numbers separted by a space"
}

uname=ucanlab # deffault

while getopts 'ha:u' OPTION; do
	case "$OPTION" in
		h)
			help;;
		a)
			ip=$OPTARG;;
		u)
			uname=$OPTARG;;
	esac
done

read -a ip

ssh $uname@10.1.1.$ip kill -9 ${ip[@]}
