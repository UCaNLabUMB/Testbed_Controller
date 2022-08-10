#!/bin/bash

#####################################################################################
# transfer.sh
#
# Author: Victoria Planchart
#
# Description: This script transfers iperf results files from the RPis to the TC.
#		It can take a range of clients from 101 to N, or specific number of clients.
#
# Input: for range: bash transfer.sh -a 103 -f 3 -t <folder name>
#        specific: bash transfer.sh -n -g -t <folder name>, enter, and then enter the values
#
#####################################################################################

#------------------------------------------------------------------------------------

help()
{
	echo "-a = input the number of RPis to transfer from. (-a 3 will transfer from RPis 101, 102 and 103)"
	echo "-n = input the suffix of the IP address to transfer from. (-n enter, then 102 104 106 108 110)"
	echo "-f = input the folder name in the pi to be transferred"
}

#------------------------------------------------------------------------------------
address()
{
	N=$OPTARG
	base_port=100
	pis=($(seq $(($base_port+1)) 1 $(($base_port+$N))))
}

#------------------------------------------------------------------------------------
address2()
{
	read -a pis
}


#---------------------------------------------------------------------------------------------
# Set default parameters

uname=ucanlab # default

#------------------------------------------------------------------------------------
# Get arguments and set appropriate parameters

while getopts 'ha:nf:u' OPTION; do
	case "$OPTION" in
		h)
			help;;
		a)
			address;;
		n)
			address2;;
		f)
			folder_name=$OPTARG;;
		u)
			uname=$OPTARG;;
	esac
done


#############################
#####     Main Code     #####
#############################
#------------------------------------------------------------------------------------


mkdir  ~/TB_Results/${folder_name}

i=0
while [ $i -lt ${#pis[@]} ]; do
	scp -pr $uname@10.1.1.${pis[$i]}:~/TB_Results/${folder_name}_pi${pis[$i]} ~/TB_Results/${folder_name}
	i=$((i + 1))
done
