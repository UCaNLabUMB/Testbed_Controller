#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from xmlrpc.client import ServerProxy
import sys, getopt
import time



def main(argv):

   node_id   = '101'
   tone_freq = ''
   tx_gain   = ''
   sig_type  = ''
   
   f_set = 0
   g_set = 0
   s_set = 0
   debug = 0
   
   try:
      opts, args = getopt.getopt(argv,"hn:f:g:s:d",["node_id=","tone_freq=","tx_gain=","sig_type="])
   except getopt.GetoptError:
      print ('  test.py -n <node ID> -f <tone freq> -g <tx gain> -s <sig type>')
      sys.exit(2)   
   for opt, arg in opts:
      if opt == '-h':
         print ('  test.py -n <node ID> -f <tone freq> -g <tx gain> -s <sig type>')
         sys.exit()
      elif opt in ("-n", "--node_id"):
         node_id = arg
      elif opt in ("-f", "--tone_freq"):
         tone_freq = arg
         f_set = 1
      elif opt in ("-g", "--tx_gain"):
         tx_gain = arg
         g_set = 1
      elif opt in ("-s", "--sig_type"):
         sig_type = arg
         s_set = 1
      elif opt in ("-d", "--debug"):
         debug = 1
         
   if debug == 1:
      print ('Node ID:        ', node_id)
      print ('Tone Frequency: ', tone_freq)
      print ('Tx Gain:        ', tx_gain)
      print ('Signal Type:    ', sig_type)
   
   xmlrpc_control_client = ServerProxy('http://'+'10.1.1.'+node_id+':8080')


   if f_set == 1:
      xmlrpc_control_client.set_tone_freq(int(tone_freq))

   if g_set == 1:
      xmlrpc_control_client.set_tx_gain(int(tx_gain))

   if s_set == 1:
      xmlrpc_control_client.set_sig_select(int(sig_type))
   
   
   

if __name__ == "__main__":
   main(sys.argv[1:])
