#!/bin/bash

read -p "First Pi: " firstpi
read -p "Last Pi: " lastpi
read -p "SSID: " uservar
read -p "Password: " passvar 
var=(107 108 109 110)


for (( ip=$firstip; ip<=$lastpi; ip++ ))
do
	gnome-terminal --command "ssh pi@10.1.1.$ip bash A_TO_C.sh $uservar $passvar"
done

	

