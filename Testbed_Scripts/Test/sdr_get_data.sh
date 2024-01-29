#!/bin/bash

#################################################################### 
# sdr_get_data.sh
#
# Author: MR
#
# Description: This script gets power measurements from specified 
#    nodes over a range of frequencies.
#
# Input: 
#
# **For Help, enter -h**
#
####################################################################
#############################
#####     Functions     #####
#############################
#---------------------------------------------------------------------------------------------

help()
{
	echo ""
	echo "	### Bash script to get power measurements at specified nodes ###"
	echo "	---------------------------------------------------------------------------------------"
	echo "	-l = list of client node addresses (e.g., 'bash sdr_get_data.sh -l 103,105,109')"
	echo "	-r = range of client node addresses (e.g., 'bash sdr_get_data.sh -r 103,107')"
	echo "	-c = desired carrier frequencies (e.g., 'bash sdr_get_data.sh -c 912000000,915000000')"
	echo "	-u [OPTIONAL] = input client's username if the default one (ucanlab) is not used"
	echo ""
	exit
}

#---------------------------------------------------------------------------------------------
# Creates array from command line inputs
addresses_list()
{
	IFS=','
	read -ra my_addresses <<< "$OPTARG"
}

#---------------------------------------------------------------------------------------------
# Parse input and create ip array from arg1 through arg2
addresses_range()
{
	IFS=','
	read -ra temp <<< "$OPTARG"
	index=0
	for (( i=${temp[0]}; i<=${temp[1]}; i++ ))
	do
		my_addresses[$index]=$i
		index=$((index+1))
	done
}

#---------------------------------------------------------------------------------------------
# Creates array from command line inputs
carrier_freq_list()
{
	IFS=','
	read -ra my_carrier_freqs <<< "$OPTARG"
}

#############################
#####   Setup Params    #####
#############################
#---------------------------------------------------------------------------------------------
# Set default parameters

uname=ucanlab # default
debug=0

tx_xmlrpc_port=':8080'
rx_xmlrpc_port=':8081'
zmq_port=':55555'

#---------------------------------------------------------------------------------------------
# Get arguments and set appropriate parameters

while getopts 'hl:r:c:u:d' OPTION; do
	case "$OPTION" in
		h)
			help;;
		l)
			addresses_list;;
		r)
			addresses_range;;
		c)
			carrier_freq_list;;
		u)
			uname=$OPTARG;; # in case the username is not the default one, use this flag to user another username
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
	echo "  Nodes: ${my_addresses[@]}"
	echo "  Carriers: ${my_carrier_freqs[@]}"
	echo "  UName: $uname"
	echo ""
	exit
fi	


#############################
#####     Main Code     #####
#############################
#------------------------------------------------------------------------------------


# Setup output headings

temp="   Node ID"
j=0
while [[ $j -lt ${#my_carrier_freqs[@]} ]]; do # loop through desired carriers
	my_fc=${my_carrier_freqs[$j]}
	temp="$temp, fc=$my_fc "

	j=$((j + 1))
done

echo $temp

# Iterate through nodes and desired carrier frequencies
i=0
while [[ $i -lt ${#my_addresses[@]} ]]; do # loop through number of nodes
	# get desired values from list 
	my_addr=${my_addresses[$i]}
	temp="     $my_addr"
	
	j=0
	while [[ $j -lt ${#my_carrier_freqs[@]} ]]; do # loop through desired carriers
		my_fc=${my_carrier_freqs[$j]}
		
		# Set carrier
		python3 SDR_control/set_remote_params_rx.py -n $my_addr -c $my_fc
		sleep 1
		
		# Get Measurement
		measurement=$(python3 SDR_control/get_power_measurements.py -n $my_addr -r 1 -t 1)
		temp="$temp, $measurement "		

		j=$((j + 1))
	done
	i=$((i + 1))
	
	echo $temp
done



