import argparse
import math
import sys
import struct

import numpy as np

import matplotlib.pyplot as plt

xs = np.zeros(2000)
ins = np.zeros(2000)
outs = np.zeros(2000)

msg_sz = struct.calcsize("ff")

count = 0 

cur_state = -1.0

class SlidingWindowLPF(object):
  def __init__(self, window_sz):
    self.delays = np.zeros(window_sz)
    self.rezero = 0
    self.pos = 0
    self.accum = 0
    self.window_sz = window_sz

  def run(self, val):
    self.accum -= self.delays[self.pos]
    self.accum += val
    self.delays[self.pos] = val
    self.pos += 1
    if self.pos == self.window_sz:
      self.pos = 0
      self.rezero += 1

    if self.rezero == self.window_sz:
      self.accum = np.sum(self.delays)

    return self.accum

i_lpf2 = SlidingWindowLPF(25)

while True:
  data = sys.stdin.buffer.read(1024)
  while len(data) > 0:
    (i, q) = struct.unpack_from("ff", data)
    data = data[msg_sz:]

    xs = np.roll(xs, -1)
    ins = np.roll(ins, -1)
    outs = np.roll(outs, -1)

    i_filtered = i_lpf2.run(i)

    if cur_state < 0:
      if i_filtered > 50.0:
        cur_state = 1.0
    else:
      if i_filtered < -50.0:
        cur_state = -1.0

    xs[-1] = count
    ins[-1] = i_filtered
    outs[-1] = cur_state

    count += 1

    if count % 100 == 0: # was 10000
      plt.gcf().clear()
      plt.plot(xs, ins)
      plt.plot(xs, 100*outs)

        #plt.plot(xs, np.square(iss) + np.square(qss))
      plt.pause(0.001)

plt.show()


