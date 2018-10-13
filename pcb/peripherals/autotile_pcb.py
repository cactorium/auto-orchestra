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
    self.end_line = None
    self.net_lines = list()
    self.ref_line = None
    self.path_line = None

    self.x = None
    self.y = None

# used in s-expr parser to demarcate identifiers from strings
class Identifier:
  def __init__(self, id):
    self.id = id
  def __repr__(self):
    return self.id


def parse_sexpr(s):
  # returns (name, [values])
  parts = list()
  # ignore whitespace
  while s[0] == " " or s[0] == "\n":
    s = s[1:]
  # grab the first part of the s-expression, the "(name " part, and then
  # recursively parse the rest
  assert s[0] == "("
  s = s[1:]
  name = ""
  while s[0] != " ":
    name += s[0]
    s = s[1:]

  while s[0] == " " or s[0] == "\n":
    s = s[1:]

  while s[0] != ")":
    if s[0] == "(":
      new_part, s = parse_sexpr(s)
      parts.append(new_part)
    elif s[0] == "\"":
      string = ""
      escaped = False

      s = s[1:]
      # really inefficient but whatever this is Python
      # NOTE: crashes if the string isn't terminated
      while escaped or s[0] != "\"":
        escaped = (s[0] == "\\")
        string += s[0]
        s = s[1:]
      # eat the ending quotes
      s = s[1:]
      parts.append(string)
    else:
      # it's either a number or some kind of identifier
      # grab until there's whitespace and process is accordingly
      part = ""
      while s[0] not in [" ", ")", "\n"]:
        part += s[0]
        s = s[1:]

      try:
        part = int(part)
      except ValueError:
        try:
          part = float(part)
        except ValueError:
          part = Identifier(part)
      parts.append(part)

    # skip over any whitespace
    while s[0] == " " or s[0] == "\n":
      s = s[1:]
  # skip over the ending parenthesis
  s = s[1:]
  return [name, parts], s

def findval(sexpr, attrname):
  parts = sexpr[1]
  matching = [vals for name, vals in parts if name == attrname]
  if len(matching) > 0:
    return matching[0]
  else:
    return None

def setval(sexpr, attrname, newvals):
  for attr in sexpr[1]:
    if attr[0] == attrname:
      attr[1] = newvals
      return
  raise RuntimeError("could not find attribute {}".format(attrname))

def print_sexpr(sexpr, indentlevel=0):
  s = " "*indentlevel + "("
  s += sexpr[0]
  for attr in sexpr[1]:
    s += " "
    if isinstance(attr, list):
      s += print_sexpr(attr)
    elif isinstance(attr, str):
      s += repr(attr)
    elif isinstance(attr, int):
      s += str(attr)
    elif isinstance(attr, float):
      s += str(attr)
    elif isinstance(attr, Identifier):
      s += str(attr.id)
    else:
      # this should be unreachable
      raise NotImplementedError
  s += ")"
  return s



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
  # NOTE: assumes component type designators are alphabetic
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
    # TODO: sort out sheet ref stuff
    return -1


def bareref(ref):
  # NOTE: assumes component type designators are alphabetic
  #print("ref", ref)
  s = ref
  start = 0
  while s[start].isalpha() and len(s) - start > 0:
    start += 1
  if len(s) - start == 0:
    raise RuntimeError("unable to parse ref {}".format(ref))
  num = s[-num_digits:]
  typ = s[:start]
  #print(ret)
  return typ + num

def remapnet(net_name, sheet):
  assert net_name.startswith("\"Net-(")
  # NOTE: assumes component type designators are alphabetic
  net_parts = net_name[len("\"Net-("):].split("-")
  bare = bareref(net_parts[0])
  start = 0
  while bare[start].isalpha() and len(bare) - start > 0:
    start += 1
  if len(bare) - start == 0:
    raise RuntimeError("unable to parse ref {}".format(bare))

  net_parts[0] = bare[:start] + str(sheet) + bare[start:]
  return "\"Net-(" + "-".join(net_parts)


def stripparens(s):
  ret = s
  while (ret[0] == "(" or ret[0] == ")") and len(ret) > 0:
    ret = ret[1:]
  while (ret[-1] == "(" or ret[-1] == ")") and len(ret) > 0:
    ret = ret[:-1]
  return ret


def findmodule(modules, ref):
  for m in modules:
    if bareref(m.reference) == ref:
      return m
  return None


def boundscheck(x, y, left, right, upper, lower):
  return (x >= left and x <= right) and (y >= upper and y <= lower)


def istrackinbounds(unstripped, left, right, upper, lower):
  sexpr, _ = parse_sexpr(unstripped)
  startx = findval(sexpr, "start")[0]
  starty = findval(sexpr, "start")[1]
  endx = findval(sexpr, "end")[0]
  endy = findval(sexpr, "end")[1]
  return (boundscheck(startx, starty, left, right, upper, lower) or 
          boundscheck(endx, endy, left, right, upper, lower))


def isviainbounds(unstripped, left, right, upper, lower):
  sexpr, _ = parse_sexpr(unstripped)
  x = findval(sexpr, "at")[0]
  y = findval(sexpr, "at")[1]
  return boundscheck(x, y, left, right, upper, lower)



def checkmodule(src_module, module):
  # check all offsets to make sure copying won't break anything
  if (module.end_line - module.start_line) != (src_module.end_line - src_module.start_line):
    print("[ERR] module {} does not match {} length".format(module.reference, src_module.reference))
    return False
  if (module.at_line - module.start_line) != (src_module.at_line - src_module.start_line):
    print("[ERR] module {} does not match {} position offset".format(module.reference, src_module.reference))
    return False
  if (module.ref_line - module.start_line) != (src_module.ref_line - src_module.start_line):
    print("[ERR] module {} does not match {} ref offset".format(module.reference, src_module.reference))
    return False
  if (module.path_line - module.start_line) != (src_module.path_line - src_module.start_line):
    print("[ERR] module {} does not match {} path offset".format(module.reference, src_module.reference))
    return False
  if len(module.net_lines) != len(src_module.net_lines):
    print("[ERR] module {} does not match {} number of pads".format(module.reference, src_module.reference))
    return False
  for i, pad_line in enumerate(module.net_lines):
    if (pad_line - module.start_line) != (src_module.net_lines[i] - src_module.start_line):
      print("[ERR] module {} pad {} does not match {}".format(module.reference, i, src_module.reference))
      return False
  return True


def main():
  parser = argparse.ArgumentParser(description="Tiles repeated PCB structures in a Pcbnew board file")
  parser.add_argument("input", help="file to tile")
  parser.add_argument("tile", help="sheet number of the already arranged components, eg. with this set to 3, we'll use components whose references match *3**")
  parser.add_argument("tocopy", help="sheets to tile, eg. 3,4,6-8")
  parser.add_argument("left", help="left bounding box edge")
  parser.add_argument("upper", help="upper bounding box edge")
  parser.add_argument("right", help="right bounding box edge")
  parser.add_argument("lower", help="lower bounding box edge")
  parser.add_argument("xoffset", help="direction in the x direction to offset the repeated sections in mm")
  parser.add_argument("yoffset", help="direction in the y direction to offset the repeated sections in mm")

  args = parser.parse_args()
  src_idx = int(args.tile)
  dst_idxs = list()
  left = float(args.left)
  right = float(args.right)
  upper = float(args.upper)
  lower = float(args.lower)
  xoffset = float(args.xoffset)
  yoffset = float(args.yoffset)
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
  vias = []

  last_trace = None
  removed = list()


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
        if cur_module is None:
          net_parts = quotesplit(stripped)
          net_id = int(stripparens(net_parts[1]))
          net_name = net_parts[2]
          cur_sheet = getsheetnet(stripparens(net_name))
          netmap[net_id] = Net(cur_sheet, net_name)
        else:
          cur_module.net_lines.append(line_num)
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
      elif stripped.startswith("(at ") and cur_module is not None and cur_module.at_line is None:
        cur_module.at_line = line_num
      elif stripped.startswith("(path ") and cur_module is not None and cur_module.path_line is None:
        cur_module.path_line = line_num
      elif stripped.startswith("(fp_text reference") and cur_module is not None:
        cur_module.reference = quotesplit(stripped)[2]
        cur_module.ref_line = line_num
        cursheet = getsheetref(cur_module.reference)
      elif stripped.startswith(")") and paren_count == 2 and cur_module is not None:
        # print("line {}: module end".format(line_num))
        # add module
        cur_module.end_line = line_num
        if modules.get(cursheet) is None:
          modules[cursheet] = list()
        modules[cursheet].append(cur_module)
        cur_module = None
      # NOTE: assumes segments have no newlines
      elif stripped.startswith("(segment "):
        last_trace = line_num
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
        if sheet_idx == src_idx or sheet_idx == -1:
          tracks.append(line_num)
        elif sheet_idx in dst_idxs:
          removed.append(line_num)
        # bounds check with the source bounding box
        # and all the destination bounding boxes
        elif istrackinbounds(l, left, right, upper, lower):
          tracks.append(line_num)
        else:
          for i in range(1, len(dst_idxs) + 1):
            xoff = xoffset * (i + 1)
            yoff = yoffset * (i + 1)
            if istrackinbounds(l, left + xoff, right + xoff, upper + yoff, lower + yoff):
              removed.append(line_num)
              break
      elif stripped.startswith("(via "):
        # net and bounds check like with track
        last_trace = line_num
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
          vias.append(line_num)
        elif sheet_idx in dst_idxs:
          removed.append(line_num)
        # bounds check with the source bounding box
        # and all the destination bounding boxes
        elif isviainbounds(l, left, right, upper, lower):
          vias.append(line_num)
        else:
          for i in range(1, len(dst_idxs) + 1):
            xoff = xoffset * (i + 1)
            yoff = yoffset * (i + 1)
            if isviainbounds(l, left + xoff, right + xoff, upper + yoff, lower + yoff):
              removed.append(line_num)
              break

      paren_count += stripped.count("(") - stripped.count(")")

  print("found {} tileable modules".format(len(modules[src_idx])))
  print("found {} tileable traces".format(len(tracks)))
  print("found {} tileable vias".format(len(vias)))
  print("removing {} traces/vias".format(len(removed)))

  new_traces = list()

  for idx, dst_idx in enumerate(dst_idxs):
    xoff = xoffset * (idx + 1)
    yoff = yoffset * (idx + 1)

    for module in modules[dst_idx]:
      src_module = findmodule(modules[src_idx], bareref(module.reference))

      # check to make sure a line by line copy won't break stuff
      if not checkmodule(src_module, module):
        return

      # change ref, at appropriately
      # For the reference line, basically copy everything except for the actual reference
      new_ref_line = lines[src_module.ref_line]
      ref_parts = new_ref_line.split(" ")
      # find the part that equals "reference" and the reference is the one after it
      ref_idx = None
      for j, p in enumerate(ref_parts):
        if p == "reference":
          ref_idx = j + 1
      ref_parts[ref_idx] = module.reference
      lines[module.ref_line] = " ".join(ref_parts)
      #print("ref line", lines[module.ref_line])

      # For the at line, generate a new at line using the offset
      src_at_line = lines[src_module.at_line]
      src_parts = src_at_line.split(" ")
      at_idx = None
      for j, p in enumerate(src_parts):
        if p == "(at":
          at_idx = j

      xstr = src_parts[at_idx + 1]
      ystr = src_parts[at_idx + 2]
      if (at_idx + 2) == (len(src_parts) - 1):
        ystr = ystr[:-2]
      x = float(xstr)
      y = float(ystr)
        
      src_parts[at_idx + 1] = str(x + xoff)
      src_parts[at_idx + 2] = str(y + yoff)
      if (at_idx + 2) == (len(src_parts) - 1):
        src_parts[at_idx + 2] += ")\n"
      lines[module.at_line] = " ".join(src_parts)
      #print("at line", src_parts)
      #print("at line joined", lines[module.at_line])

      # For the nets, we need to match up pad numbers from the module to the src_module
      # so we can replace them in the new module correctly
      module_nets = dict()
      for n in module.net_lines:
        # NOTE: assumes each net line within a module is preceded by the pad line
        # NOTE: assumes the pad id is the second part of the line
        pad_parts = lines[n - 1].split(" ")
        #print(pad_parts)
        pad_id = pad_parts[5]
        net_line = lines[n]

        module_nets[pad_id] = net_line
      #print(module_nets)

      # copy all the lines that aren't ref, at, or pad
      # +1 to skip the (module header line that we shouldn't modify ever
      for i in range(module.start_line + 1, module.end_line):
        line_offset = i - module.start_line
        src_line_idx = line_offset + src_module.start_line
        if ((src_line_idx not in src_module.net_lines) and 
            (src_line_idx != src_module.path_line) and
            (src_line_idx != src_module.ref_line) and
            (src_line_idx != src_module.at_line)):
          lines[i] = lines[src_line_idx]

      # Now we use the net map from before to swap out the netlines in case
      # the pads are reordered in the new version
      for n in module.net_lines:
        pad_parts = lines[n - 1].split(" ")
        pad_id = pad_parts[5]
        #print("{} -> {}".format(lines[n][:-1], module_nets[pad_id][:-1]))
        lines[n] = module_nets[pad_id]

    xoff = xoffset * (idx + 1)
    yoff = yoffset * (idx + 1)

    # make a copy of the traces to add to new_traces with the net_ids
    # switched out and the position offset
    for track_idx in tracks:
      track_line = lines[track_idx]
      # NOTE: assumes tracks always take up exactly one line
      indentlevel = len(track_line) - len(track_line.lstrip(" "))
      sexpr, _ = parse_sexpr(track_line)
      startx = findval(sexpr, "start")[0]
      starty = findval(sexpr, "start")[1]
      endx = findval(sexpr, "end")[0]
      endy = findval(sexpr, "end")[1]
      net_id = findval(sexpr, "net")[0]
      #print(startx, starty, endx, endy, net_id)
      
      startx += xoff
      starty += yoff
      endx += xoff
      endy += yoff

      setval(sexpr, "start", [startx, starty])
      setval(sexpr, "end", [endx, endy])
      
      if getsheetnet(netmap[net_id].name) == src_idx:
        net_name = remapnet(netmap[net_id].name, dst_idx)
      else:
        net_name = netmap[net_id].name
      #print("{} -> {}".format(netmap[net_id].name, net_name))
      net_id = None
      for i, maybe_net in netmap.items():
        if maybe_net.name == net_name:
          net_id = i
      if net_id == None:
        print("unable to find remapped net {}".format(net_name))
        return
      #print(dst_idx, net_name, net_id)
      setval(sexpr, "net", [net_id])

      new_traces.append(print_sexpr(sexpr, indentlevel) + "\n")
    # copy vias
    for via_idx in vias:
      via_line = lines[via_idx]
      sexpr, _ = parse_sexpr(via_line)
      indentlevel = len(via_line) - len(via_line.lstrip(" "))
      x = findval(sexpr, "at")[0]
      y = findval(sexpr, "at")[1]
      net_id = findval(sexpr, "net")[0]
      #print(startx, starty, endx, endy, net_id)
      
      x += xoff
      y += yoff

      setval(sexpr, "at", [x, y])
      
      if getsheetnet(netmap[net_id].name) == src_idx:
        net_name = remapnet(netmap[net_id].name, dst_idx)
      else:
        net_name = netmap[net_id].name
      #print("{} -> {}".format(netmap[net_id].name, net_name))
      net_id = None
      for i, maybe_net in netmap.items():
        if maybe_net.name == net_name:
          net_id = i
      if net_id == None:
        print("unable to find remapped net {}".format(net_name))
        return
      #print(dst_idx, net_name, net_id)
      setval(sexpr, "net", [net_id])

      new_traces.append(print_sexpr(sexpr, indentlevel) + "\n")

  #print("".join(new_traces))

  # output is the same file as input
  output = args.input
  with open(output, 'w') as f:
    if last_trace is None:
      assert len(new_traces) == 0
      last_trace = 0

    # TODO: write out all the lines
    for i, line in enumerate(lines[:last_trace + 1]):
      if i not in removed:
        f.write(line)
    for line in new_traces:
      f.write(line)
    for line in lines[last_trace + 1:]:
      f.write(line)

if __name__ == "__main__":
  main()
