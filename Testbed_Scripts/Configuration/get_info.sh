#!/bin/bash

while getopts ":a:os:ram:memory:" options; do
	case "${options}" in 
		a ) ip=${OPTARG}
		    echo $ip
		    ip_full="10.1.1.$ip"
		    echo $ip_full
			;;
                os ) cat /etc/os-release
		    ;;	

		ram ) free -m
			;;
		
		memory ) df -h
           	    ;;
	esac
done

