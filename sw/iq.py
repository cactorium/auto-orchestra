import argparse
import math
import sys
import struct

import numpy as np

import matplotlib.pyplot as plt

count = 0

ub = 0
lb = 0

avg = 0.0
t = 0.0

val = 0

t0 = 2*math.pi*10e+3/100.e+3

class RollingAverageLPF(object):
  def __init__(self, k):
    self.k = k
    self.v = 0.0

  def run(self, val):
    self.v = (1.0 - self.k)*self.v + self.k * val
    return self.v

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

i_lpf = SlidingWindowLPF(5)
q_lpf = SlidingWindowLPF(5)

i_lpf2 = SlidingWindowLPF(25)
q_lpf2 = SlidingWindowLPF(25)

phi_lpf = RollingAverageLPF(0.05)

avg_sq = 0.0

theta_int = 0.0
phi = 0.0

while True:
  data = sys.stdin.buffer.read(2)
  while len(data) > 0:
    lb = data[0] 
    ub = data[1]
    data = data[2:]

    old = val
    val = (ub << 8) | lb

    avg = 0.95*avg + 0.05*val
    v = val - avg
    avg_sq = 0.95*avg_sq + 0.05*v*v

    # AGC so that it stays relatively stable
    v = v/math.sqrt(avg_sq)

    i = i_lpf.run(math.cos(t)*v)
    q = q_lpf.run(math.sin(t)*v)

    sys.stdout.buffer.write(struct.pack("ff", i, q))

    phi = phi_lpf.run(i * q)

    t += t0 + theta_int - 5e-3*phi
    theta_int -= 1e-6*phi
    if t > 2*math.pi:
      t -= 2*math.pi

    count += 1
