#!/bin/bash

dev=()
if [ -z "$@" ]
then
	
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
	-r) var1="$2"; 
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


