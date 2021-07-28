#!/bin/bash

var={$1..$2}
for ip in $(seq $1 $2); do
	ssh pi@10.1.1.$ip bash A_TO_C.sh $3 $4 && exit
done
exit

	

