local function script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)")
end

local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

local function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}                 
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end

return {
    file_exists = file_exists,
    lines_from = lines_from,
    script_path = script_path
}


