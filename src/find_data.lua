-- Find the data section.

status("Seeking to data section ")

local offset = 0

while true do
  spinner()
  local chunk = read(#CONST(CHUNKS))
  offset = offset + #chunk

  if chunk:match("\90") then
    offset = offset - (#CONST(CHUNKS) - chunk:find("\90"))
    seek(offset)
    break
  end
end

assert(read(1) == "\n")
