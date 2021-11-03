# Verifying Connection Status of Each Pi on the Control Network (get_ip.sh)
Before we begin testing, it is important that we check if we are able to communicate with all devices on our local access network (LAN). To do this, we can create a script which takes in the last three digits of an IP address (assuming that we are working with the subnet 255.255.255.0). The IP convention for this testbed is 10.1.1.x, with ranging from the values 0 to 255, so the IP prefix for this script will be 10.1.1.  

 

To begin, we must first connect each device to a LAN with the use of a switch. Each device must be set to the IP convention and subnet mentioned above  (10.1.1.x and 255.255.255.0). Some devices may not have the option to input a subnet mask such as the Raspberry Pi, so another way of creating a subnet would be to type "/24" at the end of the IP address (i.e., 10.1.1.5/24).  

 

The name of the bash script we will be using is "check_ip.sh," which will be run in the terminal. The functionality of this script is as follows: 

 

This script uses two flag parameters, which are –r and –l. 

*-r: This flag parameter allows the user to input a range of addresses to be checked. For example, if we had 10 devices, ranging from 10.1.1.1 to 10.1.1.10, the command to check this range using this flag would be "bash check_ip.sh -r 1 10" 

*-l: This flag parameter allows the user to create a list of individual IP addresses to be checked. For example, if we wanted to check the addresses 10.1.1.1, 10.1.1.4, 10.1.1.7, and 10.1.1.9, we'd use the following command: "bash check_ip.sh -l 1 4 7 9" 

Note: If no flag is set upon running the bash script, the script will default to checking individual IP addresses, prompting the user to input individual IP addresses. 

 

When this script is run given the commands above, it pings each device and determines whether we are able to establish a connection to the selected device. If we are able to establish a connection with the devices, it outputs a message stating that the device is up (I.e., 10.1.1.1 is up). If not, then it outputs the message, "10.1.1.1 is down." 

 