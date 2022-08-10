#!/bin/bash

##############################################################################################
# client_start.sh
#
# Author: Victoria Planchart
#
# Description: This script starts a number of clients and save the iperf results in a folder in the RPis. It will check if the given folder
# 		already exists in the RPis; if they don't exist, it will create the folder and store the iperf results. If the folder exists,
# 		it will display an error message indicating on how many RPis the folder exists in, and the iperf test will not run. 
#		It takes the IP address suffix of the RPis, the IP address suffix of the server, the duration of the test in seconds, the number
#		of trials to be run and the name of the folder where the results will be saved in the RPpi. The script will run with the deffault
#		username, in this case "ucanlab"; if using a different username, please specify using its respective flag -u.
#
# Input: bash client_start.sh -n 3 -i 201 -t 5 -l 5 -f <folder name> -s "server address" or
#	 bash client_start.sh -a "103 106 108 112" -i 201 -t 5 -l 5 -f <folder name> -s "server address"
#
# **For Help, enter -h**
#
##############################################################################################

#---------------------------------------------------------------------------------------------

help()
{
	echo "	-i = input the suffix of the server's IP address. (-a 201 for IP: 192.168.1.201 or 192.168.2.201)"
	echo "	-t = input test duration. (-n 15 will run the test for 15 seconds)"
	echo "	-n = input number of RPis to be run. (-n 3 will start RPis 10.1.1.101, 10.1.1.102, 10.1.1.103 and automatically connect to ports 5201, 5202, 5203)"
	echo "	-a = input specific addresses to start. (-a \"103 106 108\" )"
	echo "	-f = input the name of the folder where the results will be saved in the RPis"
	echo "	-u [OPTIONAL] = input client's username if the deffault one (ucanlab) is not used"
	echo "	-s = input server's network address. e.g: 1 for 192.168.1.201 or 2 for 192.168.2.201, (-s \"2 1 1 2\" or -s 1 or -s 2"
	echo "	-l = input number of iterations for the test to run"
	exit
}

#---------------------------------------------------------------------------------------------
# takes array from base_address to base_address + 1. e.g if N=3, then 101, 102, 103 clients will start.
address_single_setup() 
{
	N=$OPTARG
	base_address=100
	my_address=($(seq $((base_address+1)) 1 $((base_address+$N))))
}

#---------------------------------------------------------------------------------------------
# reads "my_address_array", remove the blank spaces and creates a new "my_addess" array.
address_array_setup()
{
	my_address_array=$OPTARG
	
	IFS=' '
	read -ra my_address <<< "$my_address_array"
}

#---------------------------------------------------------------------------------------------
# reads "setup_server_array", remove the blank spaces and creates a new "temp_server_array" array.
server_array_setup()
{
	setup_server_array=$OPTARG
	
	IFS=' '
	read -ra temp_server_array <<< "$setup_server_array"
}


#---------------------------------------------------------------------------------------------
# Set default parameters

uname=ucanlab # default

#---------------------------------------------------------------------------------------------
# Get arguments and set appropriate parameters

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
			uname=$OPTARG;; # in case the username is not the default one, use this flag to user another username
		s)
			server_array_setup;;
	esac
done

#-------------------------------------------------------------------

# while loop creates values for temp_number by subtracting 100 from the entered IP (103 106 112 will create values 3 6 12)
# creates values for my_ports by adding 5200 and the temp_number. my_s values will equal temp_number values.
i=0
while [[ $i -lt ${#my_address[@]} ]]; do
	temp_number=$((${my_address[$i]}-100))
	my_ports[$i]=$((5200+$temp_number))
	my_s[$i]=$temp_number	
	i=$((i + 1))
done

#-------------------------------------------------------------------

# if statement checks if the array length equals to 1
if [ ${#temp_server_array[@]} -eq 1 ]; then
	i=0
	# if the array length is 1, it assigns the only value to the array of lentgh $my_address
	while [ $i -lt ${#my_address[@]} ]; do 
		my_server_array[$i]=$temp_server_array
		i=$((i + 1))
	done
else
	# if the array length is more than 1, it creates the array with more than one value.
	my_server_array=("${temp_server_array[@]}")
fi


#############################
#####     Main Code     #####
#############################
#-------------------------------------------------------------------

i=0
error=0
while [[ $i -lt ${#my_address[@]} ]]; do # loop through number of clients

# checks if the given directory folder exists in the client nodes
if ssh $uname@10.1.1.${my_address[$i]} [ ! -d ~/TB_Results/${folder_name}_pi${my_address[$i]} ] 
then
	echo "Directory does not exist in pi ${my_address[$i]}"
	# if it does not exist, it creates the given directory
	ssh $uname@10.1.1.${my_address[$i]} mkdir -p ~/TB_Results/${folder_name}_pi${my_address[$i]} 
else
	echo "Directory exists in pi ${my_address[$i]}"
	# if it exists, the error count goes up by one
	error=$((error + 1))
fi
i=$((i + 1))
done


# if statement will check if the error count is zero
if [ $error -lt 1 ] # if it's zero, the test in the while loop will run
then

x=0
while [[ $x -lt $trial ]] # loop through number of trials
do
	x=$(($x+1))
	i=0
	while [[ $i -lt ${#my_address[@]} ]]; do # loop through number of clients
		# ssh in the client nodes, start the clients and run the test
		ssh $uname@10.1.1.${my_address[$i]}  "iperf3 -c 192.168.${my_server_array[$i]}.$ip -t $time s${my_s[$i]} -p ${my_ports[$i]} > ~/TB_Results/${folder_name}_pi${my_address[$i]}/Results_$x.txt" &	
	i=$((i + 1))
	done
	sleep $time
	sleep 5
done
echo "Test is completed"
# if the error count is greater than zero, the iperf test will not be executed.
else
	echo "Directory exists in $error pis"
fi

