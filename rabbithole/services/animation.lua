local gears = require("gears")

local AnimationAbstractFactory = {}
AnimationAbstractFactory.__index = AnimationAbstractFactory

RUBATO_DIR = gears.filesystem.get_configuration_dir() .. "sub/rubato/"

local rubato = require("sub/rubato")

function AnimationAbstractFactory.new(settings)
    local self = setmetatable({}, AnimationAbstractFactory)

    self.settings = settings 

    return self
end

function AnimationAbstractFactory:get_basic_animation()
    return rubato.timed {
        intro = 0.1,
        duration = 0.3,
        pos = 1
    }
end

function AnimationAbstractFactory.blend_colors(color1, color2, percentage)
  -- Convert the hex strings to RGB values
  local r1, g1, b1 = tonumber(color1:sub(2, 3), 16), tonumber(color1:sub(4, 5), 16), tonumber(color1:sub(6, 7), 16)
  local r2, g2, b2 = tonumber(color2:sub(2, 3), 16), tonumber(color2:sub(4, 5), 16), tonumber(color2:sub(6, 7), 16)

  -- Calculate the blended RGB values
  local r3 = math.floor((r1 * percentage / 100) + (r2 * (100 - percentage) / 100))
  local g3 = math.floor((g1 * percentage / 100) + (g2 * (100 - percentage) / 100))
  local b3 = math.floor((b1 * percentage / 100) + (b2 * (100 - percentage) / 100))

  -- Convert the blended RGB values back to a hex string
  local color3 = string.format("#%02X%02X%02X", r3, g3, b3)

  return color3
end



return AnimationAbstractFactory