# Assigning a Static IP Address on Windows
Once you are ready to use your central computer as a Testbed Controller, you will need to assign its own ethernet static IP address in order to coomunicate and SSH into Pi's on the same subnet. The following steps show how to assing this address in a Windows operating system:
*  Go to settings 
*  Select "Network and Internet"
*  There should be a new list of tabs to select from in "Network and Internet". Select "Ethernet" 
*  The next steps will accomodate those with an ethernet cable jack and an ethernet-usb adapter. 
## Ethernet-USB Adapter
* Select "Change Adapter Options"
* A new window will appear that displays all of the available interfaces. The ethernet adapter will have an interface identity such as "Ethernet n" where n is any integer besides 0. Select this network
* A new window will open that is labeled "Ethernet n Status". Select "Properties"
* A new window will open that is labeled "Ethernet n Properties" Double-click "Internet Protocol Version 4 (TCP/IPv4)"
* For the IP address, make sure it is `10.1.1.100` and that the subnet is `255.255.255.0`
* Once complete, select "OK"
* Reboot your computer 

