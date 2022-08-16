#!/bin/bash
#############################################################################
# Author: Lenny Martinez
#
# Description: Takes one command line input for the last 3 digits of the Pis 
#   IP. It then checks tp see if the TB_Results directory exists. If it does 
#   then it echos that it exists. If it does not exist then it will tell you 
#   it doesnt exist then creates the directory
#
# Input: call the file and add the last 3 digits of the IP address to the 
#   command line as a positional argument ie: bash setup_pis.sh 101
#
#############################################################################
	
#############################
#####     Functions     #####
#############################
#-------------------------------------------------------------------

help()
{
	echo ""
	echo "	### Bash script for initial setup of the testbed's RPi nodes ###"
	echo "	---------------------------------------------------------------------------------------"
	echo "	-l = list of testbed node addresses (e.g., 'bash get_mac.sh -l 103,105,109')"
	echo "	-r = range of testbed node addresses (e.g., 'bash get_mac.sh -r 103,107')"
	echo "	-c [OPTIONAL] = flag to clear existing directory/contents if specified (default: 0)"
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
clear_dir=0
debug=0
top_dir=~/ucan_TB
ERR=0

#-------------------------------------------------------------------
# Get arguments and set appropriate parameters

while getopts 'hl:r:cu:d' OPTION; do
	case "$OPTION" in
		h)
			help;;
		l)
			addresses_list;;
		r)
			addresses_range;;
		c)
			clear_dir=1;;
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
	echo "  Clear Directory: $clear_dir"
	echo "  Top Level Directory: $top_dir" 
	echo "  UName: $uname"
	echo ""
	exit
fi

# Main code to setup desired RPis

# Check RPis for top directory, and either clear it or throw error (depending on -c flag)
#-------------------------------------------------------------------
for i in "${addresses[@]}"
do
	if ssh $uname@10.1.1.$i [ -d $top_dir ] # checks if the given directory folder exists on ith Pi
	then
		#echo "TB Directory exists on Pi $i"
		if (( $clear_dir == 1))
		then
			# Remove the directory and all contents
			ssh $uname@10.1.1.$i rm -r $top_dir
		else
			ERR=1
		fi
	#else
		#echo "No TB Directory found on Pi $i"
	fi

done	

# If no errors, then create the TB_Results and TB_Scripts directories for all Pis
#-------------------------------------------------------------------
if (( $ERR > 0 ))
then
	# Do not setup if any Pis have the directory already
	echo "The Directory already exists on one or more Pis" 
else
	# Loop through and setup Pis
	for i in "${addresses[@]}"
	do
		ssh $uname@10.1.1.$i mkdir $top_dir/TB_Results -p
		ssh $uname@10.1.1.$i mkdir $top_dir/TB_Scripts -p
		#TODO: Move any relevant python (or other) scripts to TB_Scripts directory			
	done
fi


