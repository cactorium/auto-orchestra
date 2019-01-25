import math
import sys

import numpy as np

import matplotlib.pyplot as plt

save_fig = False
xs = np.zeros(1000)
poss = np.zeros(1000)
count = 0

synced = True
preamble = [0xaa, 0xbb, 0xcc, 0xdd]
offset = 0

ub = 0
lb = 0

while True:
  data = sys.stdin.buffer.read(54)
  while len(data) > 0:
    if not synced:
      if data[0] == preamble[offset]:
        offset += 1
        if offset == 4:
          synced = True
          print("synced")
      else:
        print("skip")
        offset = 0
      data = data[1:]
      continue

    if offset < 4:
      if data[0] != preamble[offset]:
        print("lost sync, {} {}".format(data[0], preamble[offset]))
        offset = 0
        synced = False
      data = data[1:]
      offset += 1
      if offset == 4 and synced:
        print("sync kept")
      continue

    ub = lb
    lb = data[0]
    data = data[1:]

    offset += 1
    if offset >= 4 + 60:
      offset = 0

    if offset % 2 == 0 and offset != 4 and offset != 2:
      val = lb * 256 + ub

      xs = np.roll(xs, -1)
      poss = np.roll(poss, -1)

      xs[-1] = count
      poss[-1] = val

      count += 1

      if count % 1000 == 0:
        plt.gcf().clear()
        # plt.plot(xs, i_s)
        # plt.plot(xs, q_s)
        plt.plot(xs, poss)
        plt.pause(0.001)

plt.show()


