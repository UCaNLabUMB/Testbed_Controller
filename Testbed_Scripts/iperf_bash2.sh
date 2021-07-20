#!/bin/bash

function run_tests {

# Variables
ip_server="192.168.1.200"
ip_server2="192.168.2.200"
base_port=5000
ip_prefix="10.1.1"
trial=$1
dur=$2

# List of available IP
num=({107..110})
num2=({101..104})

# Type of iperf
type="-c"

# Iperf test for loop with number of tets and types
#ssh pi@$ip_server screen -d -m iperf -s
counter=0
counter1=0
counter2=0
counter3=0
counter4=0
until [[ $counter -ge $trial ]]
do
	((counter++))
	echo "No Devices Offloaded"
	echo "This is trial " $counter
	for i in "${num[@]}"; do
		server_port=$(($base_port+$i));
		sshpass -p muffin ssh pi@"$ip_prefix.$i" iperf $type $ip_server -t $dur | awk 'END{print $7","}'>> $ip_prefix.$i.csv &
	done
	for j in "${num2[@]}"; do
		server_port=$(($base_port+$j));
		sshpass -p lightcomms5556 ssh pi@"$ip_prefix.$j" iperf $type $ip_server2 -t $dur | awk 'END{print $7","}'>> $ip_prefix.$j.csv &
	done
	sleep $dur
		
done

num2=({101..103})
until [ $counter1 -ge $trial ]
do
	((counter1++))
	echo "1 Device Offloaded"
	echo "This is trial " $counter1
	for i in "${num[@]}"; do
		server_port=$(($base_port+$i));
		sshpass -p muffin ssh pi@"$ip_prefix.$i" iperf $type $ip_server -t $dur | awk 'END{print $7","}'>> $ip_prefix.$i.1.csv &
	done
	for j in "${num2[@]}"; do
		server_port=$(($base_port+$j));
		sshpass -p lightcomms5556 ssh pi@"$ip_prefix.$j" iperf $type $ip_server2 -t $dur | awk 'END{print $7","}'>> $ip_prefix.$j.1.csv &
	done
	sleep $dur
		
done

num2=({101..102})
until [ $counter2 -ge $trial ]
do
	((counter2++))
	echo "2 Devices Offloaded"
	echo "This is trial " $counter2
	for i in "${num[@]}"; do
		server_port=$(($base_port+$i));
		sshpass -p muffin ssh pi@"$ip_prefix.$i" iperf $type $ip_server -t $dur | awk 'END{print $7","}'>> $ip_prefix.$i.2.csv &
	done
	for j in "${num2[@]}"; do
		server_port=$(($base_port+$j));
		sshpass -p lightcomms5556 ssh pi@"$ip_prefix.$j" iperf $type $ip_server2 -t $dur | awk 'END{print $7","}'>> $ip_prefix.$j.2.csv &
	done
	sleep $dur
		
done

num3=101
until [ $counter3 -ge $trial ]
do
	echo "3 Devices Offloaded"
	((counter3++))
	echo "This is trial " $counter3
	for i in "${num[@]}"; do
		server_port=$(($base_port+$i));
		sshpass -p muffin ssh pi@"$ip_prefix.$i" iperf $type $ip_server -t $dur | awk 'END{print $7","}'>> $ip_prefix.$i.3.csv &
	done
	for j in {101}; do
		server_port=$(($base_port+$num3));
		sshpass -p lightcomms5556 ssh pi@"$ip_prefix.$num3" iperf $type $ip_server2 -t $dur | awk 'END{print $7","}'>> $ip_prefix.$num3.3.csv &
	done
	sleep $dur
		
done


until [ $counter4 -ge $trial ]
do
	echo "4 Devices Offloaded"
	((counter4++))
	echo "This is trial " $counter4
	for i in "${num[@]}"; do
		server_port=$(($base_port+$i));
		sshpass -p muffin ssh pi@"$ip_prefix.$i" iperf $type $ip_server -t $dur | awk 'END{print $7","}'>> $ip_prefix.$i.4.csv &
	done	
	sleep $dur
done


echo "Test is finished"
}

if [ -z "$@" ] 
then

echo "Please enter the number of trials and duration (in seconds) seperated by a space for this test."
echo "Syntax: trials duration --> 1 2"
read -a input
echo ${input[@]}
run_tests ${input[0]} ${input[1]}

else

while [ ! $# -eq 0 ]
do
	case "$1" in 
		-d) if [[ $3 == "-t" ]]; then
			dur=$2
			trial=$4
			echo $trial
			echo $dur
			run_tests $trial $dur
			
		else
			dur=$2
			trial=1
			echo $trial
			echo $dur
			run_tests $trial $dur
			
		fi
		exit;;
		
		-t) if [[ $3 == "-d" ]]; then
			trial=$2
			dur=$4
			echo $trial
			echo $dur
			run_tests $trial $dur
			
		else
			trial=$2
			dur=10
			echo $trial
			echo $dur
			run_tests $trial $dur
		fi
		exit;;
	esac
done


fi




