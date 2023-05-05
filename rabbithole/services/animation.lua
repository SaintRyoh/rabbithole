local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local AnimationAbstractFactory = {}
AnimationAbstractFactory.__index = AnimationAbstractFactory

RUBATO_DIR = "sub.rubato."
RUBATO_MANAGER = require("sub.rubato.manager")

local rubato = require("sub.rubato")

function AnimationAbstractFactory.new(settings)
    local self = setmetatable({}, AnimationAbstractFactory)

    self.settings = settings 

    return self
end

function AnimationAbstractFactory:get_basic_animation()
    return rubato.timed {
        intro = 0.1,
        duration = 0.3,
        clamp_position = true,
    }
end

function AnimationAbstractFactory:blend_colors(color1, color2, percentage)
    if percentage > 1 then
        percentage = 1
    end

    if percentage < 0 then
        percentage = 0
    end

  -- Convert the hex strings to RGB values
  local r1, g1, b1 = tonumber(color1:sub(2, 3), 16), tonumber(color1:sub(4, 5), 16), tonumber(color1:sub(6, 7), 16)
  local r2, g2, b2 = tonumber(color2:sub(2, 3), 16), tonumber(color2:sub(4, 5), 16), tonumber(color2:sub(6, 7), 16)

  -- Calculate the blended RGB values
  local r3 = math.floor((r2 * percentage) + (r1 * (1 - percentage)))
  local g3 = math.floor((g2 * percentage) + (g1 * (1 - percentage)))
  local b3 = math.floor((b2 * percentage) + (b1 * (1 - percentage)))

  -- Convert the blended RGB values back to a hex string
  local color3 = string.format("#%02X%02X%02X", r3, g3, b3)

  return color3
end

function AnimationAbstractFactory:create_widget_bg(color1, color2, func)
    if func then
        color1 = func(color1)
        color2 = func(color2)
    end
    return gears.color {
        type = "linear",
        from = { 0, 0 },
        to = { 0, dpi(40) },
        stops = {
            { 0,   color1 },
            { 0.5, color2 },
            { 1,   color1 },
        }
    }
end

return AnimationAbstractFactory