#!/bin/bash

# This script is meant to check the status of all the nodes in our system (whether or not they are connected to the control network) 

dev=()
if [ -z "$@" ]
then

# This section is mean to run with no arguments in the Testbed Controllers terminal. Once the script is run, it will ask for the user to input the nodes to 
# check the status of
echo "Naming convention is 10.1.1.x"
echo "Input each corresponding ip to be pinged"
echo "i.e., for devices 10.1.1.101 to 10.1.1.104, input 101 102 103 104"
read -a ip
echo ${ip[@]}
for i in "${ip[@]}"
do
	ping -c 1 -W 0.1 "10.1.1.$i" > /dev/null
	if [ $? -eq 0 ]; then
	echo "10.1.1.$i is up"
	dev[${#dev[@]}]=1
	else 
	echo "10.1.1.$i is down"
	fi
done

else

while [ "$#" -gt 0 ];
do
case "$1" in 
	# In order to check the status of the nodes in our system, run this command with the flag -r and the maximum and minumum values of 
	# the node range. Ex: For nodes 101 through 106, run "bash get_ip.sh -r 101 for 106"-r) var1="$2"; 
	var2="$3";
	i=$var1
	for (( i=$var1; i<=$var2; i++ ))
	do
	ping -c 1 -W 0.1 "10.1.1.$i" > /dev/null
	if [ $? -eq 0 ]; then
	echo "10.1.1.$i is up"
	else 
	echo "10.1.1.$i is down"
	fi
	done
	;;
	# In order to check the status of the an individual node in our system , run this command with the flag -l and the the specific node
	# value. Ex: For node 101, run "bash get_ap.sh -l 101"
	-l) new=( "$@" )
	echo ${new[@]}
	for (( i=1; i<=${#new[@]}-1; i++))
	do
	i2=$i+1
	ping -c 1 -W 0.1 "10.1.1.${new[i]}" > /dev/null
	if [ $? -eq 0 ]; then
	echo "10.1.1.${new[i]} is up"
	else 
	echo "10.1.1.${new[i]} is down"
	fi
	done
	;;
esac
break
done
fi


