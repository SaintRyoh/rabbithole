local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi
local color = require("sub.bling.helpers.color")
local max = math.max
local min = math.min
local pow = math.pow
local floor = math.floor
local random = math.random

local ColorService = color
ColorService.__index = ColorService

-- Constructor for ColorService
function ColorService.new()
    local self = {}
    setmetatable(self, ColorService)

    return self
end

-- Clips the input value to the specified interval
-- @param num The value to be clipped
-- @param min_num The lower bound of the interval
-- @param max_num The upper bound of the interval
-- @return The clipped value
function ColorService:clip(num, min_num, max_num)
    return max(min(num, max_num), min_num)
end

-- Converts a hex color to normalized rgba format
-- @param color The hex color to be converted
-- @return The rgba color in normalized format
function ColorService:hex2rgb(color)
    return parse_color(color)
end

-- Converts a hex color to hsv format
-- @param color The hex color to be converted
-- @return The hsv color
function ColorService:hex2hsv(color)
    local r, g, b = self:hex2rgb(color)
    local C_max = max(r, g, b)
    local C_min = min(r, g, b)
    local delta = C_max - C_min
    local H, S, V
    if delta == 0 then
        H = 0
    elseif C_max == r then
        H = 60 * (((g - b) / delta) % 6)
    elseif C_max == g then
        H = 60 * (((b - r) / delta) + 2)
    elseif C_max == b then
        H = 60 * (((r - g) / delta) + 4)
    end
    if C_max == 0 then
        S = 0
    else
        S = delta / C_max
    end
    V = C_max
    return H, S * 100, V * 100
end

-- Converts an hsv color to hex format
-- @param H The hue component of the hsv color
-- @param S The saturation component
-- @param V The value component of the hsv color
-- @return The hex color
function ColorService:hsv2hex(H, S, V)
    S = S / 100
    V = V / 100
    if H > 360 then H = 360 end
    if H < 0 then H = 0 end
    local C = V * S
    local X = C * (1 - math.abs(((H / 60) % 2) - 1))
    local m = V - C
    local r_, g_, b_ = 0, 0, 0
    if H >= 0 and H < 60 then
        r_, g_, b_ = C, X, 0
    elseif H >= 60 and H < 120 then
        r_, g_, b_ = X, C, 0
    elseif H >= 120 and H < 180 then
        r_, g_, b_ = 0, C, X
    elseif H >= 180 and H < 240 then
        r_, g_, b_ = 0, X, C
    elseif H >= 240 and H < 300 then
        r_, g_, b_ = X, 0, C
    elseif H >= 300 and H < 360 then
        r_, g_, b_ = C, 0, X
    end
    local r, g, b = (r_ + m) * 255, (g_ + m) * 255, (b_ + m) * 255
    return ("#%02x%02x%02x"):format(floor(r), floor(g), floor(b))
end

-- Calculates the relative luminance of a given color
-- @param color The hex color whose relative luminance is to be calculated
-- @return The relative luminance of the given color
function ColorService:relative_luminance(color)
    local r, g, b = self:hex2rgb(color)
    local function from_sRGB(u)
        return u <= 0.0031308 and 25 * u / 323 or
                   pow(((200 * u + 11) / 211), 12 / 5)
    end
    return 0.2126 * from_sRGB(r) + 0.7152 * from_sRGB(g) + 0.0722 * from_sRGB(b)
end

-- Calculates the contrast ratio between two given colors
-- @param fg The foreground color
-- @param bg The background color
-- @return The contrast ratio between the two colors
function ColorService:contrast_ratio(fg, bg)
    return (self:relative_luminance(fg) + 0.05) / (self:relative_luminance(bg) + 0.05)
end

-- Determines if the contrast between two given colors is acceptable
-- @param fg The foreground color
-- @param bg The background color
-- @return True if the contrast is acceptable, false otherwise
function ColorService:is_contrast_acceptable(fg, bg)
    return self:contrast_ratio(fg, bg) >= 7 and true
end

-- Returns a bright-ish, saturated-ish color of random hue
-- @param lb_angle The lower bound of the hue angle
-- @param ub_angle The upper bound of the hue angle
-- @return A hex color with random hue
function ColorService:rand_hex(lb_angle, ub_angle)
    return self:hsv2hex(random(lb_angle or 0, ub_angle or 360), 70, 90)
end

-- Rotates the hue of a given hex color by the specified angle (in degrees)
-- @param color The hex color whose hue is to be rotated
-- @param angle The angle by which the hue is to be rotated
-- @return The hex color with the rotated hue
function ColorService:rotate_hue(color, angle)
    local H, S, V = self:hex2hsv(color)
    angle = self:clip(angle or 0, 0, 360)
    H = (H + angle) % 360
    return self:hsv2hex(H, S, V)
end

-- Lightens a given hex color by the specified amount
-- @param color The hex color to be lightened
-- @param amount The amount by which the color should be lightened
-- @return The lightened hex color
function ColorService:lighten(color, amount)
    local r, g, b
    r, g, b = self:hex2rgb(color)
    r = 255 * r
    g = 255 * g
    b = 255 * b
    r = r + floor(2.55 * amount)
    g = g + floor(2.55 * amount)
    b = b + floor(2.55 * amount)
    r = r > 255 and 255 or r
    g = g > 255 and 255 or g
    b = b > 255 and 255 or b
    return ("#%02x%02x%02x"):format(r, g, b)
end

-- Darkens a given hex color by the specified amount
-- @param color The hex color to be darkened
-- @param amount The amount by which the color should be darkened
-- @return The darkened hex color
function ColorService:darken(color, amount)
    local r, g, b
    r, g, b = self:hex2rgb(color)
    r = 255 * r
    g = 255 * g
    b = 255 * b
    r = max(0, r - floor(r * (amount / 100)))
    g = max(0, g - floor(g * (amount / 100)))
    b = max(0, b - floor(b * (amount / 100)))
    return ("#%02x%02x%02x"):format(r, g, b)
end

return ColorService

