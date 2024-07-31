-- Bare status implementation.

local w, h = gpu.maxResolution()
gpu.setResolution(gpu.maxResolution())
gpu.fill(1, 1, w, h, " ")
gpu.setForeground(0)
gpu.setBackground(0xFFFFFF)
local text = "MTAR Loader"
gpu.set(1, 1, (" "):rep(math.floor((w-#text)/2))..text..(" "):rep(math.ceil((w-#text)/2)))
gpu.setBackground(0)
gpu.setForeground(0xFFFFFF)

local y = 1
local x = 1
local function status(t, c, last)
  if not last then
    y = y + 1
    x = 1
    if y >= h then
      gpu.copy(1, 3, w, h, 0, -1)
      gpu.fill(1, h, w, 1, " ")
      y = y - 1
    end
  end
  if c then gpu.fill(x, y, w, 1, " ") end
  gpu.set(x, y, t)
  if not last then x = #t+1 end
end


