#!/bin/bash

#################################################################### 
# get_SSIDs.sh
#
# Initial Authors: Humza Ali / Myles Toole
#
# Description: This script is meant to check the status of all the nodes 
#    in our system (whether or not they are connected to the control network)
#
# Input:
#
####################################################################

#-------------------------------------------------------------------
help()
{
	echo "	### Bash script to list SSIDs of WLAN connections for testbed nodes ###"
	echo "	----------------------------------------------------------------------------"
	echo "	-l = list of testbed node addresses (e.g., get_SSIDs.sh -l 103,105,109)"
	echo "	-r = range of testbed node addresses (e.g., get_SSIDs.sh -r 103,107)"
	echo "	-u [OPTIONAL] = input client's username (default: ucanlab)"
	exit
}

#-------------------------------------------------------------------
# Parse input and create addresses array from arg1 through arg2
addresses_range()
{
	IFS=','
	read -ra temp <<< "$OPTARG"
	index=0
	for (( i=${temp[0]}; i<=${temp[1]}; i++ ))
	do
		addresses[$index]=$i
		index=$((index+1))
	done

}

#-------------------------------------------------------------------
# Set default parameters
uname=ucanlab   # default
debug=0


#-------------------------------------------------------------------
# Get arguments and set appropriate parameters
while getopts 'hl:r:u:d' OPTION; do
	case "$OPTION" in
		h)
			help;;
		l)
			IFS=','
			read -ra addresses <<< "$OPTARG"
			;;
		r)
			addresses_range;;			
		u)
			uname=$OPTARG;;
		d)
			debug=1;;
	esac
done



#############################
#####     Main Code     #####
#############################
#-------------------------------------------------------------------

if [ $debug -gt 0 ]
then
	# for debugging... use -d flag
	echo "##### Debug Info: #####"
	echo "Nodes: ${addresses[@]}"
	echo "UName: $uname"
else	
	# Loop through addresses and get the SSID for each node
	for i in "${addresses[@]}"
	do
		echo "pi $i SSID:"
		ssh $uname@"10.1.1.$i" /usr/sbin/iwgetid -r
	done

fi




