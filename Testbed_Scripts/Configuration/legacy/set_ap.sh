#!/bin/bash

# This script is meant to take 3 user inputs (minumum value node, maximum value node, SSID and SSID password). It will select the specified raange of nodes connect them
# to the access point that is specified by the SSID and SSID password. The script should be run as follows: 
# "bash set_ap.sh minimum_node_value maximum_node_value SSID SSID_password"
var={$1..$2}
for ip in $(seq $1 $2); do
	ssh pi@10.1.1.$ip bash A_TO_C.sh $3 $4 && exit
done
exit

	

