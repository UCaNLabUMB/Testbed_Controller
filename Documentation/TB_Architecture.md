# Testbed Architecture
![GitHub Logo](Documentation/Images/TB_Architecture2.png)

## Overview
The architecture includes a Control Network, which connects the Testbed Controller (TC) with all the RPi nodes, and a Test Network which connects the wireless AP to the server nodes (usually via Ethernet) and to the clients nodes via WiFi. The iperf tests evaluate performance of the Test Network.

The base architecture for this testbed uses a wired Ethernet network to connect the TC and RPi nodes in order to implement the control network. The Test network is formed by RPi nodes connected to one of the WiFi access points (APs) and enabled as either an iperf server or iperf client.
* Client nodes connect to AP via WiFi
* Server nodes are wired to the AP


## Testbed Components
* **Testbed Controller (TC):** Centralized station (PC) that allows access and control to all nodes remotely via ssh across a dedicated control network.
* **Testbed Nodes (Clients and Servers):** Raspberry Pi microcontrollers with iperf tool installed to test network performance for given configurations.
* **Access Points (APs):** COTS WiFi router(s) for testing network connectivity and performance analysis. 
* **Other Components:**
  - Pi Components (SSD Cards and Power Cables)
  - Ethernet Cables and USB to Ethernet Adapter(s)
  - Network Switch(es)
  - Monitor/Keyboad/Mouse is needed for setting up RPi Nodes


## Network Conventions
The Control Network and Test network use a 10.1.1.X subnet and 192.168.Y.X subnet, respectively, where: 
* Y = AP number
* X = Device address (i.e., node number)

Specific Addresses
* TC: `10.1.1.1`
* APs: `192.168.Y.1`
* Server Nodes: `10.1.1.X` / `192.168.Y.201` 
  - (192.168.Y.201 assigned to a USB to Eth adapter)
* Client Nodes: `10.1.1.X` / `192.168.Y.X`
  - X represents the pi's numbers staring at 101.

**NOTE:** The nodes Ethernet IPs (i.e., 10.1.1.X) are statically defined. Test network addresses are assigned via DHCP reservations to maintain convention when switching to a different AP.


## Software Tools
* **SSH:** We use the Secure Shell network protocol to communicate remotely from the testbed controller to the rest of the nodes and exchange data, (open rate)
* **IPerf3:** IPerf software works in a client-server mode. On the first device, the iPerf starts in server mode waiting for traffic from the iPerf client. On the second computer, the iPerf starts in client mode, generates traffic and measures the maximum data transfer rate and the maximum network bandwidth (throughput) between two network nodes.

## Data Collection Procedure
Once the testbed is setup, data collection is implemented as follows. The steps below are defined in more detail in the [Testing and Analysis](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Testing.md) documentation.
* Configure nodes and test network connection (from TC)
* Start iperf server(s) at server nodes
* Run iperf tests at distributed client nodes
* Store resulting data on client nodes
* Transfer data to TC
* Analyze data on TC
