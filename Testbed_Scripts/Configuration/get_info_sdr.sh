#!/bin/bash

#################################################################### 
# get_info_sdr.sh
#
# Author: MR
#
# Description: This script is meant to check the status of sdr 
#    software and hardware on the remote pi (assumes pisdr OS installed)
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
	echo "	###        Bash script to list SDR capabilitiesfor testbed nodes         ###"
	echo "	----------------------------------------------------------------------------"
	echo "	-l = list of testbed node addresses (e.g., get_info_sdr.sh -l 103,105,109)"
	echo "	-r = range of testbed node addresses (e.g., get_info_sdr.sh -r 103,107)"
	echo "	-g [OPTIONAL] = List the version of GNURadio installed"
	echo "	-s [OPTIONAL] = List the available SDR hardware for each node"
	echo "	-a [OPTIONAL] = List the available SDR hardware's address"
	echo "	-u [OPTIONAL] = client's username (e.g., '-u uname') (default: ucanlab)"
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

# function to setup the top row of the output
setup_col_titles()
{
	#TODO: Find a way to auto-adjust the column widths
	
	temp1="   Node  "	
	temp2="  ------ "
	
	#------------------
	if (( $gnuradio_check == 1 ))
	then
		temp1="$temp1    GR Version  "
		temp2="$temp2 ---------------"
	fi
	
	#------------------
	if (( $sdr_check == 1 ))
	then
		temp1="$temp1     Hardware  "
		temp2="$temp2  -------------"
	fi
			
	#------------------
	if (( $addr_check == 1 ))
	then
		temp1="$temp1     Address  "
		temp2="$temp2  -------------"
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
uname=ucanlab   # default
debug=0
gnuradio_check=0
sdr_check=0
addr_check=0


#-------------------------------------------------------------------
# Get arguments and set appropriate parameters
while getopts 'hl:r:gsau:d' OPTION; do
	case "$OPTION" in
		h)
			help;;
		l)
			IFS=','
			read -ra addresses <<< "$OPTARG"
			;;
		r)
			addresses_range;;			
		g)
			gnuradio_check=1;;
		s)
			sdr_check=1;;
		a)
			addr_check=1;;
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
	echo "  Check GNURadio: $gnuradio_check" 
	echo "  Check Hardware: $sdr_check" 
	echo "  Check Address: $addr_check" 
	echo "  UName: $uname"
	echo ""
	exit
fi

# Call function to setup top row of output
setup_col_titles

# Loop through addresses and get the SSID for each node
for i in "${addresses[@]}"
do

	# Put Pi number in first column
	temp="    $i"
	
	#------------------
	# check for GNURadio Version
	if (( $gnuradio_check == 1 ))
	then
		my_gnuradio=$(ssh $uname@"10.1.1.$i" gnuradio-config-info -v 2> /dev/null || echo "   NA   ")
		temp="$temp     $my_gnuradio"
	fi
	
	#------------------
	# check for connected SDR hardware
	if (( $sdr_check == 1 ))
	then
		# NOTE: The "2> /dev/null" after uhd_find_devices will suppress the info message from uhd 
		my_sdr=$(ssh $uname@"10.1.1.$i" uhd_find_devices 2> /dev/null | grep "name:" | awk '{print $2}')
		temp="$temp      $my_sdr"
	fi

	#------------------
	# check for connected SDR hardware's address
	if (( $addr_check == 1 ))
	then
		# NOTE: The "2> /dev/null" after uhd_find_devices will suppress the info message from uhd 
		my_addr=$(ssh $uname@"10.1.1.$i" uhd_find_devices 2> /dev/null | grep "serial:" | awk '{print $2}')
		temp="$temp        $my_addr"
	fi


	# Print information for each Pi on a single Row
	echo $temp
done

echo "" # Extra line for readability in output




