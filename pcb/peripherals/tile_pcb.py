import argparse

# TODO: write a proper S-expression parser; right now this assumes a lot about
# the structure of the generated PCB file


class Net:
  def __init__(self, sheet_idx, net_name):
    self.sheet_idx = sheet_idx
    self.name = net_name


class Module:
  def __init__(self, reference, start_line, at_line):
    self.reference = reference
    self.start_line = start_line
    self.at_line = at_line
    self.left = None
    self.right = None
    self.up = None
    self.down = None


def quotesplit(line):
  parts = line.split(" ")
  ret = []
  num_quotes = 0
  incomplete_part = None
  for part in parts:
    num_quotes += len([None for c in part if c == '"'])
    if num_quotes % 2 == 1:
      if incomplete_part is None:
        # just started a quoted section
        incomplete_part = part
      else:
        incomplete_part += " " + part
    else:
      if incomplete_part is not None:
        # ending quote is in this part
        ret.append(incomplete_part + " " + part)
        incomplete_part = None
      else:
        # normal case; pass through
        ret.append(part)
  return ret


num_digits = 2
def getsheetref(ref):
  #print("ref", ref)
  s = ref
  while s[0].isalpha() and len(s) > 0:
    s = s[1:]
  if len(s) == 0:
    raise RuntimeError("unable to parse ref {}".format(ref))
  ret = int(s[:-num_digits])
  #print(ret)
  return ret


def getsheetnet(net_name):
  #print("net ", net_name)
  if net_name.startswith("\"Net-("):
    net_part = net_name[len("\"Net-("):].split("-")[0]
    return getsheetref(net_part)
  else:
    return -1


def bareref(ref):
  #print("ref", ref)
  s = ref
  while s[0].isalpha() and len(s) > 0:
    s = s[1:]
  if len(s) == 0:
    raise RuntimeError("unable to parse ref {}".format(ref))
  ret = int(s[-num_digits:])
  #print(ret)
  return ret


def stripparens(s):
  ret = s
  while (ret[0] == "(" or ret[0] == ")") and len(ret) > 0:
    ret = ret[1:]
  while (ret[-1] == "(" or ret[-1] == ")") and len(ret) > 0:
    ret = ret[:-1]
  return ret


def main():
  parser = argparse.ArgumentParser(description="Tiles repeated PCB structures in a Pcbnew board file")
  parser.add_argument("input", help="file to tile")
  parser.add_argument("tile", help="sheet number of the already arranged components, eg. with this set to 3, we'll use components whose references match *3**")
  parser.add_argument("tocopy", help="sheets to tile, eg. 3,4,6-8")
  parser.add_argument("offset", help="direction in the y direction to offset the repeated sections in mm")

  args = parser.parse_args()
  src_idx = int(args.tile)
  dst_idxs = list()
  offset = float(args.offset)
  # generate dst_idxs from tocopy
  for p in args.tocopy.split(","):
    if "-" in p:
      p = p.split("-")
      start = int(p[0])
      end = int(p[1])
      for i in range(start, end + 1):
        dst_idxs.append(i)
    else:
      dst_idxs.append(int(p))
  print("sheets to tile: {}".format(dst_idxs))

  lines = []
  netmap = dict()
  # categorize by sheet number
  modules = dict()
  tracks = []


  with open(args.input, 'r') as f:
    cur_module = None
    paren_count = 0
    for l in f:
      lines.append(l)
      line_num = len(lines) - 1
      stripped = l.strip()
      #print(line_num, paren_count, cur_module)
      #print(stripped)

      # NOTE: assumes net expressions have no newlines
      if stripped.startswith("(net "):
        net_parts = quotesplit(stripped)
        net_id = int(stripparens(net_parts[1]))
        net_name = net_parts[2]
        cur_sheet = getsheetnet(stripparens(net_name))
        netmap[net_id] = Net(cur_sheet, net_name)
      elif stripped.startswith("(module "):
        # NOTE: assumes the module is always saved with two properties, ordered
        # (module ....
        #    (at ...
        #    (fp_text reference ...
        if cur_module is None:
          cur_module = Module(None, line_num, None)
        else:
          print("[ERR] line {}: unable to parse file; found (module within a module".format(line_num))
          # print(cur_module)
          return
      elif stripped.startswith("(at ") and cur_module is not None:
        cur_module.at_line = line_num
      elif stripped.startswith("(fp_text reference") and cur_module is not None:
        cur_module.reference = quotesplit(stripped)[2]
        cursheet = getsheetref(cur_module.reference)
      elif stripped.startswith(")") and paren_count == 2 and cur_module is not None:
        # print("line {}: module end".format(line_num))
        # add module
        if modules.get(cursheet) is None:
          modules[cursheet] = list()
        modules[cursheet].append(cur_module)
        cur_module = None
      # NOTE: assumes segments have no newlines
      elif stripped.startswith("(segment "):
        parts = stripped.split(" ")
        # find the part "(net" and use the following one as the net id
        net_idx = list(filter(lambda x: x[1] == "(net", enumerate(parts)))
        if len(net_idx) != 1:
          print("[ERR] line {}: unable to find net_id for segment".format(line_num))
          return
        net_idx = int(stripparens(parts[net_idx[0][0] + 1]))
        #print(net_idx)
        if netmap.get(net_idx) is None:
          print("[ERR] line {}: net not known in netmap".format(line_num))
          return
        sheet_idx = netmap[net_idx].sheet_idx
        if sheet_idx == src_idx:
          tracks.append(line_num)
      paren_count += stripped.count("(") - stripped.count(")")
  
  print("found {} tileable modules".format(len(modules[src_idx])))
  print("found {} tileable traces".format(len(tracks)))

  for i, dst_idx in enumerate(dst_idxs):
    off = offset * i
    for module in modules[dst_idx]:
      print(module.reference)

if __name__ == "__main__":
  main()
