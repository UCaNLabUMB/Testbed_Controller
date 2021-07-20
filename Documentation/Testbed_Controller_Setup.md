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

# Passwordless SSH for Windows 
In your windows command prompt, navigate to the ssh folder with `cd ~\.ssh`. Run `ssh-keygen` to generate an ssh key and press `Enter` to save it to the default file. Load the private key into `ssh-agent` so it can retreive the private key and pass it onto any ssh client when required.

`ssh-add ~\.ssh\id_rsa`

Use `scp` in order to copy the public key over the default file that was specified by `ssh-keygen`:

`scp id_rsa.pub pi@staticip:~\.ssh\authorized_keys` where `staticip` is the static ethernet IP address you specified before. 

In order to check and see if the SSH function is truly passwordless, try SSHing into that same Raspberry Pi with the command `ssh pi@staticip` it should bring you to the Raspberry Pi's terminal without asking for a password.

Repeat this process for the reamaining `staticip`'s on the Testbed network. 

# Core Functionality 
Now that all of the Raspberry Pi's and Testbed Controller are able to communicate with each other, we can run through the bash scripts that are needed perform the full function of the Testbed. These bash scripts can be found in the 
* Scan the available devices on our control network 
