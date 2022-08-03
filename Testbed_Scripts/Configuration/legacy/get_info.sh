#!/bin/bash

#################################################################### 
# get_info.sh
#
# Initial Authors: Humza Ali / Myles Toole
#
# Description: This script shows IP address, OS version, RAM memory and disk space info of the given node.
#
# Input: bash get_info.sh -a 101, or -os 101, etc..
#
# **For Help, enter -h**
#
####################################################################

help()
{
	echo "-a = input the node's IP suffix. Ex: 103"
	echo "-os = shows the installed operating system's version"
	echo "-ram = shows the free and used ram memory info"
	echo "-memory = shows the amount of free disk space available"
}


while getopts ":a:os:ram:memory:h" options; do
	case "${options}" in 
		a ) ip=${OPTARG}
		    echo $ip
		    ip_full="10.1.1.$ip"
		    echo $ip_full
			;;
                os ) cat /etc/os-release
		    ;;	

		ram ) free -m
			;;
		
		memory ) df -h
           	    ;;
           	h ) help;;
	esac
done
