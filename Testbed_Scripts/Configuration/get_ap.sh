#!/bin/bash

id_prefix=10.1.1.

echo "Scanning first network" 
for i in "{109}"
    ssh pi@"$id_prefix.$i" sudo arp-scan --interface=wlan0 --localnet
done
echo "Scanning second network"
 for j in "{101}"
    ssh pi@"$id_prefix.$j" sudo arp-scan --interface=wlan0 --localnet
done
