# Testbed Controller
![GitHub Logo](/Images/tetherless_architecture.png) 
This repository is meant to be the the central location of configuration scripts used for UCaN Lab's Testbed Controller. This tool is designed to analyze the impact of data offloading across multiple service sets under various scenarios. Rather than using real world devices with various internet based applications, these data rates will be emulated by Raspberry Pi's since these devices are easy to control/manipulate than commercial devices. All of these devices will be part of the same ethernet switch network so that a central computer acting as the Testbed Controller will be able to communicate with any of the available devices at any given time.

The content of this repository includes documentation that covers how to setup the individual devices that make up this testbed and the scripts that perform the core functionality before incorporating a GUI. 
* The `Documentation` folder shows how to configure the Raspberry Pi's specific to our control network (siwtch network) and the computer that will function as the Testbed Controller. 
* The `Setup Scripts` folder applies to the bash scripts required for the configuration of Raspberry Pi's specific to our control network 
* The `Testbed Scripts` folder contains the bash scripts that perform the core functionality of the Testbed Controller 
  * This folder requires three subfolders for the different categories of `Testbed Scripts` including `Analysis`, `Configuration` and `Test` 

# Functionality of Raspberry Pi Node 
![GitHub Logo](/Images/mobile_node.png) 

# Chapters
| Chapter | Topic | Image | Link | Summary 
| --- | --- | --- | --- | --- |
| 1 | Configuring the Raspberry Pi for Testbed | --- | [Read Now](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Raspberry_Pi_Setup.md) | The Raspberry Pi's will require a specific operating system and certain network configurations for Testbed functionality. 
| 2 | Checking the Status of Raspberry Pi's  | --- | --- | Once our Raspberry Pi's are configured from the steps followed in Chapter 1, we will need to verify the assigned IP addresses along with the indivdual functionality of the node 
| 3 | Setting Up the Testbed Controller | --- |  [Read Now](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Testbed_Controller_Setup.md) | There will be so many Raspberry Pi's for these performance test that it would be counter productive to check the configurations of these Pi's individually. We can condense this process into a centralized computer that can check the status of our Pi  
| 4 | Testing  | --- | --- | We can now run some netwrok performance tests with this setup equipment. 
