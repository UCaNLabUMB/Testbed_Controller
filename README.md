# Testbed Controller
![GitHub Logo](Documentation/Images/tethered_architecture.png) 
This repository is developed and maintained by the Ubiquitous Communications and Networking Lab (UCaN Lab) at UMass Boston. The code provides a set of documentation and scripts for configuring distributed nodes from a central location, and offers test capabilities for analyzing throughput in dense multi-access point and multi-user environments.

This tool is designed to analyze the impact of network configurations and traffic characteristics in a variety of scenarios. Rather than using real world devices with various internet based applications, device usage is emulated with Raspberry Pi (RPi) microcontrollers. All of the **RPi nodes** will be connected to a single computer acting as the **Testbed Controller (TC)**, allowing the network to be centrally configured and controlled.

The testbed architecture consists of a _Control Network_ and _Test Network(s)_ as shown above. The control network connects all RPi nodes to the TC. The Test Network(s) consist of WiFi router(s) that the RPi nodes can connect to. The iperf network performance analysis tool is used to generate traffic and analyze performance of the Test Network(s). RPi nodes on the Test Network(s) can be configured as iperf servers (connected to APs via Ethernet) or iperf clients (connected wirelessly to the APs).

This repository includes documentation that covers how to setup an instance of this testbed, scripts to perform the the testbed's core functionality, and a graphical user interface (GUI) to simplify the use of provided scripts. 
* The `Documentation` folder includes detailed information describing how to configure the TC/RPi nodes, execute performance analysis tests, and aggregate/analyze test results.   
* The `Testbed Scripts` folder contains the bash scripts that perform the core functionality of the TC
  * This folder includes three subfolders for the different categories of scripts, including `Configuration` scripts, `Test` scripts, and `Analysis` scripts. 

# Equipment  
* Raspberry Pi microcontrollers (3B+ or 4, ideally 4G RAM or higher)
  - microSD cards  
  - Power cables
* PC for Testbed Controller (Ideally, running Ubuntu Linux) 
* Networking Equipment
  - WiFi Router(s) 
  - Network Switches 
  - Ethernet cables

# Chapters
| Chapter | Topic | Image | Link | Summary 
| --- | --- | --- | --- | --- |
| 1 | Configuring the Raspberry Pi for Testbed | <img src="/Documentation/Images/raspberry_pi.jpg" /> | [Read Now](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Raspberry_Pi_Setup.md) | The Raspberry Pi's will require a specific operating system and certain network configurations for Testbed functionality. 
| 2 | Setting Up the Testbed Controller | <img src="/Documentation/Images/TB_controller.png" /> |  [Read Now (for Windows)](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Testbed_Controller_Windows_Setup.md) | There will be so many Raspberry Pi's for these performance test that it would be counter productive to check the configurations of these Pi's individually. We can condense this process into a centralized computer that can check the status of our Pi 
| 3 | Checking the Status of Raspberry Pi's  | <img src="/Documentation/Images/control_network.png" /> | [Read Now](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Testbed_Controller.md) | Once our Raspberry Pi's are configured from the steps followed in Chapter 1, we will need to verify the assigned IP addresses along with the indivdual functionality of the node 
| 4 | Testing  | <img src="/Documentation/Images/test_network.png" /> | --- | We can now run some netwrok performance tests with this setup equipment. 
