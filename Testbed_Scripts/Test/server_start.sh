#!/bin/bash

#################################################################### 
# server_start.sh
#
# Author: Victoria Planchart
#
# Description: This script takes three flag optinal aarguments: -a for the IP address suffix of the server, -n takes the value N indicating
#		how many ports to start, and -p creates an array <my_ports> from the ports numbers as inputs. Because of the flag options, you can either use -n or -p.
#
# Input: -<flag letter #1> ip suffix -<n> number of ports to be open or -<flag letter #1> ip suffix -<p> specific ports numbers.
# example: bash start_server.sh -a 201 -n 5 / bash start_server.sh -a 201 -p 5202,5206,5208,5212
#
# **For Help, enter -h**
#
####################################################################

#---------------------------------------------------------------------------------------------

help()
{
	echo "	-a = input the suffix of the IP address. (-a 201 for IP: 10.1.1.201)"
	echo "	-n = input how many ports to start beginning at 5201 by default. (-n 3 will start ports 5201, 5202 and 5203)"
	echo "	-p = input specific ports to start. (-p 5202,5205,5208,5210,5214 )"
	echo "	-u [OPTIONAL] = input the username of the pi"
	exit
}

#---------------------------------------------------------------------------------------------
# takes array from base_port to base_port + 1. e.g if N=3, then ports 5201, 5202 and 5303 will be started.
server() 
{
	counter=1
	N=$OPTARG
	base_port=5200
	my_ports=($(seq $(($base_port+1)) 1 $(($base_port+$N))))
}

#---------------------------------------------------------------------------------------------
# creates array from command line. If the inputs entered are 5204,5208,5210 then it will only start those clients.
server2() 
{
	IFS=','
	read -ra my_ports <<< "$OPTARG"
}


#---------------------------------------------------------------------------------------------
# Set default parameters

uname=ucanlab # default

#---------------------------------------------------------------------------------------------
# Get arguments and set appropriate parameters

while getopts 'ha:n:p:u' OPTION; do
	case "$OPTION" in
		h)
			help;;
		a)
			ip=$OPTARG;;
		n)
			server;;
		p)
			server2;;
		u)
			uname=$OPTARG;;
	esac
done


#############################
#####     Main Code     #####
#############################
#---------------------------------------------------------------------------------------------

i=0
while [ $i -lt ${#my_ports[@]} ]; do # loop for number of ports
	ssh $uname@10.1.1.$ip iperf3 -s -p ${my_ports[$i]} &
	i=$((i + 1))
done
