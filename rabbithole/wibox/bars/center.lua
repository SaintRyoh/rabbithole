local awful = require("awful")

return setmetatable({}, {
    __constructor = function()
        return function (s)
            local options = {
                screen = s,
                placement = awful.placement.top,
            }
            return require("rabbithole.wibox.bars.mini-bar")(options)
        end
    end
})