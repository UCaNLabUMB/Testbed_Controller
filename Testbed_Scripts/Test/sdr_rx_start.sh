#!/bin/bash

##############################################################################################
# sdr_rx_start.sh
#
# Author: MR
#
# Description: This script starts the sdr receiver on a desired set of nodes
#
# Input: 
#
# **For Help, enter -h**
#
##############################################################################################

#############################
#####     Functions     #####
#############################
#---------------------------------------------------------------------------------------------

help()
{
	echo ""
	echo "	### Bash script to initiate SDR receiver at specified nodes ###"
	echo "	---------------------------------------------------------------------------------------"
	echo "	-l = list of client node addresses (e.g., 'bash sdr_rx_start.sh -l 103,105,109')"
	echo "	-r = range of client node addresses (e.g., 'bash sdr_rx_start.sh -r 103,107')"
	echo "	-a = list of sampling rates for corresponding nodes"
	echo "	          (e.g., 'bash sdr_rx_start.sh -l 101,103 -a 3e6,2e6')"
	echo "	-c = list of carrier frequencies for corresponding nodes "
	echo "	          (e.g., 'bash sdr_rx_start.sh -l 101,103 -c 915e6,2.4e9')"
	echo "	-g = list of gain values for corresponding nodes "
	echo "	          (e.g., 'bash sdr_rx_start.sh -l 101,103 -g 25,40')"
	echo "	-u [OPTIONAL] = input client's username if the deffault one (ucanlab) is not used"
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
samp_rate_list()
{
	IFS=','
	read -ra my_samp_rates <<< "$OPTARG"
}

#---------------------------------------------------------------------------------------------
# Creates array from command line inputs
carrier_freq_list()
{
	IFS=','
	read -ra my_carrier_freqs <<< "$OPTARG"
}

#---------------------------------------------------------------------------------------------
# Creates array from command line inputs
gain_list()
{
	IFS=','
	read -ra my_gain_vals <<< "$OPTARG"
}


#############################
#####   Setup Params    #####
#############################
#---------------------------------------------------------------------------------------------
# Set default parameters

uname=ucanlab # default
debug=0

#---------------------------------------------------------------------------------------------
# Get arguments and set appropriate parameters

while getopts 'hl:r:a:c:g:u:d' OPTION; do
	case "$OPTION" in
		h)
			help;;
		l)
			addresses_list;;
		r)
			addresses_range;;
		a)
			samp_rate_list;;
		c)
			carrier_freq_list;;
		g)
			gain_list;;
		u)
			uname=$OPTARG;; # in case the username is not the default one, use this flag to user another username
		d)
			debug=1;;
	esac
done

# Setup Pi's top directory after input, in case Pi username is not default
top_dir=/home/$uname/ucan_TB


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
	echo "  Sample Rates: ${my_samp_rates[@]}"
	echo "  Carrier Frequencies: ${my_carrier_freqs[@]}"
	echo "  Gain Values: ${my_gain_vals[@]}"
	echo "  Testbed Folder: $top_dir"
	echo "  UName: $uname"
	echo ""
	exit
fi	

i=0
while [[ $i -lt ${#my_addresses[@]} ]]; do # loop through number of nodes
	# get desired values from list 
	my_addr=${my_addresses[$i]}
	my_r=${my_samp_rates[$i]}
	my_c=${my_carrier_freqs[$i]}
	my_g=${my_gain_vals[$i]}
	
	echo "Starting General Rx Script on Pi $my_addr at $my_c Hz with rate $my_r and gain $my_g"
	ssh $uname@10.1.1.$my_addr python3 $top_dir/TB_Scripts/Rx_general.py -r $my_r -c $my_c -g $my_g -n $my_addr 2> /dev/null &
	
	i=$((i + 1))
done


