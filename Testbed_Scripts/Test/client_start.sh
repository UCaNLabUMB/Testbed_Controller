#!/bin/bash

#################################################################### 
# client_start.sh
#
# Author: Victoria Planchart
#
# Description: This script starts a number of clients and save the iperf results in a folder in the pis. It takes the IP address suffix of the pis,
#		the IP address suffix of the server, the duration of the test in seconds and the number of trials to be run.
#
# Input: bash client_start.sh -n 3 -i 201 -t 5 -l 5
#
# **For Help, enter -h**
#
####################################################################

help()
{
	echo "	-i = input the suffix of the IP address. (-a 201 for IP: 192.168.1.201)"
	echo "	-t = input test duration. (-n 15 will run the test for 15 seconds)"
	echo "	-n = input number of pis to be run. (-n 3 will open pis 10.1.1.101, 10.1.1.102, 10.1.1.103. Also, ports numbers 5201, 5202, 5203)"
	echo "	-a = input <<< followed by the specific addresses to start in double quotation marks separated by a space. (-p <<< \"103 106 108\" )"
}

address() # takes array from base_address to base_address + 1. e.g if N=3, then 101, 102, 103 clients will start.
{
	N=$OPTARG
	base_address=100
	my_address=($(seq $(($base_address+1)) 1 $(($base_address+$N))))
	base_server=5200
	my_ports=($(seq $(($base_server+1)) 1 $(($base_server+$N))))
	base_s=0
	my_s=($(seq $(($base_s+1)) 1 $(($base_s+$N))))
	
}

address2() # creates array from command line. If the inputs entered are <<< "102, 104, 106", then it will only start those clients.
{
	read -a my_address
}

while getopts 'ht:n:a:i:f:l:' OPTION; do
	case "$OPTION" in
		h)
			help;;
		t)
			time=$OPTARG;; # takes test durantion in seconds.
		n)
			address;;
		a)
			address2;;
		i)
			ip=$OPTARG;; # takes ip suffix, e.g 201
#		f)
#			folder_name=$OPTARG;;
		l)
			trial=$OPTARG;; # takes number of trials

	esac
done

x=0
while [[ $x -lt $trial ]] # loop for number of trials
do
	x=$(($x+1))
	i=0
	while [[ $i -lt ${#my_address[@]} ]]; do # loop for number of clients
		ssh ucanlab@10.1.1.${my_address[$i]}  "iperf3 -c 192.168.1.$ip -t $time s${my_s[$i]} -p ${my_ports[$i]} > ~/TB_Results/R_$x.txt" &
	i=$((i + 1))
	done
	sleep $time
	sleep 5
done
echo "Test is completed"
