local awful = require("awful")

local DpiCalculator = { }
DpiCalculator.__index = DpiCalculator

function DpiCalculator.new()
    local self = setmetatable({ }, DpiCalculator)

    return self
end

function DpiCalculator:calculate_dpi(width_pixels, height_pixels, width_mm, height_mm)
    local diagonal_pixels = math.sqrt((width_pixels^2) + (height_pixels^2))
    local diagonal_mm = math.sqrt((width_mm^2) + (height_mm^2))
    local diagonal_inches = diagonal_mm / 25.4
    local dpi = diagonal_pixels / diagonal_inches
    return dpi
end

function DpiCalculator:parse_xrandr_output(output)
    local screens = {}
    for line in output:gmatch("[^\r\n]+") do
        local screen_name, width_pixels, height_pixels, width_mm, height_mm = line:match("(%S+) connected (%d+)x(%d+)%+%d+%+%d+ %(normal left inverted right x axis y axis%) (%d+)mm x (%d+)mm")
        if screen_name and width_pixels and height_pixels and width_mm and height_mm then
            screens[screen_name] = {
                width_pixels = tonumber(width_pixels),
                height_pixels = tonumber(height_pixels),
                width_mm = tonumber(width_mm),
                height_mm = tonumber(height_mm)
            }
        end
    end
    return screens
end

function DpiCalculator:get_screen_dpi()
    local screen_dpi = {}
    awful.spawn.easy_async("xrandr", function(stdout)
        local screens = self:parse_xrandr_output(stdout)
        for screen_name, dimensions in pairs(screens) do
            local dpi = self:calculate_dpi(dimensions.width_pixels, dimensions.height_pixels, dimensions.width_mm, dimensions.height_mm)
            screen_dpi[screen_name] = dpi
        end
    end)
    return screen_dpi
end

return DpiCalculator
