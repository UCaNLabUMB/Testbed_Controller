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

