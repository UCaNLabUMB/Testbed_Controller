#!/bin/bash

##############################################################################################
# client_start.sh
#
# Author: Victoria Planchart
#
# Description: This script starts a number of clients and save the iperf results in a folder in the pis. It will check if the given folder
# 		already exists in the pis. If they don't exist, it will create the folder and store the iperf results there. If the folder exists,
# 		it will display an error message indicating on how many pis the folder exists in, and the iperf test will not run. 
#		It takes the IP address suffix of the pis, the IP address suffix of the server, the duration of the test in seconds, the number
#		of trials to be run and the name of the folder where the results will be saved in the pi. The script will run with the deffault
#		username, in this case "ucanlab", in case of another please specify using its respective flag.
#
# Input: bash client_start.sh -n 3 -i 201 -t 5 -l 5 -f <<folder name>> -s <<< "server address" or
#	 bash client_start.sh -a <<< "103 106 108 112" -i 201 -t 5 -l 5 -f <<folder name>> -s <<< "server address"
#
# **For Help, enter -h**
#
##############################################################################################


#### FUNCTIONS


help()
{
	echo "	-i = input the suffix of the server's IP address. (-a 201 for IP: 192.168.1.201 or 192.168.2.201)"
	echo "	-t = input test duration. (-n 15 will run the test for 15 seconds)"
	echo "	-n = input number of RPis to be run. (-n 3 will start RPis 10.1.1.101, 10.1.1.102, 10.1.1.103 and automatically connect to ports 5201, 5202, 5203)"
	echo "	-a = input <<< followed by the specific addresses to start in double quotation marks separated by a space. (-a <<< \"103 106 108\" ) or, hit enter and then type in the address"
	echo "	-f = input the name of the folder where the results will be saved in the RPis"
	echo "	-u [OPTIONAL] = input client's username if the deffault one (ucanlab) is not used"
	echo "	-s = input server's network address. e.g: 1 for 192.168.1.201 or 2 for 192.168.2.201, (hit enter first, then type either an array (2 1 1 2) or 1 or 2"
	echo "	-l = input number of iterations for the test to run"
}

#setup_server_array()
#{
#	read -a my_input
#	
#	if [ ${#my_input[@]} -eq 1 ]; then # checks if the array equals to 1
#		i=0
#		while [ $i -lt ${#my_address[@]} ]; do
#			my_server_array[$i]=$my_input # assigns the only input value to the array of lentgh N
#			i=$((i + 1))
#		done
#	else
#		my_server_array=("${my_input[@]}") # creates array with more than one value
#	fi
#}

address_single_setup() # takes array from base_address to base_address + 1. e.g if N=3, then 101, 102, 103 clients will start.
{
	N=$OPTARG
	base_address=100
	my_address=($(seq $((base_address+1)) 1 $((base_address+$N))))
}

address_array_setup()
{
	my_address_array=$OPTARG
	
	IFS=' '
	read -ra my_address <<< "$my_address_array"
}

server_array_setup()
{
	setup_server_array=$OPTARG
	
	IFS=' '
	read -ra temp_server_array <<< "$setup_server_array"
}

#### DEFFAULT VALUES

uname=ucanlab

#### SETUP CODE

while getopts 'ht:n:a:i:f:l:u:s:' OPTION; do
	case "$OPTION" in
		h)
			help;;
		t)
			time=$OPTARG;; # takes test durantion in seconds
		n)
			address_single_setup;;
		a)
			address_array_setup;;
		i)
			ip=$OPTARG;; # takes ip suffix, e.g 201
		f)
			folder_name=$OPTARG;;
		l)
			trial=$OPTARG;; # takes number of trials
		u)
			uname=$OPTARG;; # in case the username is not the deffault one, use this flag to user another username
		s)
			server_array_setup;;
	esac
done

#### MAIN CODE

i=0
while [[ $i -lt ${#my_address[@]} ]]; do
	temp_number=$((${my_address[$i]}-100))
	my_ports[$i]=$((5200+$temp_number))
	my_s[$i]=$temp_number
	
	i=$((i + 1))
done

if [ ${#temp_server_array[@]} -eq 1 ]; then # checks if the array equals to 1
	i=0
	while [ $i -lt ${#my_address[@]} ]; do
		my_server_array[$i]=$temp_server_array # assigns the only input value to the array of lentgh N
		i=$((i + 1))
	done
else
	my_server_array=("${temp_server_array[@]}") # creates array with more than one value
fi

i=0
error=0
while [[ $i -lt ${#my_address[@]} ]]; do # loop for number of clients

if ssh $uname@10.1.1.${my_address[$i]} [ ! -d ~/TB_Results/${folder_name}_pi${my_address[$i]} ] # checks if the given directory folder exists in the pis
then
	echo "Directory does not exist in pi ${my_address[$i]}"
	ssh $uname@10.1.1.${my_address[$i]} mkdir -p ~/TB_Results/${folder_name}_pi${my_address[$i]} # if they don't exist, it creates the given directory
	
else
	echo "Directory exists in pi ${my_address[$i]}" # if they exist, the error count goes up by one
	error=$((error + 1))
fi

i=$((i + 1))
done


if [ $error -lt 1 ] # if the error count is zero, then the iperf test in the following loop will be executed
then

x=0
while [[ $x -lt $trial ]] # loop for number of trials
do
	x=$(($x+1))
	i=0
	while [[ $i -lt ${#my_address[@]} ]]; do # loop for number of clients
		ssh $uname@10.1.1.${my_address[$i]}  "iperf3 -c 192.168.${my_server_array[$i]}.$ip -t $time s${my_s[$i]} -p ${my_ports[$i]} > ~/TB_Results/${folder_name}_pi${my_address[$i]}/Results_$x.txt" &	
	i=$((i + 1))
	done
	sleep $time
	sleep 5
done
echo "Test is completed"
# if the error count is greater than zero, the iperf test will not be executed and will display a message indicating how many pis the directory already exists in
else
	echo "Directory exists in $error pis"

fi

