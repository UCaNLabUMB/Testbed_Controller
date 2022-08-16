#!/bin/bash

#################################################################### 
# verify_nodes.sh
#
# Initial Author: Humza Ali
#
# Description: This script is meant to check the status of all the nodes 
#    in our system (whether or not they are connected to the control network)
#
# Input: If no arguments are passed, run bash verify_nodes.sh and then enter the IPs.
#	 For a node range, run bash verify_nodes.sh -r 101 106
#	 For specific nodes, run bash verify_nodes.sh -l 103 or -l 103 105 108
#
####################################################################

#############################
#####     Functions     #####
#############################
#-------------------------------------------------------------------
help()
{
	echo ""
	echo "	### Bash script to verify connection to testbed nodes ###"
	echo "	----------------------------------------------------------------------------"
	echo "	-l = single node or list of nodes. (e.g., 'bash verify_nodes.sh -l 103', or, -l 103,106,108)"	
	echo "	-r = nodes range (e.g., 'bash verify_nodes.sh -r 101,106' for nodes 101 through 106)"
	echo ""
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



#############################
#####   Setup Params    #####
#############################
#-------------------------------------------------------------------
# Set default parameters
debug=0


#-------------------------------------------------------------------
# Get arguments and set appropriate parameters
while getopts 'hl:r:d' OPTION; do
	case "$OPTION" in
		h)
			help;;
		l)
			IFS=','
			read -ra addresses <<< "$OPTARG"
			;;
		r)
			addresses_range;;			
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
	echo ""
	echo "  ##### Debug Info: #####"
	echo "  Nodes: ${addresses[@]}"
	echo ""
	exit
fi

# Loop through addresses and ping nodes to verify status
for i in "${addresses[@]}"
do
	ping -c 1 -W 0.1 "10.1.1.$i" > /dev/null
	if [ $? -eq 0 ]; then
		echo "10.1.1.$i is up"
	else 
		echo "10.1.1.$i is down"
	fi
done

