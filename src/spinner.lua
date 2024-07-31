local spinner

do

local seq = {"|","/","-","\\"}
local last = computer.uptime()
local stage = 0

spinner = function()
  local t = computer.uptime()
  if t - last >= #CONST(SPINTERVAL) then
    last = t
    stage = (stage % 4) + 1
    status(seq[stage], nil, true)
  end
end

end
