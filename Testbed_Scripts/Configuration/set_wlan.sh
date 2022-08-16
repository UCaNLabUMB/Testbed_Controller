#!/bin/bash

#################################################################### 
# set_wlan.sh
#
# Author: MR (Modified earlier code from Myles Toole)
#
# Description: This script sets the wlan for a given testbed node.
# 		Note that the Pis reboot after resetting the WLAN, 
#		so need to give them a minute to restart.
#
# Input:
#
####################################################################

#############################
#####     Functions     #####
#############################
#-------------------------------------------------------------------
help()
{
	echo ""
	echo "	### Bash script to set the wlan for a given testbed node ###"
	echo "	----------------------------------------------------------------------------"
	echo "	-l = list of testbed node addresses (e.g., 'bash get_info.sh -l 103,105,109')"
	echo "	-r = range of testbed node addresses (e.g., 'bash get_info.sh -r 103,107')"
	echo "	-s = Specify SSID of desired WLAN (e.g., set_wlan.sh -s UCaNLab_5G)"
	echo "	-p = Specify passphrase for desired WLAN (e.g., set_wlan.sh -p password123)"
	echo "	-u [OPTIONAL] = input client's username (default: ucanlab)"
	echo ""
	exit
}

#-------------------------------------------------------------------

# Creates array from command line inputs
addresses_list()
{
	IFS=','
	read -ra addresses <<< "$OPTARG"
}

#-------------------------------------------------------------------

# Parse input and create ip array from arg1 through arg2
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
uname=ucanlab   # default
debug=0


#-------------------------------------------------------------------
# Get arguments and set appropriate parameters
while getopts 'hl:r:s:p:d' OPTION; do
	case "$OPTION" in
		h)
			help;;
		l)
			addresses_list;;
		r)
			addresses_range;;
		s)
			SSID=$OPTARG;;			
		p)
			pw=$OPTARG;;
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
	echo "  Nodes: ${addresses[@]}"
	echo "  SSID: $SSID"
	echo "  Password: $pw"
	echo "  UName: $uname"
	echo ""
	exit
fi

for i in "${addresses[@]}"
do
	ssh $uname@10.1.1.$i bash $top_dir/TB_Scripts/set_wlan_local.sh -s $SSID -p $pw
	ssh $uname@10.1.1.$i sudo reboot
done



