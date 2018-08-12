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


def getsheetnet(net_name):
  # TODO
  pass


def getsheetref(ref):
  # TODO
  pass


def main():
  parser = argparse.ArgumentParser(description="Tiles repeated PCB structures in a Pcbnew board file")
  parser.add_argument("input", help="file to tile")
  parser.add_argument("tile", help="sheet number of the already arranged components, eg. with this set to 3, we'll use components whose references match *3**")
  parser.add_argument("tocopy", help="sheets to tile, eg. 3,4,6-8")

  args = parser.parse_args()

  lines = []
  netmap = dict()
  # categorize by sheet number
  modules = dict()
  tracks = []

  with open(args.input, 'r') as f:
    cur_module = None
    for l in f:
      lines.append(l)
      line_num = len(lines) - 1
      # NOTE: assumes net expressions have no newlines
      stripped = l.strip()[1:-1] # strip parentheses
      if stripped.startswith("(net"):
        net_parts = quotesplit(stripped)
        net_id = int(net_parts[1])
        net_name = net_parts[2]
        cur_sheet = getsheetnet(net_name)
        netmap[net_id].append(Net(cur_sheet, net_name))
      elif stripped.startswith("(module"):
        # NOTE: assumes the module is always saved with two properties, ordered
        # (module ....
        #    (at ...
        #    (fp_text reference ...
        if cur_module is None:
          cur_module = Module(None, line_num, None)
        else:
          print("[ERR] unable to parse file; found (module within a module")
          return
      elif stripped.startswith("(at") and cur_module is not None:
        cur_module.at_line = line_num
      elif stripped.startswith("(fp_text reference") and cur_module is not None:
        cur_module.reference = quotesplit(stripped)[2]
        cursheet = getsheetref(cur_module)
      elif stripped.startswith(")") as cur_module is not None:
        # add module
        if modules.get(cursheet) is None:
          modules[cursheet] = list()
        modules[cursheet].append(cur_module)
        cur_module = None
      elif stripped.startswith("(segment"):
        # TODO
        pass
  
  # TODO 

if __name__ == "__main__":
  main()
