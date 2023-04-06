local gears = require("gears")

local config_dir = gears.filesystem.get_configuration_dir()

-- The 5.2 modules will sometimes work for us,
-- but we need to use the real version for the cpath
local version = '5.2' 
local realVersion = _VERSION:match("%d+%.%d+")
  
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
   config_dir .. 'lua_modules/lib/lua/' .. realVersion .. '/?.so'
}

for _, path in ipairs(paths) do
    package.path = package.path .. ';' .. path
end

for _, path in ipairs(cpaths) do
    package.cpath = package.cpath .. ';' .. path
end