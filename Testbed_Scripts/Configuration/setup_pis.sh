#!/bin/bash
#############################################################################
# Author: Lenny Martinez
#
# Description: Takes one command line input for the last 3 digits of the Pis IP. It then checks tp see if the TB_Results directory exists. If it does then it echos that it exists. If it does not exist then it will tell you it doesnt exist then creates the directory
#
#Input: call the file and add the last 3 digits of the IP address to the command line as a positional argument ie: bash setup_pis.sh 101
#
#############################################################################
	
if ssh $ucanlab@10.1.1.$1 
	[ ! -d ~/TB_Results ] # checks if the given directory folder exists in the pis
then
	echo "Directory does not exist"
	ssh $ucanlab@10.1.1.$1 mkdir ~/TB_Results # if they don't exist, it creates the given directory
else
	echo "Directory exists" # if they exist, the error count goes up by one
fi
