#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import sys, getopt
import csv
import xmlrpc.client 
from xmlrpc.client import ServerProxy 
import time 


# -- Main -- 
def main(argv):

   ############################
   # Script Configuration     #
   ############################
   node_id      = '101'
   delay        = 2
   debug = 0
   
   try:
      opts, args = getopt.getopt(argv,"hn:t:d",["node_id=","time_delay="])
   except getopt.GetoptError:
      print ('  set_remote_tx_stop.py -n <node ID> -t <time delay> ')
      sys.exit(2)   
   for opt, arg in opts:
      if opt == '-h':
         print ('  set_remote_tx_stop.py -n <node ID> -t <time delay> ')
         sys.exit()
      elif opt in ("-n", "--node_id"):
         node_id = arg
      elif opt in ("-t", "--time_delay"):
         delay = arg
      elif opt in ("-d", "--debug"):
         debug = 1
         
   ############################
   # DEBUG                    #
   ############################
   if debug == 1:
      print ('Node ID:           ', node_id)

   # -- Setup -- 
   xmlrpc_control = ServerProxy('http://' + '10.1.1.' + node_id + ':' + '8080') 

   # -- Execution -- 
   time.sleep(float(delay)) 

   xmlrpc_control.set_shutdown_flag(1)
   
if __name__ == '__main__':
    main(sys.argv[1:]) 
