# Setting Up the Raspberry Pi Nodes (RPi Nodes)
## Overview
The RPi nodes are the test points that will be configured/controlled by the TC and used as test points within the testbed. While we define the setup for test nodes as Raspberry Pi microcontrollers, the nodes could technically be any linux device configured with the relevant software and network configuration.

To describe the RPi node setup, we describe the following steps:
* [OS Installation](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Setup_RPi_Node.md#installing-the-operating-system-os)
* [Install Relevant Software](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Setup_RPi_Node.md#test-pi-and-install-relevant-software)
* [Pi Node IP Assignment](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Setup_RPi_Node.md#rpi-node-configuration)
* [Set Intital Wireless Network settings](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Setup_RPi_Node.md#pi-wireless-setup)


## Installing the Operating System (OS)
The OS for an RPi microcontroller (Pi 3 B+ or Pi 4) is stored on a microSD card. Accordingly, we must first configure a microSD card with the relevant OS. We will describe the setup for using _Pi OS_, however we have also tested the system with RPis running Ubuntu OS (some minor modifications are needed). To configure the microSD card, we suggest using Raspberry Pi Imager as described here.
* First, download the [Raspberry Pi Imager](https://www.raspberrypi.org/software/) software for the computer you will be using to setup your microSD card.
* Next, run Raspberry Pi Imager (see image below)
  - Select the desired OS (ideally, `64 bit Pi OS`)
  - Select the desired storage (i.e., your microSD card)
  - Select _Settings_ (lower right corner) and choose "Enable SSH" with the "Use password authentication" option so you don’t have to type in the public key. The key will be added later through the TC.
  - In the _Settings_ menu, select "Set Username and Password" and provide a username/password that _should be the same for all RPi nodes in the testbed_.
  - Select "Set locale settings" and set your location
  - Select "Save" to save the settings
  - Select "WRITE" to begin writing the OS onto the microSD card, and select "yes" to confirm that you want to format the microSD card.

**NOTE** If you will be setting up multiple RPi nodes, it is helpful to change setting for Image custumization options to "Always Use" so that you do not need to update the settings for every node you are programming.
  - If for any reason the custom settings are not setup, you can set the username/password and locale when the Pi is booted for the first time. In this case, do not enable Raspberry Pi connect during the setup process. Instead, you will also need to enable ssh via raspi-config once the Pi boots up.

![](/Documentation/Images/RPi_Setup.png)


## Test Pi and Install Relevant Software 
Now that the OS is installed, put your microSD card into the slot of the Raspberry Pi. It is possible to setup the Pis so that you never need to connect to a monitor, but (for simplicity) we suggest connecting each node to a monitor/keyboard/mouse and connect to the Internet (ideally via an Ethernet connection) for this one-time configuration. Once the RPi is powered up, open a terminal (CTRL+ALT+t) and install `iperf` with the following commands:
* `sudo apt install iperf`
* `sudo apt install iperf3`

**NOTE** When installing iperf3, you should select NO when asked about running iperf3 as a Daemon on startup.

You can verify the installations are successful by typing `iperf -v` and/or `iperf3 -v` to get the software version that you have just installed.

If you plan to use the testbed for SDR activities, you should also install the relevant GNURadio and UHD software using the following commands. The first two commands install GNURadio and the UHD, respectively. The third command uses the UHD library to download relevant FPGA images for available USRP hardware.
* `sudo apt install gnuradio`
* `sudo apt install libuhd-dev uhd-host`
* `sudo uhd_images_downloader`


## RPi Node Configuration 
We will now describe how to _enable WiFi_ and setup the RPi node's _static IP_ address. For simplicity, we describe how to do this using the Pi OS graphical interface; however, this can also be done in the terminal.  

To start, _click_ on the network icon (i.e., the arrows in the top right corner of the Desktop). If the WLAN is not enabled, you might need to select "Turn on WLAN". After this selection, if you click on the network icon again it will ask to "Click here to select wireless LAN country". Select this and specify your country (this will impact the available WLAN channels that the RPi node can use). If you click on the network icon again and the option to "select wireless LAN country" is still there, you might need to reboot the Pi.

When you click on the network icon again, you should be able to select _Advanced Options_ -> _Edit Connections_ to bring up the menu below. From here
* Select _Wireless Connection 1_ and click on the gear icon at the bottom.
* Select the _IPv6 Settings_ tab and change the Method selection to _Disabled_.
* Select the _IPv4 Settings_ tab and change the Method selection to _Manual_.
* Select _Add_ to add a static IP address for the network interface.
* Set the Address to `10.1.1.X` and the Netmask to `24`.
  - The "X" in the address should be replaced with a _unique number for each node_, starting at 101 for the first node.
* Click Save and then Close
  - If the Ethernet cable is connected when you change the IP address, it will not reflect until you disconnect and reconnect the cable!

![](/Documentation/Images/RPi_Setup_2.png)

Your pi is now configured, and you shouldn't need to connect it to a monitor again! You can shut down the Pi and repeat this process for the set of Pis you will be using in your testbed. Just remember to uniquely identify each node with a different device address (i.e., value of "X" in your IP address). If you have access to a label maker, it is helpful to indicate the number that you used for each node on the Pis.

## Previous Chapter
[Setting Up the TC](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Setup_TC.md)

## Next Chapter
[Control Network Configuration](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Config_Control_Net.md)