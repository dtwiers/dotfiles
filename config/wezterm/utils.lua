local result = {}
local wezterm = require("wezterm")

local function getOS()
    if string.find(wezterm.target_triple, "windows") ~= nil then
        return "windows"
    elseif string.find(wezterm.target_triple, "linux") ~= nil then
        return "linux"
    elseif string.find(wezterm.target_triple, "darwin") ~= nil then
        return "macos"
    end
    -- Pretty sure this will never happen...
    return "unknown"
end

result.os = getOS()

return result
