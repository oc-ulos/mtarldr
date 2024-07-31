-- read MTAR headers

local function read_header()
  local chunk = read(#CONST(CHUNKS_HEADER))
  if (not chunk) or #chunk < 14 then return nil end
  -- skip V1 header
  chunk = chunk:sub(4)
  -- name length
  local namelen = string.unpack(">I2", chunk:sub(1,2))
  local name = chunk:sub(3, 3+namelen-1)
  chunk = chunk:sub(#name + 3)

  local remaining = #chunk - 8
  local flen = string.unpack(">I8", chunk:sub(1,8)) - remaining
  local offset = seek(0, "cur") - remaining
  spinner()
  seek(flen, "cur")
  add_to_tree(name, offset, flen + remaining)
  return true
end

