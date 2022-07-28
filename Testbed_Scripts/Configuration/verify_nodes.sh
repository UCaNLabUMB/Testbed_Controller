#!/bin/bash

#################################################################### 
# verify_nodes.sh
#
# Initial Author: Humza Ali
#
# Description: This script is meant to check the status of all the nodes 
#    in our system (whether or not they are connected to the control network)
#
# Input: 
#
####################################################################

dev=()
if [ -z "$1" ] # $1 has a length of 0 if no arguments are passed in.
then
# This section is runs when no arguments are passed to the Testbed Controller terminal. 
# Once the script is run, it will ask for the user to input the nodes to verify

	echo "Naming convention is 10.1.1.x"
	echo "Input each corresponding ip to be pinged"
	echo "i.e., for devices 10.1.1.101 to 10.1.1.104, input 101 102 103 104"
	read -a ip
	echo ${ip[@]}
	for i in "${ip[@]}"
	do
		ping -c 1 -W 0.1 "10.1.1.$i" > /dev/null
		if [ $? -eq 0 ]; then
			echo "10.1.1.$i is up"
			dev[${#dev[@]}]=1
		else 
			echo "10.1.1.$i is down"
		fi
	done
else
# This section is runs when a flag / arguments are passed in the command

	while [ "$#" -gt 0 ];
	do
	case "$1" in 
		# run this command with the flag -r and the maximum and minumum values of 
		# the node range. Ex: For nodes 101 through 106, run "bash get_ip.sh -r 101 106"
		-r) 
		var1="$2"; 
		var2="$3";
		for (( i=$var1; i<=$var2; i++ ))
		do
			ping -c 1 -W 0.1 "10.1.1.$i" > /dev/null
			if [ $? -eq 0 ]; then
				echo "10.1.1.$i is up"
			else 
				echo "10.1.1.$i is down"
			fi
		done
		;;
		# To check a specific list of nodes, run this command with the flag -l and the the specific node
		# value. Ex: For nodes 101, 106, and 107, run "bash get_ap.sh -l 101 106 107"
		-l) 
		new=( "$@" )
		for (( i=1; i<=${#new[@]}-1; i++))
		do
			ping -c 1 -W 0.1 "10.1.1.${new[i]}" > /dev/null
			if [ $? -eq 0 ]; then
				echo "10.1.1.${new[i]} is up"
			else 
				echo "10.1.1.${new[i]} is down"
			fi
		done
		;;
	esac
	break
	done
fi


