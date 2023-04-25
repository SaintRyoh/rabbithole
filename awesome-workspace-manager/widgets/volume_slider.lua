local awful = require("awful")
local beautiful = require("beautiful")
local Slider = require("slider")

local volumeSlider = {}

function volumeSlider.new(args)
    local self = {}
    setmetatable(self, { __index = volumeSlider })

    local slider_args = {
        icon = beautiful.volume_icon or "/path/to/your/volume_icon.svg",
        value = self:getCurrentVolume(),
        minimum = 0,
        maximum = 100,
        animation_callback = function(value)
            self:animateVolumeChange(value)
        end
    }

    self.widget = Slider.new(slider_args).widget

    return self
end

function volumeSlider:getCurrentVolume()
    local output = awful.spawn.easy_async("amixer get Master | awk -F'[][]' '/%/ { print $2 }'", function(stdout)
        return tonumber(stdout:match("(%d+)"))
    end)
    return output or 50
end

function volumeSlider:setVolume(value)
    awful.spawn.easy_async("amixer set Master " .. value .. "%", function()
        -- You can add a callback function here if needed
    end)
end

function volumeSlider:animateVolumeChange(target_value)
    local current_value = self:getCurrentVolume()
    local step = (target_value - current_value) / 10

    for i = 1, 10 do
        gears.timer.delayed_call(function()
            local new_value = current_value + i * step
            self:setVolume(new_value)
        end, i * 0.05)
    end
end

return volumeSlider
