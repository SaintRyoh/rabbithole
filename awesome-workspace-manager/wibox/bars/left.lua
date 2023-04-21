local awful = require("awful")

return setmetatable({}, {
    __constructor = function()
        return function (s)
            local options = {
                screen = s,
                placement = awful.placement.top_left,
            }
            return require("awesome-workspace-manager.wibox.bars.mini-bar")(options)
        end
    end
})