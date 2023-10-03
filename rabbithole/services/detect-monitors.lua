local awful = require("awful")
local naughty = require("naughty")

local function setup_screens()
    awful.spawn("autorandr --change")
end

return setmetatable({}, {
    __constructor = function()
        screen.connect_signal("list", function()
            naughty.notify({
                title = "Screen setup changed",
                text = "Configuring displays..."
            })
            setup_screens()
        end)
    end,
})
