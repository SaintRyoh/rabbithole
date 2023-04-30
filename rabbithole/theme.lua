local beautiful = require("beautiful")
local gears = require("gears")


return setmetatable({}, {
    __constructor = function (settings)
        if gears.filesystem.file_readable(gears.filesystem.get_configuration_dir() .. settings.theme_dir) then
            beautiful.init(gears.filesystem.get_configuration_dir() .. settings.theme_dir)
        else
            beautiful.init("themes/zenburn/theme.lua")
        end
        return beautiful.get()
    end,
})