#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: Transmit Tone
# Author: MR
# GNU Radio version: 3.10.11.0

from gnuradio import analog
from gnuradio import gr
from gnuradio.filter import firdes
from gnuradio.fft import window
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import iio
from xmlrpc.server import SimpleXMLRPCServer
import threading




class Tx_Tone_Pluto(gr.top_block):

    def __init__(self, fc=int(915e6), node='101', samp_rate=3e6, tone_amp=0.02, tone_freq=500e3, tx_gain=40):
        gr.top_block.__init__(self, "Transmit Tone ", catch_exceptions=True)
        self.flowgraph_started = threading.Event()

        ##################################################
        # Parameters
        ##################################################
        self.fc = fc
        self.node = node
        self.samp_rate = samp_rate
        self.tone_amp = tone_amp
        self.tone_freq = tone_freq
        self.tx_gain = tx_gain

        ##################################################
        # Blocks
        ##################################################

        self.xmlrpc_server_0 = SimpleXMLRPCServer(("10.1.1." + node, 8080), allow_none=True)
        self.xmlrpc_server_0.register_instance(self)
        self.xmlrpc_server_0_thread = threading.Thread(target=self.xmlrpc_server_0.serve_forever)
        self.xmlrpc_server_0_thread.daemon = True
        self.xmlrpc_server_0_thread.start()
        self.iio_pluto_sink_0 = iio.fmcomms2_sink_fc32("ip:192.168.2.1" if "ip:192.168.2.1" else iio.get_pluto_uri(), [True, True], 32768, False)
        self.iio_pluto_sink_0.set_len_tag_key('')
        self.iio_pluto_sink_0.set_bandwidth(1000000)
        self.iio_pluto_sink_0.set_frequency(fc)
        self.iio_pluto_sink_0.set_samplerate(int(samp_rate))
        self.iio_pluto_sink_0.set_attenuation(0, (tx_gain*1.001) - tx_gain)
        self.iio_pluto_sink_0.set_filter_params('Auto', '', 0, 0)
        self.analog_sig_source_x_0 = analog.sig_source_c(samp_rate, analog.GR_COS_WAVE, tone_freq, tone_amp, 0, 0)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_sig_source_x_0, 0), (self.iio_pluto_sink_0, 0))


    def get_fc(self):
        return self.fc

    def set_fc(self, fc):
        self.fc = fc
        self.iio_pluto_sink_0.set_frequency(self.fc)

    def get_node(self):
        return self.node

    def set_node(self, node):
        self.node = node

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)
        self.iio_pluto_sink_0.set_samplerate(int(self.samp_rate))

    def get_tone_amp(self):
        return self.tone_amp

    def set_tone_amp(self, tone_amp):
        self.tone_amp = tone_amp
        self.analog_sig_source_x_0.set_amplitude(self.tone_amp)

    def get_tone_freq(self):
        return self.tone_freq

    def set_tone_freq(self, tone_freq):
        self.tone_freq = tone_freq
        self.analog_sig_source_x_0.set_frequency(self.tone_freq)

    def get_tx_gain(self):
        return self.tx_gain

    def set_tx_gain(self, tx_gain):
        self.tx_gain = tx_gain
        self.iio_pluto_sink_0.set_attenuation(0,(self.tx_gain*1.001) - self.tx_gain)



def argument_parser():
    parser = ArgumentParser()
    parser.add_argument(
        "-c", "--fc", dest="fc", type=eng_float, default=eng_notation.num_to_str(float(int(915e6))),
        help="Set Center Frequency  [default=%(default)r]")
    parser.add_argument(
        "-n", "--node", dest="node", type=str, default='101',
        help="Set Node Number [default=%(default)r]")
    parser.add_argument(
        "-a", "--samp-rate", dest="samp_rate", type=eng_float, default=eng_notation.num_to_str(float(3e6)),
        help="Set Sample Rate [default=%(default)r]")
    parser.add_argument(
        "-t", "--tone-amp", dest="tone_amp", type=eng_float, default=eng_notation.num_to_str(float(0.02)),
        help="Set Tone Amplitude (tone) [default=%(default)r]")
    parser.add_argument(
        "-f", "--tone-freq", dest="tone_freq", type=eng_float, default=eng_notation.num_to_str(float(500e3)),
        help="Set Tone Frequency (Relative to fc) [default=%(default)r]")
    parser.add_argument(
        "-g", "--tx-gain", dest="tx_gain", type=eng_float, default=eng_notation.num_to_str(float(40)),
        help="Set Transmitter Gain  [default=%(default)r]")
    return parser


def main(top_block_cls=Tx_Tone_Pluto, options=None):
    if options is None:
        options = argument_parser().parse_args()
    tb = top_block_cls(fc=options.fc, node=options.node, samp_rate=options.samp_rate, tone_amp=options.tone_amp, tone_freq=options.tone_freq, tx_gain=options.tx_gain)

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
