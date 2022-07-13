# Testbed Controller
![GitHub Logo](Documentation/Images/tethered_architecture.png) 
This repository is meant to be the the central location of configuration scripts used for UCaN Lab's Wireless Network Testbed. This tool is designed to analyze the impact of network configurations and traffic characteristics in a variety of scenarios. Rather than using real world devices with various internet based applications, the devices will be emulated with Raspberry Pis (RPis). All of the RPi nodes will be connected to a single computer acting as the Testbed Controller (TC), allowing the network to be centrally configured and controlled.

The testbed architecture consists of a Control Network and Test Network(s). The control network connects all RPi nodes to the TC and uses the 10.1.1.X subnet. The Test Network(s) are formed with one ore more wireless access points (APs) that the RPi nodes can connect to. Test Network(s) are where traffic is generated and performance is analyzed using iperf network performance tools. RPi nodes on the Test Network(s) can be configured as iperf servers (typically connected to an AP via Ethernet) or iperf clients.

The content of this repository includes documentation that covers how to setup the individual devices that make up this testbed and the scripts that perform the core functionality before incorporating a GUI. 
* The `Documentation` folder shows how to configure the Raspberry Pi's specific to our control network (siwtch network) and the computer that will function as the Testbed Controller. 
* The `Testbed Scripts` folder contains the bash scripts that perform the core functionality of the Testbed Controller 
  * This folder requires three subfolders for the different categories of `Testbed Scripts` including `Analysis`, `Configuration` and `Test` 

# Equipment  
* Raspberry Pi's (3B+ or 4, two different USB inputs for power supply)
* Power Supply
* microSD card reader for computer
* Linux or  Windows OS 
* WiFi Routers 
* Network Switch 
* Ethernet cables (for connecting # of Raspberry Pi's and PC with the network switch)

# Chapters
| Chapter | Topic | Image | Link | Summary 
| --- | --- | --- | --- | --- |
| 1 | Configuring the Raspberry Pi for Testbed | <img src="/Documentation/Images/raspberry_pi.jpg" /> | [Read Now](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Raspberry_Pi_Setup.md) | The Raspberry Pi's will require a specific operating system and certain network configurations for Testbed functionality. 
| 2 | Setting Up the Testbed Controller | <img src="/Documentation/Images/TB_controller.png" /> |  [Read Now (for Windows)](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Testbed_Controller_Windows_Setup.md) | There will be so many Raspberry Pi's for these performance test that it would be counter productive to check the configurations of these Pi's individually. We can condense this process into a centralized computer that can check the status of our Pi 
| 3 | Checking the Status of Raspberry Pi's  | <img src="/Documentation/Images/control_network.png" /> | [Read Now](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Testbed_Controller.md) | Once our Raspberry Pi's are configured from the steps followed in Chapter 1, we will need to verify the assigned IP addresses along with the indivdual functionality of the node 
| 4 | Testing  | <img src="/Documentation/Images/test_network.png" /> | --- | We can now run some netwrok performance tests with this setup equipment. 
