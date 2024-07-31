local function split_path(path)
  local s = {}
  for _s in path:gmatch("[^\\/]+") do
    if _s == ".." then
      s[#s] = nil
    elseif s ~= "." then
      s[#s+1]=_s
    end
  end
  return s
end

local function clean_path(name)
  return table.concat(split_path(name), "/")
end

-- filesystem tree
local files = {
  ["/"] = {children = {}}
}

local function add_to_tree(name, offset, len)
  local cleaned = clean_path(name)
  local segments = split_path(name)

  for i=1, #segments do
    local path = table.concat(segments, "/", 1, i-1)
    files[path] = files[path] or {children = {}}
    local add = true

    for _, child in pairs(files[path].children) do
      if child == segments[i] then add = false  break end
    end
    
    if add then files[path].children[#files[path].children+1] = segments[i] end
  end

  files[cleaned] = {offset = offset, length = len}
end
