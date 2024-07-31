-- create the mtar fs node --

local function _read(n, offset, rdata)
  if offset then seek(offset) end
  local to_read = n
  local data = ""
  while to_read > 0 do
    local n = math.min(#CONST(CHUNKS), to_read)
    to_read = to_read - n
    local chunk = read(n)
    if rdata then data = data .. (chunk or "") end
  end
  return data
end

local function find(f)
  local ent = files[clean_path(f)]
  if not ent then return nil, "file not found" end
  return ent
end

local obj = {}

function obj.exists(f)
  checkArg(1, f, "string")

  return not not find(f)
end

function obj.isDirectory(f)
  local n, e = find(f)

  if n then
    return not not n.children
  else
    return nil, e
  end
end

local function roerr()
  return nil, "device is read-only"
end

local function r0()
  return 0
end

obj.size = r0
obj.lastModified = r0
obj.remove = roerr
obj.makeDirectory = roerr

function obj.list(d)
  local n, e = find(d)

  if not n then return nil, e end
  if not n.children then return nil, "not a directory" end

  local f = {}

  for k, v in pairs(n.children) do
    f[#f+1] = tostring(v)
  end

  return f
end

local function ferr()
  return nil, "bad file descriptor"
end

local _handle = {}

function _handle:read(n)
  checkArg(1, n, "number")
  if self.fptr >= self.node.length then return nil end
  n = math.min(self.fptr + n, self.node.length)
  local data = _read(n - self.fptr, self.fptr + self.node.offset, true)
  self.fptr = n
  if #data == 0 then return nil end
  return data
end

_handle.write = roerr

function _handle:seek(origin, offset)
  checkArg(1, origin, "string")
  checkArg(2, offset, "number", "nil")
  local n = (origin == "cur" and self.fptr) or (origin == "set" and 0) or
    (origin == "end" and self.node.length) or
    (error("bad offset to 'seek' (expected one of: cur, set, end, got "
      .. origin .. ")"))
  n = n + (offset or 0)
  if n < 0 or n > self.node.length then
    return nil, "cannot seek there"
  end
  self.fptr = n
  return n
end

function _handle:close()
  if self.closed then
    return ferr()
  end

  self.closed = true
end

function obj.open(f, m)
  checkArg(1, f, "string")
  checkArg(2, m, "string")

  if m:match("[w%+]") then
    return nil, "device is read-only"
  end

  local n, e = find(f)

  if not n then return nil, e end
  if n.children then return nil, "is a directory" end

  local new = setmetatable({
    name = f,
    node = n,
    mode = m,
    fptr = 0
  }, {__index = _handle})

  return new
end

function obj.read(h, a)
  return h:read(a)
end

function obj.write(h, d)
  return h:write(d)
end

function obj.seek(h, ...)
  return h:seek(...)
end

function obj.close(h)
  return h:close()
end

function obj.getLabel() return "mtarfs" end

obj.type = "filesystem"
obj.address = "mtarfs("..MTAR_ADDRESS..")"
_G.mtarfs = obj
