import math
import sys

import numpy as np

import matplotlib.pyplot as plt

save_fig = False
xs = np.zeros(500)
iss = np.zeros(500)
qss = np.zeros(500)
count = 0

ub = 0
lb = 0

avg = 0.0
t = 0.0

val = 0

while True:
  data = sys.stdin.buffer.read(1024)
  while len(data) > 0:
    lb = data[0] 
    ub = data[1]
    data = data[2:]

    old = val
    val = (ub << 8) | lb

    xs = np.roll(xs, -1)
    iss = np.roll(iss, -1)
    qss = np.roll(qss, -1)

    xs[-1] = count
    avg = 0.95*avg + 0.05*val
    iss[-1] = math.cos(2*math.pi*10e+3*t)*(val - avg)
    qss[-1] = math.sin(2*math.pi*10e+3*t)*(val - avg)

    t += 1/100.e+3

    count += 1

    if count % 100 == 0: # was 10000
      plt.gcf().clear()
      plt.plot(xs, iss)
      plt.plot(xs, qss)
      #plt.plot(xs, np.square(iss) + np.square(qss))
      #plt.scatter(iss, qss)
      plt.pause(0.001)

plt.show()


