import math
import sys

import numpy as np

import matplotlib.pyplot as plt

save_fig = False
xs = np.zeros(500)
poss = np.zeros(500)
count = 0

ub = 0
lb = 0

while True:
  data = sys.stdin.buffer.read(1024)
  while len(data) > 0:
    lb = data[0] 
    ub = data[1]
    data = data[2:]

    val = (ub << 8) | lb

    xs = np.roll(xs, -1)
    poss = np.roll(poss, -1)

    xs[-1] = count
    poss[-1] = val

    count += 1

    if count % 100 == 0: # was 10000
      plt.gcf().clear()
      # plt.plot(xs, i_s)
      # plt.plot(xs, q_s)
      plt.plot(xs, poss)
      plt.pause(0.001)

plt.show()


