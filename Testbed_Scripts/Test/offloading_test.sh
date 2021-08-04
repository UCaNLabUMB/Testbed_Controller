#!/bin/bash

function run_tests {

# Variables
ip_server="192.168.1.229"
ip_server2="192.168.2.200"
base_port=5000
ip_prefix="10.1.1"
trial=$1
dur=$2
r1=$3
r2=$4

# List of available IP
declare -a num
for (( i=$r1; i<=$r2; i++ ))
do
num+=($i)
done
echo ${num[@]}

# Type of iperf
type="-c"

# Iperf test for loop with number of tets and types
#ssh pi@$ip_server screen -d -m iperf -s

until [[ $counter -ge $trial ]]
do
	((counter++))
	echo "This is trial " $counter
	for i in "${num[@]}"; do
		sshpass -p lightcomms5556 ssh pi@"$ip_prefix.$i" iperf $type $ip_server -t $dur | awk 'END{print $7","}'>> $ip_prefix.$i.csv &
	done
	sleep $dur
done
echo "Test is finished"
}

if [[ -z "$@" ]] 
then

echo "Please enter the number of trials, duration (in seconds), range minimum and range maximum seperated by a space for this test."
echo "Syntax: trials duration range1 range2--> 1 2 101 104"
read -a input
echo ${input[@]}
run_tests ${input[0]} ${input[1]} ${input[2]} ${input[3]}

else
trial=0
dur=0
r1=0
r2=0
while getopts ":d:t:s:i:r:" options; do
	case "${options}" in 
		d ) dur=${OPTARG}
			echo $dur
			;;
                s ) set -f
                    IFS=' '
            	    ip=($OPTARG)

		t ) trial=${OPTARG}
			echo $trial
			;;
		
		r ) set -f
            	    IFS=' '
            	    array=($OPTARG)
            	    r1=${array[0]} 
            	    r2=${array[1]}
		    echo ${array[@]}
            	    declare -a narr
            	    for (( i=$r1; i<=$r2; i++ ))
            	    do
            	    	narr+=($i)
            	    done
            	    echo $r1
            	    echo $r2
            
           	    ;;
       	        i ) set -f
                    IFS=' '
            	    narr=($OPTARG)
            	    echo ${narr[@]}
            	    ;;
	esac
done

#run_tests $trial $dur $narr[@] $r2
fi
shift $((OPTIND -1))





