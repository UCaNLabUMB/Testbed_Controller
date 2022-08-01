#!/bin/bash

# Th nodes in this sytem will have two connections to two separate networks (ethernet switch and Wi-Fi). This script will communicate with the nodes via ethenet connection
# and will obtain the SSID of the access point that it is connected to before proper tests are started 

if [ -z "$@" ]
then
# This section is mean to run with no arguments in the Testbed Controllers terminal. Once the script is run, it will ask for the user to input the nodes to 
# check the SSID of their access points 	
echo "Naming convention is 10.1.1.x"
echo "Input each corresponding ip to obtain available SSIDs"
echo "i.e., for devices 10.1.1.101 to 10.1.1.104, input 101 102 103 104"
read -a ip
echo ${ip[@]}
for i in "${ip[@]}"
do
	ssh pi@"10.1.1.$i" nmcli dev wifi
done

else

while [ "$#" -gt 0 ];
do
case "$1" in 
	# In order to check the SSID's of a large group of our nodes, run this command with the flag -r and the maximum and minumum values of 
	# the node range. Ex: For nodes 101 through 106, run "bash get_ssid.sh -r 101 for 106"-r) var1="$2";
	-r) var1="$2"; 
	var2="$3";
	i=$var1
	for (( i=$var1; i<=$var2; i++ ))
	do
	ssh pi@"10.1.1.$i" nmcli dev wifi
	done
	;;
	# In order to check the SSID's of the an individual node in our system , run this command with the flag -l and the the specific node
	# value. Ex: For node 101, run "bash get_ap.sh -l 101" 
	-l) new=( "$@" )
	echo ${new[@]}
	for (( i=1; i<=${#new[@]}-1; i++))
	do
	i2=$i+1
	ssh pi@"10.1.1.${new[i]}" nmcli dev wifi
	done
	;;
esac
break
done
fi


