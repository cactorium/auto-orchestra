# version 0.0.4
# unique package type; QFN with special numbering and nonsquare package

# updates: modified to work with four-sided packages with ground pads

# Using http://www.ti.com/lit/ds/symlink/msp430fr2522.pdf as reference

PARTNAME = "TI-MSP430-QFN20"

# footprint dimensions taken from MAXIM's 1.27mm SOIC-8; Adesto
# doesn't seem to provide one

total_pins = 20
# total_pins != 2*(num_horiz + num_vert) because there's a bunch of gnd
# pins on the top and bottom
num_horiz = 8 // 2
num_vert = 16 // 2

M1 = 0.2 # silkscreen margin
M2 = 0.05 # fab outline margin
M3 = 0.3 # courtyard margin

D1 = 3.5 # package width
E1 = 4.5 # package height

use_round_pads = False
C = 0.50 # footprint pad spacing
w = 0.24 # footprint pad width
h = 0.6 # footprint pad length

X = 3.3 # distance between pad centers horizontally
Y = 4.3 # distance between pad centers vertically

H = D1 # distance from physical pad end to opposite pad end horizontally
I = E1 # distance from physical pad end to opposite pad end vertically
e = C    # physical pad spacing, same as above
b = 0.20 # physical pad width
L1 = 0.40 # physical pad length horizontally
L2 = 0.40 # physical pad length vertically

G1 = 2.05  # ground pad width
H1 = 3.05  # ground pad height
include_vias = False # NOTE: disabled # add ground vias
V1 = None # NOTE: larger than specified # via diameter
V2 = None # via horizontal spacing; None implies centering
V3 = None # via vertical spacing; None implies centering
V4 = None # via annular ring diameter
ground_pad_num = 21

solder_mask_margin = 0.07
indicator_circle_dia = 0.3

import math

import time
gen_time = hex(int(time.time()))[2:].upper()


prologue = """(module {} (layer F.Cu) (tedit {})
  (fp_text reference REF** (at 0.0 0.0) (layer F.SilkS)
    (effects (font (size 1 1) (thickness 0.15)))
  )
  (fp_text value {} (at 0 -0.5) (layer F.Fab)
    (effects (font (size 1 1) (thickness 0.15)))
  )
"""

prologue = prologue.format(PARTNAME, gen_time, PARTNAME)
epilogue = """)"""

print(prologue)

# print silkscreen outline
inner_edge_x = C*(num_horiz/2 - 0.5) + w/2 + M1
inner_edge_y = C*(num_vert/2 - 0.5) + w/2 + M1
x = D1/2 + M1
y = E1/2 + M1
for x, y, nx, ny in [
    (-x, -inner_edge_y, -inner_edge_x, -y),
    (inner_edge_x, -y, x, -y), (x, -y, x, -inner_edge_y),

    (x, inner_edge_y, x, y), (x, y, inner_edge_x, y),
    (-inner_edge_x, y, -x, y), (-x, y, -x, inner_edge_y)]:
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.SilkS) (width 0.15))""".
      format(x, y, nx, ny))

x = D1/2 + 0.75*indicator_circle_dia
y = E1/2 + 0.75*indicator_circle_dia
# add indicator circle
print("""  (fp_circle (center {} {}) (end {} {}) (layer F.SilkS) (width 0.15))""".
    format(-x, -y - indicator_circle_dia/2., -x, -y))


# draw package outline in fab layer
x, y, nx, ny = -D1/2 - M2, -E1/2 - M2, D1/2 + M2, -E1/2 - M2
for _ in range(0, 4):
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x, y, nx, ny))
  x, y, nx, ny = nx, ny, -x, -y

for i in range(num_vert):
  x_pos = -D1/2 - M2
  y_pos = C*(i-(num_vert/2-0.5))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos, y_pos - b/2 - M2, x_pos + L1, y_pos - b/2 - M2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos + L1, y_pos - b/2 - M2, x_pos + L1, y_pos + b/2 + M2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos + L1, y_pos + b/2 + M2, x_pos, y_pos + b/2 + M2))

for i in range(num_horiz):
  x_pos = C*(i-(num_horiz/2-0.5))
  y_pos = E1/2 + M2
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos - b/2 - M2, y_pos, x_pos - b/2 - M2, y_pos - L2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos - b/2 - M2, y_pos - L2, x_pos + b/2 + M2, y_pos - L2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos + b/2 + M2, y_pos - L2, x_pos + b/2 + M2, y_pos))


for i in range(num_vert):
  x_pos = D1/2 + M2
  y_pos = -C*(i-(num_vert/2-0.5))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos, y_pos + b/2 + M2, x_pos - L1, y_pos + b/2 + M2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos - L1, y_pos + b/2 + M2, x_pos - L1, y_pos - b/2 - M2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos - L1, y_pos - b/2 - M2, x_pos, y_pos - b/2 - M2))

for i in range(num_horiz):
  x_pos = -C*(i-(num_horiz/2-0.5))
  y_pos = -E1/2 - M2
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos + b/2 + M2, y_pos, x_pos + b/2 + M2, y_pos + L2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos + b/2 + M2, y_pos + L2, x_pos - b/2 - M2, y_pos + L2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos - b/2 - M2, y_pos + L2, x_pos - b/2 - M2, y_pos))

# print courtyard outline
inner_x = C*(num_horiz/2-0.5) + b/2 + M3/2
outer_x = max(X, H)/2 + h/2 + M3/2
inner_y = C*(num_vert/2-0.5) + b/2 + M3/2
outer_y = max(Y, I)/2 + h/2 + M3/2
pts = [
    (-inner_x, -outer_y),
    (inner_x, -outer_y),
    (inner_x, -inner_y),
    (outer_x, -inner_y),
    (outer_x, inner_y),
    (inner_x, inner_y),
    (inner_x, outer_y),
    (-inner_x, outer_y),
    (-inner_x, inner_y),
    (-outer_x, inner_y),
    (-outer_x, -inner_y),
    (-inner_x, -inner_y)
    ]
nx, ny = pts[-1]
for px, py in pts:
  x, y, nx, ny = nx, ny, px, py
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.CrtYd) (width 0.15))""".
      format(x, y, nx, ny))

pad_type = "rect"
if use_round_pads:
  pad_type = "oval"

# NOTE: special pad numbering
# starts at 2
for i in range(0, num_vert):
  print("""  (pad {} smd {} (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
    (solder_mask_margin {}))""".
        format(
            i+2,
            pad_type,
            -X/2,
            C*(i-(num_vert/2-0.5)),
            h,
            w,
            solder_mask_margin))
# 10, gnd_pad, gnd_pad, 11
bottom_pads = [10, ground_pad_num, ground_pad_num, 11]
for i in range(0, num_horiz):
  print("""  (pad {} smd {} (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
    (solder_mask_margin {}))""".
        format(
            bottom_pads[i],
            pad_type,
            C*(i-(num_horiz/2-0.5)),
            Y/2,
            w,
            h,
            solder_mask_margin))
# starts at 12
for i in range(0, num_vert):
  print("""  (pad {} smd {} (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
    (solder_mask_margin {}))""".
        format(
            i+12,
            pad_type,
            X/2,
            -C*(i-(num_vert/2-0.5)),
            h,
            w,
            solder_mask_margin))
# 20, gnd_pad, gnd_pad, 1
top_pads = [20, ground_pad_num, ground_pad_num, 1]
for i in range(0, num_horiz):
  print("""  (pad {} smd {} (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
    (solder_mask_margin {}))""".
        format(
            top_pads[i],
            pad_type,
            -C*(i-(num_horiz/2-0.5)),
            -Y/2,
            w,
            h,
            solder_mask_margin))


# add ground pad
print("""  (pad {} smd {} (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
  (solder_mask_margin {}))""".
      format(
          ground_pad_num,
          "rect",
          0,
          0,
          G1,
          H1,
          solder_mask_margin))

# add ground pad extensions
ext_width = C + w
ext_height = Y/2 - h/2 - H1/2
print("""  (pad {} smd {} (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
  (solder_mask_margin {}))""".
      format(
          ground_pad_num,
          "rect",
          0,
          H1/2 + ext_height/2,
          ext_width,
          ext_height,
          solder_mask_margin))
print("""  (pad {} smd {} (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
  (solder_mask_margin {}))""".
      format(
          ground_pad_num,
          "rect",
          0,
          -H1/2 - ext_height/2,
          ext_width,
          ext_height,
          solder_mask_margin))




# add ground vias
if include_vias:
  x_vals = [0]
  y_vals = [0]
  if V2 is not None:
    x_vals = [V2/2, -V2/2]
  if V3 is not None:
    y_vals = [V3/2, -V3/2]
  for x in x_vals:
    for y in y_vals:
      print("""  (pad {} thru_hole circle (at {} {}) (size {} {}) (drill {} {}) (layers *.Cu *.Paste *.Mask))""".
            format(
                ground_pad_num,
                x,
                y,
                V4,
                V4,
                V1,
                V1))




print(epilogue)
