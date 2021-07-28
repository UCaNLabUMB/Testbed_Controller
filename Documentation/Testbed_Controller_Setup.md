# Getting Started 
## Setting up the Linux Terminal 
Open the 'Settings' window and select 'Update and Security'.
Go to the 'For Developers' tab. From here, select 'Enable Developer Mode'. 
Once that is all set, go to 'Control Panel'. Select the 'Programs' tab. Select 'Turn Windows Feature On or Off'. Once that is open, scroll down until you see the option 'Windows Subsystem for Linux' and enable it. 
Press 'OK'. Then, you will be prompted to reboot your system. 

Once the system is rebooted, we need a Linux distribution system in order to perform the Testbed scripts provided in this repository. Open the Windows Store and search for Ubuntu and download the application. A link is also provided https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6?activetab=pivot:overviewtab 

Upon launching the Linux terminal for the first time, it will finsih the installation process. Once complete, the Window will ask for a new UNIX username and password. Once the username and password are setup, close this terminal. 
## Working with Git
https://git-scm.com/download/win This link will take you to the download page for installing Git onto your Windows system. Select the version that corresponds to your operating system (32 bit or 64 bit). We will be using the default setup for Git, so you can select follow the default installation process on the installation wizard. 
Once Git has been installed, we will now download Tortoise Git as a user interface to perform our Git commands. https://tortoisegit.org/download/. Select the version that corresponds to your operating system (32 bit or 64 bit). You can select follow the default installation process on the installation wizard. Once the installation is complete, you will be prompted to start the "First Start Wizard" where you will be prompted to put in your Git username and email. Selecting 'Next' will complete the setup  

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
Now that all of the Raspberry Pi's and Testbed Controller are able to communicate with each other, we can run through the bash scripts that are needed perform the full function of the Testbed. These bash scripts can be found in the `Testbed_Scripts` folder of this repository:
* Scan the available devices on our control network with `check_ip.sh` in the `Configuration` folder 
* Assign a group of Raspberry Pi's on the control network to a service set that is specified by user input with `multi_connect.sh` in the `Configuration` folder
* Loop through each Pi to retrieve the name of the Access Point that it is connected to in order to make sure the Test Network is configured correctly with `ap_connected_devices.sh` in the `Configuration` folder
* Specify the duration and number of trials before running the performance test on each service set with `iperf_bash2.sh` in the `Test` folder
