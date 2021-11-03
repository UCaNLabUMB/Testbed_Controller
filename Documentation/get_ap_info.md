# Getting the Connected Access Point (get_ap.sh)

This script is used to determine which Access Point a selected Pi is connected to. The script can take in a range of ip addresses, given that it has the prefix "10.1.1.x" (x is the ip from arguments)
The flags are as follows:
* -r <val1> <val2>

This flag takes in two integer arguments. The first value is the starting range and the second is the last value in the range. The output will print the SSID of the Access Point it is connected to.

* -i <val1>

This flag is for getting Access Point information for a single Pi. 

