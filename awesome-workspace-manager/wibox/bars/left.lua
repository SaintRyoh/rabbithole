local awful = require("awful")
local wibox = require("wibox")



return setmetatable({}, {
    __constructor = function()
        return function (s)
            local options = {
                screen = s,
                placement = awful.placement.top,
            }
            return require("awesome-workspace-manager.wibox.bars.mini-bar")(options)
        end
    end
})