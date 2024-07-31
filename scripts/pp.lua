#!/usr/bin/env lua
-- pp: generic simple preprocessor

local defined = {}
local included = {}
local directives = {}

local function split(text)
  local words = {}
  for word in text:gmatch("[^ ]+") do
    words[#words+1] = word
  end
  return table.remove(words, 1), words
end

local function process(fd)
  for line in fd:lines() do
    line = line:gsub("#CONST%(([^%)]+)%)", function(def)
      if not defined[def] then
        io.stderr:write("pp: undefined constant ", def, "\n")
        os.exit(1)
      end
      return defined[def]
    end)

    if line:sub(1,3) == "--#" then
      local direct, args = split(line:sub(4))

      if not directives[direct] then
        io.stderr:write("pp: unhandled directive\n")
        os.exit(1)
      end

      directives[direct](table.unpack(args))

    else
      io.write(line,"\n")
    end
  end
end

local function process_file(file)
  local hand, err = io.open(file, "r")
  if not hand then
    io.stderr:write("pp: ", err, "\n")
    os.exit(1)
  end

  process(hand)
  hand:close()
end

function directives.define(k, ...)
  local v = table.concat({...}, " ")
  defined[k] = tonumber(v) or v or true
end

function directives.include(file)
  process_file(file)
end

function directives.includeif(var, file)
  if defined[var] then process_file(file) end
end

for i=1, #arg do
  local a = arg[i]

  if a:sub(1,1) == "-" then
    if a:sub(1,2) == "-d" then
      defined[a:sub(3)] = true

    elseif a:sub(1,2) == "-D" then
      for line in io.lines(arg[i]:sub(3)) do
        local k, v = line:match("([^ ]+) *(.*)")
        defined[k or line] = tonumber(v) or v or true
      end

    else
      io.stderr:write("pp: unknown option\n")
      os.exit(1)
    end

  else
    process_file(a)
  end
end
