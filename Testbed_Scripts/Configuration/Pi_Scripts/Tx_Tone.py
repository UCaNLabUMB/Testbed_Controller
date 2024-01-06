#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: Transmit tone
# Author: MR
# GNU Radio version: v3.8.5.0-6-g57bd109d

from gnuradio import analog
from gnuradio import gr
from gnuradio.filter import firdes
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import uhd
import time


class Tx_Tone(gr.top_block):

    def __init__(self, fc=915e6, sig_amp=0.5, sig_freq=0.5e6, tx_gain=40):
        gr.top_block.__init__(self, "Transmit tone")

        ##################################################
        # Parameters
        ##################################################
        self.fc = fc
        self.sig_amp = sig_amp
        self.sig_freq = sig_freq
        self.tx_gain = tx_gain

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 4e6

        ##################################################
        # Blocks
        ##################################################
        self.uhd_usrp_sink_0 = uhd.usrp_sink(
            ",".join(("", "")),
            uhd.stream_args(
                cpu_format="fc32",
                args='',
                channels=list(range(0,1)),
            ),
            '',
        )
        self.uhd_usrp_sink_0.set_center_freq(fc, 0)
        self.uhd_usrp_sink_0.set_gain(tx_gain, 0)
        self.uhd_usrp_sink_0.set_antenna('TX/RX', 0)
        self.uhd_usrp_sink_0.set_samp_rate(samp_rate)
        # No synchronization enforced.
        self.analog_sig_source_x_0 = analog.sig_source_c(samp_rate, analog.GR_COS_WAVE, sig_freq, sig_amp, 0, 0)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_sig_source_x_0, 0), (self.uhd_usrp_sink_0, 0))


    def get_fc(self):
        return self.fc

    def set_fc(self, fc):
        self.fc = fc
        self.uhd_usrp_sink_0.set_center_freq(self.fc, 0)

    def get_sig_amp(self):
        return self.sig_amp

    def set_sig_amp(self, sig_amp):
        self.sig_amp = sig_amp
        self.analog_sig_source_x_0.set_amplitude(self.sig_amp)

    def get_sig_freq(self):
        return self.sig_freq

    def set_sig_freq(self, sig_freq):
        self.sig_freq = sig_freq
        self.analog_sig_source_x_0.set_frequency(self.sig_freq)

    def get_tx_gain(self):
        return self.tx_gain

    def set_tx_gain(self, tx_gain):
        self.tx_gain = tx_gain
        self.uhd_usrp_sink_0.set_gain(self.tx_gain, 0)

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)
        self.uhd_usrp_sink_0.set_samp_rate(self.samp_rate)




def argument_parser():
    parser = ArgumentParser()
    parser.add_argument(
        "-c", "--fc", dest="fc", type=eng_float, default="915.0M",
        help="Set Center Frequency [default=%(default)r]")
    parser.add_argument(
        "-a", "--sig-amp", dest="sig_amp", type=eng_float, default="500.0m",
        help="Set Signal Amplitude [default=%(default)r]")
    parser.add_argument(
        "-f", "--sig-freq", dest="sig_freq", type=eng_float, default="500.0k",
        help="Set Signal Frequency (Relative to fc) [default=%(default)r]")
    parser.add_argument(
        "-g", "--tx-gain", dest="tx_gain", type=eng_float, default="40.0",
        help="Set Transmitter Gain [default=%(default)r]")
    return parser


def main(top_block_cls=Tx_Tone, options=None):
    if options is None:
        options = argument_parser().parse_args()
    tb = top_block_cls(fc=options.fc, sig_amp=options.sig_amp, sig_freq=options.sig_freq, tx_gain=options.tx_gain)

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()

    tb.wait()


if __name__ == '__main__':
    main()
