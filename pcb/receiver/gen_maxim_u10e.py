# dual-row, TSSOP-, SOIC-, SO-style packages with ground plane
# version 0.0.4

# based on https://pdfserv.maximintegrated.com/land_patterns/90-0148.PDF
#   and https://pdfserv.maximintegrated.com/package_dwgs/21-0109.PDF
# added solder mask parameter
# added optional indicator circle
# added ground pad
# made ground pad optional
# fix silkscreen pin 1 marker

PARTNAME = "Maxim-10uMAX-EP"

total_pins = 10
num_per_edge = total_pins // 2

M1 = 0.2 # silkscreen margin
M2 = 0.05 # fab outline margin
M3 = 0.3 # courtyard margin

Z = 4.27 + 1.40 # distance across outer edges of pads
G = 4.27 - 1.40 # distance across inner edges of pads

X = (Z+G)/2. # distance between pad centers
C = 0.50 # footprint pad spacing
w = 0.27 # footprint pad width
h = (Z-G)/2. # footprint pad length

H = 4.900 # distance from physical pad end to opposite pad end
e = C    # physical pad spacing, same as above
b = 0.223 # physical pad width
L1 = 0.940 # physical pad length

D1 = 3.00 # package width
E1 = 3.00 # package height

has_ground_pad = True
G1 = 1.85  # ground pad width
H1 = 2.47  # ground pad height
ground_pad_num = 11

solder_mask_margin = 0.05
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
inner_edge = C*(num_per_edge/2 - 0.5) + w/2 + M1
x = D1/2 + M1
y = E1/2 + M1
for x, y, nx, ny in [
    (-x, -inner_edge, -x+(y-inner_edge), -y),
    (-x+(y-inner_edge), -y, x, -y), (x, -y, x, -inner_edge),

    (x, inner_edge, x, y), (x, y, -x, y),
    (-x, y, -x, inner_edge)]:
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.SilkS) (width 0.15))""".
      format(x, y, nx, ny))

if indicator_circle_dia is not None:
  x = X/2
  y = E1/2 + M1 + 0.75*indicator_circle_dia
  # add indicator circle
  print("""  (fp_circle (center {} {}) (end {} {}) (layer F.SilkS) (width 0.15))""".
      format(-x, -y - indicator_circle_dia/2., -x, -y))


# draw package outline in fab layer
x, y, nx, ny = -D1/2 - M2, -E1/2 - M2, D1/2 + M2, -E1/2 - M2
for _ in range(0, 4):
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x, y, nx, ny))
  x, y, nx, ny = nx, ny, -x, -y

for i in range(num_per_edge):
  x_pos = -D1/2 - M2
  y_pos = C*(i-(num_per_edge/2-0.5))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos, y_pos - b/2 - M2, x_pos - L1, y_pos - b/2 - M2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos - L1, y_pos - b/2 - M2, x_pos - L1, y_pos + b/2 + M2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos - L1, y_pos + b/2 + M2, x_pos, y_pos + b/2 + M2))

for i in range(num_per_edge):
  x_pos = D1/2 + M2
  y_pos = -C*(i-(num_per_edge/2-0.5))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos, y_pos + b/2 + M2, x_pos + L1, y_pos + b/2 + M2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos + L1, y_pos + b/2 + M2, x_pos + L1, y_pos - b/2 - M2))
  print("""  (fp_line (start {} {}) (end {} {}) (layer F.Fab) (width 0.15))""".
      format(x_pos + L1, y_pos - b/2 - M2, x_pos, y_pos - b/2 - M2))


# print silkscreen outline
inner_x = D1/2 + M3
outer_x = X/2 + h/2 + M3/2
inner_y = C*(num_per_edge/2-0.5) + b/2 + M3/2
outer_y = E1/2 + M3
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


for i in range(0, num_per_edge):
  print("""  (pad {} smd rect (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
    (solder_mask_margin {}))""".
        format(
            i+1,
            -X/2,
            C*(i-(num_per_edge/2-0.5)),
            h,
            w,
            solder_mask_margin))
for i in range(0, num_per_edge):
  print("""  (pad {} smd rect (at {} {}) (size {} {}) (layers F.Cu F.Paste F.Mask)
    (solder_mask_margin {}))""".
        format(
            i+1+1*num_per_edge,
            X/2,
            -C*(i-(num_per_edge/2-0.5)),
            h,
            w,
            solder_mask_margin))

if has_ground_pad: 
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


print(epilogue)
