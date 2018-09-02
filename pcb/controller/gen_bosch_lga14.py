# version 0.0.4
# unique package type; QFN with special numbering and nonsquare package

# updates: modified to work with four-sided packages with ground pads

# Using https://www.mouser.com/datasheet/2/783/BST-BMG250-DS000-02-967971.pdf as reference

PARTNAME = "Bosch_LGA14"

# footprint dimensions taken from MAXIM's 1.27mm SOIC-8; Adesto
# doesn't seem to provide one

# NOTE: pin numbering starts top left and goes counter clockwise
total_pins = 14
# total_pins != 2*(num_horiz + num_vert) because there's a bunch of gnd
# pins on the top and bottom
num_horiz = 6 // 2
num_vert = 8 // 2

M1 = 0.2 # silkscreen margin
M2 = 0.05 # fab outline margin
M3 = 0.3 # courtyard margin

D1 = 3.0 # package width
E1 = 2.5 # package height

use_round_pads = False
C = 0.50 # footprint pad spacing
w = 0.25 # footprint pad width
h = 0.675 # footprint pad length

X = 2*0.925 + h # distance between pad centers horizontally
Y = 2*0.675 + h # distance between pad centers vertically

H = 3.0 - 2*0.1 # distance from physical pad end to opposite pad end horizontally
I = 2.5 - 2*0.1 # distance from physical pad end to opposite pad end vertically
e = C    # physical pad spacing, same as above
b = 0.25 # physical pad width
L1 = 0.475 # physical pad length horizontally
L2 = 0.475 # physical pad length vertically

use_ground_pad = False
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

for i in range(0, num_vert):
  print("""  (pad {} smd {} (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
    (solder_mask_margin {}))""".
        format(
            i+1,
            pad_type,
            -X/2,
            C*(i-(num_vert/2-0.5)),
            h,
            w,
            solder_mask_margin))
for i in range(0, num_horiz):
  print("""  (pad {} smd {} (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
    (solder_mask_margin {}))""".
        format(
            i+num_vert+1,
            pad_type,
            C*(i-(num_horiz/2-0.5)),
            Y/2,
            w,
            h,
            solder_mask_margin))
for i in range(0, num_vert):
  print("""  (pad {} smd {} (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
    (solder_mask_margin {}))""".
        format(
            i+num_horiz+num_vert+1,
            pad_type,
            X/2,
            -C*(i-(num_vert/2-0.5)),
            h,
            w,
            solder_mask_margin))
for i in range(0, num_horiz):
  print("""  (pad {} smd {} (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
    (solder_mask_margin {}))""".
        format(
            i+num_horiz+2*num_vert+1,
            pad_type,
            -C*(i-(num_horiz/2-0.5)),
            -Y/2,
            w,
            h,
            solder_mask_margin))


# add ground pad
if use_ground_pad:
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
