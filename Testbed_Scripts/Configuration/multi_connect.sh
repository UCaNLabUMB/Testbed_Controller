#!/bin/bash

read -p "SSID: " uservar
read -p "Password: " passvar 
var=(107 108 109 110)

for n in {1}
do
    for ip in "${var[@]}"
    do
	gnome-terminal --command "ssh pi@10.1.1.$ip bash A_TO_C.sh $uservar $passvar"
    done
    sleep 5
	
done
