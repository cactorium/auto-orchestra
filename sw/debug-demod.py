import argparse
import math
import sys
import struct

import numpy as np

import matplotlib.pyplot as plt

xs = np.zeros(2000)
ins = np.zeros(2000)
outs = np.zeros(2000)

msg_sz = struct.calcsize("f")

count = 0 

while True:
  data = sys.stdin.buffer.read(msg_sz)
  while len(data) > 0:
    (i, ) = struct.unpack_from("f", data)
    data = data[msg_sz:]

    xs = np.roll(xs, -1)
    ins = np.roll(ins, -1)
    outs = np.roll(outs, -1)

    xs[-1] = count
    ins[-1] = i

    count += 1

    plt.gcf().clear()
    plt.plot(xs, ins)

      #plt.plot(xs, np.square(iss) + np.square(qss))
    if (count % 100) == 0:
      plt.pause(0.001)

plt.show()

