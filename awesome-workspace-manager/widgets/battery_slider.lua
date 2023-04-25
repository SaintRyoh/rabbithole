local awful = require("awful")
local beautiful = require("beautiful")
local Slider = require("slider")

local brightnessSlider = {}


function brightnessSlider.new(args)
    local self = {}
    setmetatable(self, { __index = brightnessSlider })

    local slider_args = {
        icon = beautiful.brightness_icon or "/path/to/your/brightness_icon.svg",
        value = self:getCurrentBrightness(),
        minimum = 0,
        maximum = 100,
        animation_callback = function(value)
            self:animateBrightnessChange(value)
        end
    }

    self.widget = Slider.new(slider_args).widget

    return self
end

function brightnessSlider:getCurrentBrightness()
    local output = awful.spawn.easy_async("xbacklight -get", function(stdout)
        return tonumber(stdout:match("(%d+)"))
    end)
    return output or 50
end

function brightnessSlider:setBrightness(value)
    awful.spawn.easy_async("xbacklight -set " .. value, function()
        -- You can add a callback function here if needed
    end)
end

function brightnessSlider:animateBrightnessChange(target_value)
    local current_value = self:getCurrentBrightness()
    local step = (target_value - current_value) / 10

    for i = 1, 10 do
        gears.timer.delayed_call(function()
            local new_value = current_value + i * step
            self:setBrightness(new_value)
        end, i * 0.05)
    end
end

return brightnessSlider
