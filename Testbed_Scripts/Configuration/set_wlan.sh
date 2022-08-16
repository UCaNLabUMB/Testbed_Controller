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

#-------------------------------------------------------------------
help()
{
	echo ""
	echo "	### Bash script to set the wlan for a given testbed node ###"
	echo "	----------------------------------------------------------------------------"
	echo "	-a = testbed node address (e.g., set_wlan.sh -a 105)"
	echo "	-s = Specify SSID of desired WLAN (e.g., set_wlan.sh -s UCaNLab_5G)"
	echo "	-p = Specify passphrase for desired WLAN (e.g., set_wlan.sh -p password123)"
	echo "	-u [OPTIONAL] = input client's username (default: ucanlab)"
	echo ""
	exit
}

#-------------------------------------------------------------------
# Set default parameters
uname=ucanlab   # default
top_dir=~/ucan_TB
debug=0


#-------------------------------------------------------------------
# Get arguments and set appropriate parameters
while getopts 'ha:s:p:d' OPTION; do
	case "$OPTION" in
		h)
			help;;
		a)
			address=$OPTARG;;
		s)
			SSID=$OPTARG;;			
		p)
			pw=$OPTARG;;
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
	echo "Address: $address"
	echo "SSID: $SSID"
	echo "Password: $pw"
	echo "UName: $uname"
	exit
fi

ssh $uname@10.1.1.$address bash $top_dir/TB_Scripts/set_wlan_local.sh -s $SSID -p $pw
ssh $uname@10.1.1.$address sudo reboot



