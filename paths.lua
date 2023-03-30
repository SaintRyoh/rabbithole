local gears = require("gears")

local config_dir = gears.filesystem.get_configuration_dir()
local version = '5.2' --_VERSION:match("%d+%.%d+")
  
local paths = {
    './?.lua',
    './?/init.lua',
    'lua_modules/share/lua/' .. version .. '/?.lua',
    'lua_modules/share/lua/' .. version .. '/?/init.lua',
    config_dir .. '?.lua',
    config_dir ..'?/init.lua',
    config_dir .. 'lua_modules/share/lua/' .. version .. '/?.lua',
    config_dir .. 'lua_modules/share/lua/' .. version .. '/?/init.lua'
}

local cpaths = {
    'lua_modules/lib/lua/' .. version .. '/?.so'
}

for _, path in ipairs(paths) do
    package.path = package.path .. ';' .. path
end

for _, path in ipairs(cpaths) do
    package.cpath = package.cpath .. ';' .. path
end