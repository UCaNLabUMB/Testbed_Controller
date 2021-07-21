# Testbed Controller
This repository is meant to be the the central location of configuration scripts used for UCaN Lab's Testbed Controller. This tool is designed to analyze the impact of data offloading across multiple service sets under various scenarios. Rather than using real world devices with various internet based applications, these data rates will be emulated by Raspberry Pi's since these devices are easy to control/manipulate than commercial devices. All of these devices will be part of the same ethernet switch network so that a central computer acting as the Testbed Controller will be able to communicate with any of the available devices at any given time.

The content of this repository includes documentation that covers how to setup the individual devices that make up this testbed and the scripts that perform the core functionality before incorporating a GUI. 
* The `Documentation` folder shows how to configure the Raspberry Pi's specific to our control network (siwtch network) and the computer that will function as the Testbed Controller. 
* The `Setup Scripts` folder applies to the bash scripts required for the configuration of Raspberry Pi's specific to our control network 
* The `Testbed Scripts` folder contains the bash scripts that perform the core functionality of the Testbed Controller 
  * This folder requires three subfolders for the different categories of `Testbed Scripts` including `Analysis`, `Configuration` and `Test`  
 

