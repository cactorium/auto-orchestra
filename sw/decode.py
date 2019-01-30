import argparse
import math
import sys
import struct

import numpy as np

import matplotlib.pyplot as plt

msg_sz = struct.calcsize("f")

count = 0
sample_count = 0
cur_byte = 0
cur_bit = 0

sample_rate = 100e+3
bitrate = 2e+3

samples_per_bit = sample_rate / bitrate

last_val = None
timeout = True
# timeout if no transitions within 50 bits
timeout_count = 0

# copied from https://stackoverflow.com/questions/32030412/twos-complement-sign-extension-python
def sign_extend(value, bits):
    sign_bit = 1 << (bits - 1)
    return (value & (sign_bit - 1)) - (value & sign_bit)

class MessageSynchronizer(object):
  preamble = [0xff, 0xff]
  def __init__(self):
    self.synced = False
    self.offset = 0
    self.accel_x = 0
    self.accel_y = 0
    self.accel_z = 0
    self.gyro_x = 0
    self.gyro_y = 0
    self.gyro_z = 0
    self.sum = 0

  def sync_msg(self, b):
    if not self.synced:
      if self.offset == 0 or self.offset == 1:
        if b == MessageSynchronizer.preamble[self.offset]:
          print("sync")
          self.offset += 1
          self.synced = True
        else:
          print("skip")
          self.offset = 0
    else:
      if self.offset < 2:
        if b != MessageSynchronizer.preamble[self.offset]:
          print("lost sync")
          self.offset = 0
          self.synced = False
      elif self.offset == 2 or self.offset == 3:
        self.sum ^= b

        new_val = (self.gyro_x << 8) | b
        self.gyro_x = sign_extend(new_val, 16)
      elif self.offset == 4 or self.offset == 5:
        self.sum ^= b

        new_val = (self.gyro_y << 8) | b
        self.gyro_y = sign_extend(new_val, 16)
      elif self.offset == 6 or self.offset == 7:
        self.sum ^= b

        new_val = (self.gyro_z << 8) | b
        self.gyro_z = sign_extend(new_val, 16)
      elif self.offset == 8 or self.offset == 9:
        self.sum ^= b

        new_val = (self.accel_x << 8) | b
        self.accel_x = sign_extend(new_val, 16)
      elif self.offset == 10 or self.offset == 11:
        self.sum ^= b

        new_val = (self.accel_y << 8) | b
        self.accel_y = sign_extend(new_val, 16)
      elif self.offset == 12 or self.offset == 13:
        self.sum ^= b

        new_val = (self.accel_z << 8) | b
        self.accel_z = sign_extend(new_val, 16)
      elif self.offset == 14:
        if self.sum != b:
          print("sum failed, {} != {}".format(self.sum, b))
        print(self.gyro_x, self.gyro_y, self.gyro_z,
            self.accel_x, self.accel_y, self.accel_z)
      self.offset += 1
      if self.offset >= (2 + 6 + 6 + 1):
        self.sum = 0
        self.offset = 0
        self.accel_x = 0
        self.accel_y = 0
        self.accel_z = 0
        self.gyro_x = 0
        self.gyro_y = 0
        self.gyro_z = 0
      #print(self.offset)

msg_sync = MessageSynchronizer()

while True:
  data = sys.stdin.buffer.read(msg_sz)
  while len(data) > 0:
    (v, ) = struct.unpack_from("i", data)
    data = data[msg_sz:]

    if last_val is None:
      last_val = v

    if v != last_val:
      sample_count = 0

    if timeout:
      if v != last_val:
        timeout = False
        count = 0
        sample_count = 0
        cur_byte = 0
        cur_bit = 0

    count += 1
    if count == samples_per_bit/2:
      if v != last_val:
        cur_byte = (cur_byte << 1) | 1

        timeout_count = 0
      else:
        cur_byte = (cur_byte << 1)

        timeout_count += 1
        if timeout_count > 50:
          print("time out")
          timeout = True
      last_val = v

    if not timeout:
      if count >= samples_per_bit:
        count = 0
        cur_bit += 1
        if cur_bit == 8:
          #print(hex(cur_byte))
          msg_sync.sync_msg(cur_byte)
          cur_byte = 0
          cur_bit = 0
