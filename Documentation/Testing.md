# Running the Base Test script 

After confirming that each Pi is connected through LAN, we can start to run the desired tests needed from this testbed. The bash script for the test, "base_test.sh," will run each desired test given a certain number of trials and a duration period for each iperf test. Using flag parameters, we can allow the user to input arguments from the command line, similar to the connection test script. 

 

There are three flags used for this setup: 1. "-d" 2. "–t" 3."-r" 

* -d: This flag allows the user to input the duration period (in seconds) for each iperf test. 

(I.e., bash base_test.sh -d 2). Using only this flag will default the number of trials to 1. 

* -t: This flag allows the user to set the number of trials to be run given a scenario.  

(I.e., bash base_test.sh -t 2). Using only this flag will default the duration to 10 seconds.  

It is possible to input both the number of trials and the duration, regardless of which order they are inputted. For example, if we want to run a test of 3 trials and 5 seconds each, we can input: 

"bash base_test.sh -t 3 –d 5" or "bash iperf_bash2.sh -d 5 –t 3" 

* -r: This flag is used to create a range of IPs to connect to. Since we know the IP prefix for this testbed (10.1.1.x), the possible values for the range are from 0 to 255. The syntax for this script is "bash iperf_bash2.sh -d 1 –t 2 –r <rangeStart> <rangeEnd>  

If there are no flags called upon running this script, the script will request manual input from the user on the number of trials and the duration, separated by a space (trials duration --> 5 3). 

* -i: This flag is used for individual values to be connected for each test. The user can input multiple values (i.e 101 102 104), given that the ip prefix is "10.1.1"

* -s: This flag is used for indicating which server the Pi connects to. This varies based on the users AP configurations, but for this example we have routers with an ip prefix of "192.168." The next address can be either "1.200" or "2.200," depending on the AP the Pi is connected to.

For example, we have one Pi which connects to the server "192.168.1.200" and 2 Pis connected to the server with the address "192.168.2.200," we would write this command as:

bash base_test.sh -r 101 103 -s 1.200 2.200 2.200

(It is extremely important that you specify which Pis you will be connecting, or else this flag will not work.


Given the duration and time parameters, we can run our desired test. This script focuses on offloading devices and running a specified number of trials of iperf tests running on selected devices given a time interval. Each scenario involves offloading one device from the previous test and running tests accordingly. The access points that are connected to the iperf server are 2.4 GHz and all operating on the same channel, so results may be affected due to co-channel interference.  