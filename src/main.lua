-- self-extracting mtar loader thingy: header --
-- Expects an MTAR v1 archive.  Will not work with v0 or v2.

--#include src/frames/#CONST(PLATFORM).lua
--#include src/spinner.lua
--#include src/find_data.lua
--#include src/utils.lua
--#include src/header/mtar.lua

status("Reading file headers... ")
repeat until not read_header()

--#include src/fakefs.lua

status("Loading kernel...")

local hdl = assert(obj.open("#CONST(BOOT_FILE)", "r"))
local ldme = hdl:read(hdl.node.length)
hdl:close()

status("Final collectgarbage()...")
for i=1, 20 do
  computer.pullSignal(0)
end

assert(load(ldme, "=mtarfs:#CONST(BOOT_FILE)", "t", _G))(#CONST(BOOT_ARGS))

-- concatenate mtar data past this line
--[=======[Z
