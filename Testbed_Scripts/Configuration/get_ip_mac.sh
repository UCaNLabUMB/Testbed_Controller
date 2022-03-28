#!/bin/bash


if [ -z "$@" ]
then
	
echo "Naming convention is 10.1.1.x"
echo "Input each corresponding ip to obtain the IP and MAC Address of Pi"
echo "i.e., for devices 10.1.1.101 to 10.1.1.104, input 101 102 103 104"
read -a ip
echo ${ip[@]}
for i in "${ip[@]}"
do
	echo "IP Address:"
	ssh pi@"10.1.1.$i" ifconfig wlan0 | grep "inet" | grep "broadcast" | awk '{print $2}'
	echo "MAC Address:"
	ssh pi@"10.1.1.$i" ifconfig wlan0 | grep "ether" | grep "txqueuelen" | awk '{print $2}'
done

else

while [ "$#" -gt 0 ];
do
case "$1" in 
	-r) var1="$2"; 
	var2="$3";
	i=$var1
	for (( i=$var1; i<=$var2; i++ ))
	do
	echo "IP Address:"
	ssh pi@"10.1.1.$i" ifconfig wlan0 | grep "inet" | grep "broadcast" | awk '{print $2}'
	echo "MAC Address:"
	ssh pi@"10.1.1.$i" ifconfig wlan0 | grep "ether" | grep "txqueuelen" | awk '{print $2}'
	done
	;;
	-l) new=( "$@" )
	echo ${new[@]}
	for (( i=1; i<=${#new[@]}-1; i++))
	do
	i2=$i+1
	echo "IP Address:"
	ssh pi@"10.1.1.${new[i]}" ifconfig wlan0 | grep "inet" | grep "broadcast" | awk '{print $2}'
	echo "MAC Address:"
	ssh pi@"10.1.1.${new[i]}" ifconfig wlan0 | grep "ether" | grep "txqueuelen" | awk '{print $2}'
	done
	;;
esac
break
done
fi


