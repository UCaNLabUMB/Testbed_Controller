# Test Network Configuration
## Overview
Once the control network is configured, you will need to setup the WiFi AP(s) and WiFi connections to form the test network that you are interested in evaluating. This could consist of mulitple devices connected to a single AP, or devices connected to multiple APs (this is relevant, for example, if you are interested in observing co-channel interference effects). Either way, the Control Network remains as described in the previous section, and the majority of the Test Network configuration can be done directly from the TC. Once the APs and iperf server nodes are configured, you can reconfigure the client network connections to analyze a variety of test scenerios directly from the TC.

In this section, we will discuss the following topics:
* [Setup Access Points (APs)](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Config_Test_Net.md#setup-aps)
* [Setup Server Node(s)](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Config_Test_Net.md#server-node-setup)
* [Client Node WiFi Setup](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Config_Test_Net.md#client-node-wifi-setup)
* [Configure DHCP Reservations](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Config_Test_Net.md#configure-dhcp-reservations)
* [Verify Test Network Settings](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Config_Test_Net.md#verify-test-network-settings)


## Setup APs
The main goal here is to configure your AP(s) to align with the testbed conventions, but we will also discuss optional settings that will ensure a somewhat controlled environment for testing. Note that _APs do not need to be connected to the Internet_ for the purpose of this testbed! In fact, in most cases it is preferable if your APs are NOT connected to the Internet (to assure that other traffic is not active on the test network, which would impact your performance analysis).

If you have not configured a router before, the first step is to connect to the router (either wirelessly or via Ethernet) and find the router's configuration page. In most cases, this can be accessed through a web browser by typing `192.168.1.1` in the address bar, but this may differ for various routers (or if the router has already been configured as a different subnet). Once you access the configuration page, you will need to enter the router's password to login. 
* **NOTE:** If you are using the TC to connect to the router, keep in mind that your wired interface has been assigned a static IP and will not be able to communicate with the router! This is also true if you are attempting to connect an RPi node to the router using the Ethernet interface that was assigned a static IP.

![GitHub Logo](Images/wlan_login.png)

Once you have logged into the router, there are some LAN settings that need to be configured for the testbed, and some WiFi settings that can be configured for whatever test you are running. The description for setting these parameters is described below for a **LinkSYS WRT3200ACM** router, but the parameter options should be similar for whatever router you are using.

After logging in, we start by selecting "Connectivity" and going the Local Network tab in order to configure the LAN parameters as follows:
* **Router's IP address/Subnet mask:** The Subnet mask should be 255.255.255.0 and the IP address should be `192.168.Y.1` where Y is unique for each AP in your testbed (e.g., 192.168.1.1, 192.168.2.1, and 192.168.3.1 if you are using three APs in your test environment).
* **DHCP Server:** Modify the DHCP Server Settings to make sure that the DHCP server can allocate device addresses from `192.168.Y.100` through `192.168.Y.201`. This is to account for the iperf clients (starting at `192.168.Y.101`) and the server (at `192.168.Y.201`). In our router's configuration settings (shown below) this is done by setting the start address as `192.168.Y.100` and maximum DHCP users to a number greater than 101.

![GitHub Logo](Images/wlan_LAN_settings.png)

After applying the changes above, you can optionally edit your Router's WiFi settings.
* **SSID/Password:** You should set the SSID and password to something that you can easily remember for connecting RPi nodes as clients.
* **Channel/Channel Width:** For experimental control, it is best to set a fixed channel that you know is not utilized (this is more easily done in the 5GHz band). Similarly, fixing the channel width can improve the control over your tests to avoid performance effects related to the AP dynamically adapting the channel width (as is done if channel width is set to Auto).
* **WiFi Mode:** To avoid some variability, it can be helpful to clearly specify the WiFi mode.

![GitHub Logo](Images/wlan_wifi_settings.png)



## Server Node Setup
While most of the RPi nodes will connect via WiFi and operate as iperf clients, a subset of the RPi nodes should be used as iperf servers. The server nodes should not generate unnecessary traffic on the wireless network, so they should be wired to the AP(s) via Ethernet. Specifically, we connect at least one RPi node to each AP via Ethernet. Since the RPi nodes already have Static IP addresses assigned for their Ethernet interface, you will need a second Ethernet interface on the server node(s). For this, you can use a USB to Ethernet adapter. 

When connected, the AP's DHCP server will give the adapter's Ethernet interface a random IP address from the DHCP address range. This will be addressed shortly when configuring the DHCP reservations. This will also imply three network connections for the RPi nodes operating as servers (i.e., the control network via `eth0`, the wired connection to the Test Network via `eth1`, and the wireless connection via wlan0. To avoid potential issues, it is best to disable the WLAN at the server nodes. If you setup VNC Viewer, this is easily done by opening VNC Viewer, connecting to the server node, and then clicking on the network connection (top right corner of the desktop) and selecting "Turn off WLAN".
* **NOTE:** The WLAN can also be disabled via command line, but this is a simple case to demonstrate the use of the VNC Viewer!


## Client Node WiFi Setup
Once the AP(s) and server nodes are configured, the remaining RPi nodes can be connected to the desired WLANs from the TC. To do this easily, the testbed includes a `set_wlan.sh` script in the configuration directory. This script can be used with the `-l` or `-r` flags to indicate a set of nodes to connect. It also has flags for specifying the SSID of the desired WLAN, and for indicating the password of the WLAN. For example, the command below will attempt to connect nodes 105 and 106 to the AP with SSID "mySSID" and password "myPassword".
* `bash set_wlan.sh -r 105,106 -s mySSID -p myPassword`

When this script is run on the TC, it tells each RPi node to call a local script that has been stored in the RPi node's testbed directory during the setup process (i.e., when you ran the `setup_pis.sh` script). The local script updates the wireless network configuration so that it connects to the specified WLAN. After executing the local script, the RPi node(s) will reboot (causing the warning `Connection to 10.1.1.X closed by remote host.` to appear in the TC's terminal). The figure below highlights an instance where we first check the help menu for `set_wlan.sh` and then use the script to connect nodes 105 and 106 to our AP with SSID "UCaNLab_Research_5GHz". It then shows that we can use the `get_info_wifi.sh` script to verify that the nodes have been connected to the correct WLAN, while also displaying the channel in use for this WLAN and the RSSI at each RPi node.

![GitHub Logo](Images/set_wlan.png)



## Configure DHCP Reservations
In the design of the testbed, the Test Network IP address for each of the client nodes should be set to `192.168.Y.X` where Y represents the AP that the node is connected to and X represents the node's assigned number. We look to reconfigure the Test Network for a variety of scenarios where client nodes may change AP from scenario to scenario, therefore we want the nodes' Test Network IP addresses to be dynamically set so that the convention is maintained when switching APs. To address this, we allow the Test Network addresses to be set by DHCP servers at the APs; however, we use DHCP reservations to assure the appropriate device address is assigned to connecting nodes. 

Similarly, the server nodes should be assigned the address `192.168.Y.201` so that client nodes know where to connect. This is unrelated to the node number of the RPi node that is used as the server, so we also setup a DHCP reservation for the MAC address associated with the USB to Ethernet adapter. This ensures that the address will always be assigned to the eth1 interface for whatever RPi node is connected to the specific adapter, and allows the nodes to be interchangeable as servers as long as the adapter is kept with the associated AP.

In order to set the DHCP reservations at each AP, we need to know the MAC addresses of the RPi nodes. This can be determined using the testbed's `get_mac.sh` script in the Configuration directory. This script uses the `-l` or `-r` flags to specify the set of nodes to be polled, and also uses the `-n` flag to specify which network interface you are interested in. By default, the script polls the specified RPi nodes to get the MAC address of their `eth0` interface, but we are interested in the `wlan0` interface MAC addresses so that they can be used for specifying DHCP reservations. The following command will list the wlan0 MAC addresses for nodes 101 through 110:
* `bash get_mac.sh -r 101,110 -n wlan0`

If you have already connected an RPi node to the AP as a server node, you can also use the get_mac.sh script to determine the adapter's MAC address. For example, if node 101 is connected as a server you can run the following command:
* `bash get_mac.sh -l 101 -n eth1`

The image below depicts an instance where we first use the help flag to learn about the `get_mac.sh` script. We then use the script to determine the WLAN MAC for each of the three nodes, and the MAC address of the adapter, which is connected to node 101.

![GitHub Logo](Images/get_mac.png)

Now that you have the set of relevant MAC addresses, you can return to the router's configuration page, login, go back to the Local Network tab in the Connectivity page, and select "DHCP Reservations" (or follow a similar process for your specific router). Here, you can specify the desired IP address for each node by associating it with the MAC address for that node's wlan0 interface. Similarly, you can associate the address `192.168.Y.201` with the MAC address of the adapter. 

If you have a large number of RPi nodes, this can be tedious (and can potentially lead to incorrectly entered MAC addresses). One option to simplify the procedure is to first connect all RPi nodes to the AP with the `set_wlan.sh` script. After doing this, all of the devices will appear in the current DHCP list, as shown below. We can see here that the MAC addresses correspond to the addresses found above with the `get_mac.sh` script. The IP addresses shown here have already been assigned, but at this point they would typically show up as random device addresses from the DHCP range that you specified when setting up your WLAN. 

![GitHub Logo](Images/DHCP_Res1.png)

From the list above, you can select all of the devices and click "Add DHCP Reservation" to associate their MAC addresses with their current IP addresses. Once the devices have been added to the Reserved list, you can simply edit each entry and update the IP address (and, optionally, the device name) as desired. When you complete the edits and select "OK" the router should reboot and the addresses should be assigned as specified.
![GitHub Logo](Images/DHCP_Res2.png)

* **NOTE:** Make sure to assign DHCP reservations for all of your RPi nodes (and for the adapter's Ethernet interface), and then repeat this process for each AP in your testbed. This process only needs to be done once, and will ensure that the appropriate IP addresses are assigned whenever nodes switch between WLANs.


## Verify Test Network Settings
Once you have configured your APs and setup DHCP reservations for all nodes on all APs, we can use the testbed scripts to verify that the network addressing is setup correctly. To check all of the settings, you can use the `set_wlan.sh` and `get_ip.sh` scripts to iteratively connect all of the nodes to each AP, and check the IP assignments. The instance shown below demonstrates the results after assigning our DHCP reservations above. Here, we use the `get_ip.sh` script and use the `-n` flag to indicate that we are requesting all addresses on the Test Network. In the first call of `get_ip.sh`, we see that node 101 has two addresses on the Test Network since it is connected wirelessly and via Ethernet with the adapter. We have not yet turned off the WLAN at node 101 since we wanted to make sure to associate the WLAN MAC address with a DHCP reservation first (in case we want to use this node as a client node in the future). Before repeating the call in the instance below, we quickly connected to node 101 with VNC viewer and disabled the WLAN since it is being used as a server at the moment. Therefore, the second call shows that the Test Network is setup as desired with node 101 ready for configuration as an iperf server, and nodes 105/106 ready to be configured as iperf clients for analysis of the wireless network. The final call revisits the `get_info_wifi.sh` script to further verify that we are connected to the appropriate AP (in addition to the IP address verification from the previous call).

![GitHub Logo](Images/get_ip_verify.png)

## Previous Chapter
[Control Network Configuration](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Config_Control_Net.md)

## Next Chapter
[Testing and Analysis](https://github.com/UCaNLabUMB/Testbed_Controller/blob/main/Documentation/Testing.md)