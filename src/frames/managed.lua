-- bare managed filesystem loader

local fs = component.proxy(computer.getBootAddress())
local gpu = component.proxy(component.list("gpu")())
gpu.bind(gpu.getScreen() or (component.list("screen")()))

local handle = assert(fs.open("#CONST(FILENAME).lua", "r"))

--#include src/status/bare.lua

local function read(n)
  return fs.read(handle, n)
end

local function seek(n, from)
  return fs.seek(handle, from or "set", n or 0)
end

MTAR_ADDRESS = fs.address
