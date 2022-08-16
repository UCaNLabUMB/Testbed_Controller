#!/bin/bash

#################################################################### 
# get_info_pi.sh
#
# Initial Authors: Humza Ali / Myles Toole
#
# Description: This script shows Pi version, OS version, RAM memory 
# 		and disk space info of the given node.
#
# Input: bash get_info.sh -r 101,105
#
# **For Help, enter -h**
#
####################################################################

#############################
#####     Functions     #####
#############################
#-------------------------------------------------------------------

help()
{
	echo ""
	echo "	### Bash script to get general information about Pi nodes ###"
	echo "	---------------------------------------------------------------------------------------"
	echo "	-l = list of testbed node addresses (e.g., 'bash get_info_pi.sh -l 103,105,109')"
	echo "	-r = range of testbed node addresses (e.g., 'bash get_info_pi.sh -r 103,107')"
	echo "	-m [OPTIONAL] = List the RAM size for each specified node"
	echo "	-p [OPTIONAL] = List the WiFi Tx power for each specified node"
	echo "	-o [OPTIONAL] = List the installed OS for each specified node"
	echo "	-v [OPTIONAL] = List the Pi type for each specified node"
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

#-------------------------------------------------------------------

# function to setup the top row of the output
setup_col_titles()
{
	#TODO: Find a way to auto-adjust the column widths
	
	temp1="   Node  "	
	temp2="  ------ "
	
	#------------------
	if (( $ram_check == 1 ))
	then
		temp1="$temp1     RAM    "
		temp2="$temp2 -----------"
	fi
	
	#------------------
	if (( $power_check == 1 ))
	then
		temp1="$temp1   Tx Power "
		temp2="$temp2  ----------"
	fi
	
	#------------------
	if (( $os_check == 1 ))
	then
		temp1="$temp1      OS    "
		temp2="$temp2  ----------"
	fi
		
	#------------------
	if (( $ver_check == 1 ))
	then
		temp1="$temp1   Pi Version "
		temp2="$temp2  ------------"
	fi
	
	echo ""
	echo $temp1
	echo $temp2
}

#############################
#####   Setup Params    #####
#############################
#-------------------------------------------------------------------
# Set default parameters

ver_check=0
ram_check=0
os_check=0	
power_check=0
uname=ucanlab # default
debug=0

#-------------------------------------------------------------------
# Get arguments and set appropriate parameters

while getopts 'hl:r:mpovu:' OPTION; do
	case "$OPTION" in
		h)
			help;;
		l)
			addresses_list;;
		r)
			addresses_range;;
		m)
			ram_check=1;;
		p)
			power_check=1;;
		o)
			os_check=1;;			
		v)
			ver_check=1;;
		u)
			uname=$OPTARG;;	
	esac
done


#############################
#####     Main Code     #####
#############################
#-------------------------------------------------------------------

# Call function to setup top row of output
setup_col_titles

# Loop through addresses and get the desired info
for i in "${addresses[@]}"
do

	# Put Pi number in first column
	temp="    $i"
	
	#------------------
	# check for ram
	if (( $ram_check == 1 ))
	then
		temp="$temp   $(ssh $uname@"10.1.1.$i" cat /proc/meminfo | grep "MemTotal" | awk '{print $2 " " $3}')"
	fi
	
	#------------------
	# check for Tx Power
	if (( $power_check == 1 ))
	then
		#NOTE: Requires sudo to access iwconfig
		my_power=$(ssh $uname@"10.1.1.$i" sudo iwconfig wlan0 | grep "Tx-Power" | awk -F[\=] '{print $3}')
		if [ -z "$my_power" ]
		then
			my_power="WiFi Off "
		fi
		
		temp="$temp     $my_power"
	fi
		
	#------------------
	# check for os
	if (( $os_check == 1 ))
	then
		temp="$temp    $(ssh $uname@"10.1.1.$i" cat /etc/os-release | grep "^ID=" | awk -F'[/=]' '{print $2}')"
	fi
		
	#------------------
	# check for version
	if (( $ver_check == 1 ))
	then
		temp="$temp  $(ssh $uname@"10.1.1.$i" cat /proc/cpuinfo | grep "Model" | awk '{$1=$2=""; print $0}')"
	fi
	
	# Print information for each Pi on a single Row
	echo $temp	
	
done

echo ""
