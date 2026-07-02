#!/bin/bash
#############################################################################
# Author: MR
#
# Description: This script shuts down the sdr flowgraph of a desired set of nodes
#              
#
# Input: 
#
# **For Help, enter -h**
#
#############################################################################
#	
#############################
#####     Functions     #####
#############################
#-------------------------------------------------------------------



############################
#######     NOTE     #######
############################
#-------------------------------------------------------------------
# Make sure to modify the shutdown_flag function inside the .py file from the .grc file with the same name
# basically include another variable block called 'shutdown_flag' and initialize it to 0 when we save the grc file 
# There will be a copy version of the .py file, from which we can modify the function from the block just included. # The script # to modify is pasted below:
# ```
#  def get_shutdown_flag(self):
#        return self.shutdown_flag
#
#    def set_shutdown_flag(self, shutdown_flag):
#       self.shutdown_flag = shutdown_flag
#
#        def stop_thread():
#            self.stop()
#            self.wait()
#            sys.exit(0)
#
#        if shutdown_flag:
#            threading.Thread(target=stop_thread).start()
#
#        return True
#```

help()
{
	echo ""
	echo "	### Bash script for shutting down the nodes' flowgraph ###"
	echo "	---------------------------------------------------------------------------------------"
	echo "	-l = list of testbed node addresses (e.g., 'bash sdr_tx_stop.sh -l 103,105,109')"
	echo "	-r = range of testbed node addresses (e.g., 'bash sdr_tx_stop.sh -r 103,107')"
	echo "  -t = time delay or sleep for the flow graph (e.g., 'bash sdr_tx_stop.sh -t 1) (default: 2)" 
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
delay=2
debug=0

#-------------------------------------------------------------------
# Get arguments and set appropriate parameters

while getopts 'hl:r:t:u:d' OPTION; do
	case "$OPTION" in
		h)
			help;;
		l)
			addresses_list;;
		r)
			addresses_range;;
		t) 
			delay=$OPTARG;;
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
	echo "  Delay: $delay"
	echo "  UName: $uname"
	echo ""
	exit
fi

# Main code to shut down desired RPis
#-------------------------------------------------------------------

# Loop through and setup Pis
for i in "${addresses[@]}"
do
	echo " Shutting down flowgraph on Node $i"
	python3 SDR_control/set_remote_tx_stop.py -n $i -t $delay
	sleep 1  

done


