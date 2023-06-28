# Testbed Controller
This repository is developed and maintained by the Ubiquitous Communications and Networking Lab (UCaN Lab) at UMass Boston. The code provides a set of documentation and scripts for configuring distributed nodes from a central location, and offers test capabilities for analyzing throughput in dense multi-access point and multi-user environments.

This tool is designed to analyze the impact of network configurations and traffic characteristics in a variety of scenarios. Rather than using real world devices with various internet based applications, device usage is emulated with Raspberry Pi (RPi) microcontrollers. All of the **RPi nodes** will be connected to a single computer acting as the **Testbed Controller (TC)**, allowing the network to be centrally configured and controlled.

The testbed architecture consists of a _Control Network_ and _Test Network(s)_ as shown below. The control network connects all RPi nodes to the TC. The Test Network(s) consist of WiFi router(s) that the RPi nodes can connect to. The iperf network performance analysis tool is used to generate traffic and analyze performance of the Test Network(s). RPi nodes on the Test Network(s) can be configured as iperf servers (connected to APs via Ethernet) or iperf clients (connected wirelessly to the APs).
![GitHub Logo](Documentation/Images/tethered_architecture.png) 



This repository includes documentation that covers how to setup an instance of this testbed, scripts to perform the the testbed's core functionality, and a graphical user interface (GUI) to simplify the use of provided scripts. 
* The `Documentation` folder includes detailed information describing how to configure the TC/RPi nodes, execute performance analysis tests, and aggregate/analyze test results.   
* The `Testbed Scripts` folder contains the bash scripts that perform the core functionality of the TC. This folder includes three subfolders for the different categories of scripts, including:
  - `Configuration` scripts related to Test Network setup and Device Information.
  - `Test` scripts related to initializing iperf clients/servers and aggregating results.
  - `Analysis` scripts related to parsing and visualization of aggregated results.

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
| 0 | Testbed Architecture | (ADD IMAGE) | (ADD DOCUMENTATION LINK) | Overview and Description of the testbed architecture and network conventions. 
| 1 | Setting Up the TC | <img src="/Documentation/Images/TB_controller.png" /> |  [Read Now (for Windows)](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Testbed_Controller_Windows_Setup.md) | Setup necessary software and network configuration settings for the TC to communicate with RPi Nodes and execute configuration / test commands.
| 2 | Setting Up RPi Nodes | <img src="/Documentation/Images/raspberry_pi.jpg" /> | [Read Now](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Raspberry_Pi_Setup.md) | Setup necessary software and network configuration settings for the RPi Nodes to communicate with the TC. 
| 3 | Control Network Configuration  | <img src="/Documentation/Images/control_network.png" /> | [Read Now](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Testbed_Controller.md) | Configure the control network to verify IP conventions are correctly set and passwordless SSH is setup to interact with RPi nodes.
| 4 | Test Network Configuration  | (ADD IMAGE) | (ADD DOCUMENTATION LINK) | Configure the Test Network (i.e., wireless network connections, Tx power, etc.) via the TC.
| 5 | Testing and Analysis  | <img src="/Documentation/Images/test_network.png" /> | --- | Initialize iperf servers and clients to initiate performance analysis tests, and aggregate/analyze results from the distributed RPi nodes.
