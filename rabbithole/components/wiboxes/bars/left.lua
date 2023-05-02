local awful = require("awful")

return setmetatable({}, {
    __constructor = function()
        return function (s)
            local options = {
                screen = s,
                placement = awful.placement.top_left,
            }
            return require("rabbithole.components.wiboxes.bars.mini-bar")(options)
        end
    end
})