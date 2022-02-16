# Downloading the Operating System
Once you are ready to set up a Raspberry Pi, you will need to secure a few things:
* Raspberry Pi
* Power Supply 
* microSD card reader for computer
* Raspberry Pi Imager https://www.raspberrypi.org/software/ 

After installation, plug the microSD card reader into your computer with the microSD card in it. Run the Raspberry Pi Imager and make the following selections:

![](/images/rpi_imager.png)

* For 'Choose OS': We will be using Raspbian PI OS 32-bit for the rest of this repository 
* For 'Choose Storage': Select the storage option that applies to your microSD card reader 
* Press Ctrl + Shift + X 
  * Select 'Enable SSH'
  *  Select 'Use Password Authentication' and verify the password if you want to SSH into these Pi's later on rather than a monitor 
  *  Since we want to start installing modules once we start our Raspberry Pi, select 'Configure WiFi
    * Write the SSID and Password of the Access Point you would like to connect to (must have an internet connection for module installations)
  * Select the correct 'Time Locale Settings'
  * There is no need to edit 'Persistent Settings' 
* Exit this window and Press 'Write' 

# Modules 
Now that the Operating System is installed, put your microSD card into the slot of the Raspberry Pi. If you are using a monitor, hook up the HDMI cable with a mouse and keyboard to the Raspberry Pi. Otherwise, make sure your computer is on the same WiFi network as the one you specified for the Raspberry Pi and go to the command line of your computer and type
`ssh pi@raspberrypi` where 'raspberrypi' is the hostname of the Raspberry Pi which was congiured in the Raspberry Pi imager. Enter the SSH password you set earlier once you are asked. 

You are now in the terminal of the Raspberry Pi which can also be accomplished through a monitor. The terminal is vital for the rest of this devices setup and you can download the required modules for this testbed. We will need iPerf, hostapd and dnsmasq which can be installed with the following commands:

`sudo apt install iperf`

`sudo apt install hostapd`

`sudo apt install dnsmasq`

Once these are installed, we are ready to configure the Raspberry Pi specifically for the testbed. 

# Configuration 
This testbed network consists of a collection of Raspberry Pi's that are interconnceted via network switch. In order for the testbed controller to be able to control all of the devices on the network, they must all have a preset IP address for its ethernet port that is already known to the controller. This is called a static ethernet IP address. The reason that these static IP's are vital to the functionality of the controller is that the Testbed Controller will be SSHing into each Raspberry Pi and will require each satic IP of the interconnected devices. In order to set a static IP address on these Raspberry Pi's, you must enable and navigate to the `dhcpcd.conf` file with the following commands in the Raspberry Pi terminal: 

`sudo service dhcpcd start`

`sudo sytemctl enable dhcpcd.conf`

`sudo nano /etc/dhcpcd.conf`

It should bring you to a file that looks like:

![](/images/dhcpcd.png)

Go to the end of this file and add the following lines:

`interface eth0`

`static ip_address=10.1.1.101/24` 

`static routers=10.1.1.101` 

`static domain_name_servers=8.8.8.8.8.8.4.4` 

For the line `static ip_address=` you can specify the static IP you would like, but the current setup of the testbed has the devices named from 10.1.1.101-10.1.1.n for organization and to accomodate more Raspberry Pi's that may be placed in the Testbed. 

Another required detail of this testbed is that there must be no chance of these devices connecting to an access point that is not part of our controlled network. In order to assure no interference, we will navigate to the `wpa_supplicant` file which handles all wireless network connections and earase any SSID setup that could interfere (We will visit this file again in the 'Bash Scripts for Configuration' folder)

`sudo nano /etc/wpa_supplicant/wpa_supplicant.conf` 

Delete all content except the first three lines, which should be: 

`ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev`

`update_config=1`

`country=US`

You can now exit the file. 

# Script for Service Set Configuration
Each Raspberry Pi on the control network will have to be assigned to a service set specified by the user. In order to make this process efficient by assigning a group of Pi's to a service set simultaneously, each Pi will need its own bash script that takes user input from the Testbed Controller and passes these parameters (SSID and Password) to this bash script stored on the Pi. In order to save this script onto your Raspberry Pi 

connects it the the specified access point. This script can be found in the this folder of this repository and it is titled `A_TO_C.sh`. Save this bash script to the main directory of every Raspberry Pi. 
# Finalizing the Setup 
Your Raspberry Pi is nearly ready to become part of the Testbed network, but it still requires a few more bash scripts which will be covered in another documentation. In order to finalize the configuration settings you have been setting, from the Raspberry Pi terminal run `sudo reboot`. Once the Pi has rebooted, check the static IP of the device with the command `hostname -I`. Only the static ethernet IP address will appear since any wireless network settings were deleted from the `wpa_supplicant` file. 

