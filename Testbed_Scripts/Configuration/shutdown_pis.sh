#!/bin/bash
#############################################################################
# Author: MR
#
# Description: Takes a list or range of Pi node addresses, and shuts down
#               gracefully to avoid hard power down.
#
# Input: 
#
#############################################################################
	
#############################
#####     Functions     #####
#############################
#-------------------------------------------------------------------

help()
{
	echo ""
	echo "	### Bash script for shutting down the testbed's RPi nodes ###"
	echo "	---------------------------------------------------------------------------------------"
	echo "	-l = list of testbed node addresses (e.g., 'bash shutdown_pis.sh -l 103,105,109')"
	echo "	-r = range of testbed node addresses (e.g., 'bash shutdown_pis.sh -r 103,107')"
	echo "	-p = password for the testbed nodes (e.g., 'bash shutdown_pis.sh -r 103,107 -p <pw>')"
	echo "	-b [OPTIONAL] = reboot rather than shutdown"
	echo "	-u [OPTIONAL] = client's username (e.g., '-u uname') (default: ucanlab)"
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

uname=ucanlab # default
my_password=default_pw # default
reboot=0
debug=0

#-------------------------------------------------------------------
# Get arguments and set appropriate parameters

while getopts 'hl:r:p:bu:d' OPTION; do
	case "$OPTION" in
		h)
			help;;
		l)
			addresses_list;;
		r)
			addresses_range;;
		p)
			my_password=$OPTARG;;
		b)
			reboot=1;;
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
	echo ""
	echo "  ##### Debug Info: #####"
	echo "  Nodes: ${addresses[@]}"
	echo "  Reboot: $reboot"
	echo "  Password: $my_password"
	echo "  UName: $uname"
	echo ""
	exit
fi

# Main code to shut down desired RPis
#-------------------------------------------------------------------

# Loop through and setup Pis
for i in "${addresses[@]}"
do

	#------------------
	# check for reboot flag
	if (( $reboot == 1 ))
	then
		ssh $uname@10.1.1.$i "echo $my_password | sudo -S shutdown -r now"
		echo " Rebooting Node $i"
	else
		ssh $uname@10.1.1.$i "echo $my_password | sudo -S shutdown now"
		echo " Shutting Down Node $i"
		
	fi
	
	sleep 1

done


