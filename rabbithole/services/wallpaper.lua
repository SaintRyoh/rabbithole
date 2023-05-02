local beautiful = require("beautiful")
local gears = require("gears")

local Module = {}
Module.__index = Module

function Module.new()
    local self = setmetatable({}, Module)
    screen.connect_signal("property::geometry", self.set_wallpaper)
    
    return self
end
function Module.set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

return Module