#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: Pi receiver script
# Author: MR
# GNU Radio version: 3.10.11.0

from gnuradio import blocks
from gnuradio import gr
from gnuradio.filter import firdes
from gnuradio.fft import window
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import soapy
from gnuradio import zeromq
from xmlrpc.server import SimpleXMLRPCServer
import threading




class Rx_general_RTL(gr.top_block):

    def __init__(self, fc=915000000, node='101', rx_gain=40, samp_rate=3000000):
        gr.top_block.__init__(self, "Pi receiver script ", catch_exceptions=True)
        self.flowgraph_started = threading.Event()

        ##################################################
        # Parameters
        ##################################################
        self.fc = fc
        self.node = node
        self.rx_gain = rx_gain
        self.samp_rate = samp_rate

        ##################################################
        # Blocks
        ##################################################

        self.zeromq_pub_sink_0 = zeromq.pub_sink(gr.sizeof_float, 1, "tcp://10.1.1."+node+":55555", 100, False, 1)
        self.xmlrpc_server_0 = SimpleXMLRPCServer(("10.1.1." + node, 8081), allow_none=True)
        self.xmlrpc_server_0.register_instance(self)
        self.xmlrpc_server_0_thread = threading.Thread(target=self.xmlrpc_server_0.serve_forever)
        self.xmlrpc_server_0_thread.daemon = True
        self.xmlrpc_server_0_thread.start()
        self.soapy_rtlsdr_source_0 = None
        dev = 'driver=rtlsdr'
        stream_args = 'bufflen=16384'
        tune_args = ['']
        settings = ['']

        def _set_soapy_rtlsdr_source_0_gain_mode(channel, agc):
            self.soapy_rtlsdr_source_0.set_gain_mode(channel, agc)
            if not agc:
                  self.soapy_rtlsdr_source_0.set_gain(channel, self._soapy_rtlsdr_source_0_gain_value)
        self.set_soapy_rtlsdr_source_0_gain_mode = _set_soapy_rtlsdr_source_0_gain_mode

        def _set_soapy_rtlsdr_source_0_gain(channel, name, gain):
            self._soapy_rtlsdr_source_0_gain_value = gain
            if not self.soapy_rtlsdr_source_0.get_gain_mode(channel):
                self.soapy_rtlsdr_source_0.set_gain(channel, gain)
        self.set_soapy_rtlsdr_source_0_gain = _set_soapy_rtlsdr_source_0_gain

        def _set_soapy_rtlsdr_source_0_bias(bias):
            if 'biastee' in self._soapy_rtlsdr_source_0_setting_keys:
                self.soapy_rtlsdr_source_0.write_setting('biastee', bias)
        self.set_soapy_rtlsdr_source_0_bias = _set_soapy_rtlsdr_source_0_bias

        self.soapy_rtlsdr_source_0 = soapy.source(dev, "fc32", 1, '',
                                  stream_args, tune_args, settings)

        self._soapy_rtlsdr_source_0_setting_keys = [a.key for a in self.soapy_rtlsdr_source_0.get_setting_info()]

        self.soapy_rtlsdr_source_0.set_sample_rate(0, samp_rate)
        self.soapy_rtlsdr_source_0.set_frequency(0, fc)
        self.soapy_rtlsdr_source_0.set_frequency_correction(0, 0)
        self.set_soapy_rtlsdr_source_0_bias(bool(False))
        self._soapy_rtlsdr_source_0_gain_value = 20
        self.set_soapy_rtlsdr_source_0_gain_mode(0, bool(False))
        self.set_soapy_rtlsdr_source_0_gain(0, 'TUNER', 20)
        self.blocks_moving_average_xx_0 = blocks.moving_average_ff(2000, (1/2000), 500, 1)
        self.blocks_complex_to_mag_squared_0 = blocks.complex_to_mag_squared(1)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_complex_to_mag_squared_0, 0), (self.blocks_moving_average_xx_0, 0))
        self.connect((self.blocks_moving_average_xx_0, 0), (self.zeromq_pub_sink_0, 0))
        self.connect((self.soapy_rtlsdr_source_0, 0), (self.blocks_complex_to_mag_squared_0, 0))


    def get_fc(self):
        return self.fc

    # def set_fc(self, fc): # OLD SCRIPTS 
    def set_carrier_frequency(self, fc):
        self.fc = fc
        self.soapy_rtlsdr_source_0.set_frequency(0, self.fc)

    def get_node(self):
        return self.node

    def set_node(self, node):
        self.node = node

    def get_rx_gain(self):
        return self.rx_gain

    def set_rx_gain(self, rx_gain):
        self.rx_gain = rx_gain

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.soapy_rtlsdr_source_0.set_sample_rate(0, self.samp_rate)



def argument_parser():
    parser = ArgumentParser()
    parser.add_argument(
        "-c", "--fc", dest="fc", type=eng_float, default=eng_notation.num_to_str(float(915000000)),
        help="Set Center Frequency [default=%(default)r]")
    parser.add_argument(
        "-n", "--node", dest="node", type=str, default='101',
        help="Set Node Number [default=%(default)r]")
    parser.add_argument(
        "-g", "--rx-gain", dest="rx_gain", type=eng_float, default=eng_notation.num_to_str(float(40)),
        help="Set Receiver Gain  [default=%(default)r]")
    parser.add_argument(
        "-a", "--samp-rate", dest="samp_rate", type=eng_float, default=eng_notation.num_to_str(float(3000000)),
        help="Set Sample Rate [default=%(default)r]")
    return parser


def main(top_block_cls=Rx_general_RTL, options=None):
    if options is None:
        options = argument_parser().parse_args()
    tb = top_block_cls(fc=options.fc, node=options.node, rx_gain=options.rx_gain, samp_rate=options.samp_rate)

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()
    tb.flowgraph_started.set()

    tb.wait()


if __name__ == '__main__':
    main()
