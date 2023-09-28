local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi
local blcolor = require("sub.bling.helpers.color")
local math = math
local colors = require("rabbithole.services.tesseractThemeEngine.colors")
-- use the lighten and darken functions from the nice submodule
local nice_colors = require("sub.nice.colors")
local darken, lighten = nice_colors.darken, nice_colors.lighten
local max, min, floor, random = math.max, math.min, math.floor, math.random
local detect_orientation = require("rabbithole.services.widetect").orientation_is
--[[ This is the color service for Tesseract. 

Capable of manipulating colors in almost every conceivable way.Inherits 
and expands upon the color service from bling.
]]

local ColorService = blcolor
ColorService.__index = ColorService

function ColorService.new(settings)
    local self = setmetatable({ }, ColorService)

    --self.settings = settings -- THIS DOES NOT INJECT PROPERLY, COMES UP `nil`

    return self
end

 -- Blends two colors together based on a given percentage
-- @param color1 The first color in hex format
-- @param color2 The second color in hex format
-- @param percentage A number between 0 and 1 representing the blend percentage
-- @return A hex string of the blended color
function ColorService.blend_colors(color1, color2, percentage)
    percentage = math.min(math.max(percentage, 0), 1)
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

-- [[[ GRADIENTS - These are used to add depth to widget appearance.

-- Creates a background for a widget using two colors and a linear gradient
-- @param base_color The first color in the gradient
-- @param secondary_color The second color in the gradient
-- @return A gears.color object representing the linear gradient background
function ColorService.create_widget_bg(base_color, secondary_color)
    local secondary_color_light = lighten(secondary_color, 40)
    local base_color_dark = darken(base_color, 90)
    return gears.color {
        type = "linear",
        from = { 0, 0 },
        to = { 0, 1000},
        stops = {
            { 0,   secondary_color_light },  -- start with the lighter color
            { 0.2, secondary_color },  -- switch to the base color fairly quickly
            { 0.5, base_color },  -- transition to the darkened base color at the middle
            { 0.8, base_color_dark },  -- switch to base color again
            { 1,   base_color_dark },  -- finish with the darker color
        }
    }
end

-- Create an extremely 3d gradient for a widget with a single color
-- This should closely emulate the way 'nice' creates its titlebars (light top--dark bottom, single color)
function ColorService.oneColorTrue3d(color)
    local color1 = lighten(color, 40)
    local color2 = color
    local color3 = darken(color, 40)

    return gears.color {
        type = "linear",
        from = { 0, 0 },
        to = { 0, dpi(40) },
        stops = {
            { 0,   color1 },
            { 0.5, color2 },
            { 1,   color3 },
        }
    }
end

-- Created a 3d background widget that takes two colors and creates a linear gradient
-- @param base The first color in the gradient
-- @param secondary The second color in the gradient
-- @return A gears.color object representing the linear gradient background
function ColorService.twoColorTrue3d(base, secondary, height)
    local top_color = colors["White"]
    local base_light = lighten(base, 30)
    local bottom_color = darken(base, 45)

    return gears.color {
        type = "linear",
        from = { 0, 0 },
        to = { 0, dpi(34) },
        stops = {
            { 0,   top_color },
            { 0.1, secondary },
            { 0.35, base_light },
            { 0.8, base },
            { 1,   bottom_color },
        }
    }
end

function ColorService:smartGradient(base, secondary, height, width)
    local top_color = colors["White"]
    local base_light = lighten(base, 30)
    local bottom_color = darken(base, 45)

    if not height then
        height = dpi(34)
    end

    local orientation = detect_orientation(height, width)

    local gradientDirection
    if orientation == "horizontal" then
        gradientDirection = { from = { 0, 0 }, to = { width, 0 } }
    else -- assume vertical for any other return value
        gradientDirection = { from = { 0, 0 }, to = { 0, height } }
    end

    return gears.color {
        type = "linear",
        from = gradientDirection.from,
        to = gradientDirection.to,
        stops = {
            { 0,   top_color },
            { 0.1, secondary },
            { 0.35, base_light },
            { 0.8, base },
            { 1,   bottom_color },
        }
    }
end

-- Created a 3d background widget that takes two colors and a gradient
-- @param base The first color in the gradient
-- @param secondary The second color in the gradient
-- @param percentage The percentage of the gradient to show (0-1)
-- @return A gears.color object with both colors and lightening and darkening applied.
function ColorService.twoColorTrue3dFlat(base, secondary, percentage)
    local bottom_color = darken(base, 50)
    local top_color = lighten(secondary, 30)
    local base_light = lighten(base, 30)

    local stops = {
        { 0,   top_color },
        { 0.2, secondary },
        { 0.35, base_light },
        { 0.8, base },
        { 1,   bottom_color },
    }

    if percentage <= 0 then
        stops = {
            { 0, base },
            { 1, base }
        }
    elseif percentage <= 1 then
        local stop_index = math.floor(percentage / 0.25) + 1
        stops[stop_index][1] = percentage * 0.8
    end

    return gears.color {
        type = "linear",
        from = { 0, 0 },
        to = { 0, dpi(40) },
        stops = stops
    }
end

-- Creates a background for a widget using one color and gives a metallic appearance
-- @param color1 The color to use for the gradient
-- @return A gears.color object representing the linear gradient background
function ColorService.metallicTrue3d(color1)
    local color2 = lighten(color1, 30)
    local color3 = darken(color1, 30)

    return gears.color {
        type = "linear",
        from = { 0, 0 },
        to = { 0, dpi(40) },
        stops = {
            { 0,   color3 },  -- start with the dark color
            { 0.2, color2 },  -- switch to the light color fairly quickly
            { 0.5, color1 },  -- transition to the base color at the middle
            { 0.8, color2 },  -- switch back to the light color
            { 1,   color3 },  -- finish with the dark color
        }
    }
end


-- Creates a linear gradient for a mildy 3D effect
-- @param color1 The first color in the gradient
-- @param color2 The second color in the gradient
-- @return A gears.color object representing the linear gradient
function ColorService.twoColorLinearGradient(color1, color2)
    return gears.color {
        type = "linear",
        from = { 0, 0 },
        to = { 0, 20 }, -- you can adjust this value to change the direction of the gradient
        stops = {
            { 0, color1 },
            { 1, color2 },
        }
    }
end

-- Creates a radial gradient for a 3D effect
-- @param color1 The first color in the gradient
-- @param color2 The second color in the gradient
-- @return A table describing the radial gradient
function ColorService.createRadialGradient(color1, color2)
    return {
        type = "radial",
        from = { 0, 0 },
        to = { 0, 0 },
        radius = dpi(20),
        stops = {
            { 0, color1 },
            { 1, color2 },
        }
    }
end

-- Creates a shadow for a 3D effect
-- @param color1 The first color in the gradient
-- @param color2 The second color in the gradient
-- @param direction The direction of the shadow
function ColorService.create_linear_shadow(color1, color2, direction)
    return gears.color {
        type = "linear",
        from = { 0, 0 },
        to = { 0, direction }, -- the direction controls the gradient direction
        stops = {
            { 0, color1 },
            { 1, color2 },
        }
    }
end

-- Applies a 3D effect to a widget
-- @param widget The widget to apply the 3D effect to
-- @param color1 The first color for the radial gradient
-- @param color2 The second color for the radial gradient
-- @param shadow_radius The radius of the shadow's rounded corners
-- @param shadow_offset The offset of the shadow
function ColorService:apply_3d_effect(widget, color1, color2, shadow_radius, shadow_offset)
    local shadow = self:create_shadow(shadow_radius, shadow_offset)
    local gradient = self.create_radial_gradient(color1, color2)

    widget:set_bg(gradient)
    widget:set_shape(function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, shadow_radius)
    end)
    widget:set_shape_clip(true)
    widget:set_shape_border_width(dpi(1))
    widget:set_shape_border_color(shadow.color)
end

-- Helper function to create a widget with softed edges
-- Function to create a widget background gradient with edges in a softer, almost white gradient
-- @param start_color The color at the start of the gradient
-- @param end_color The color at the end of the gradient
-- @return A string object representing the widget with soft edges
function ColorService.create_widget_soft(start_color, end_color)
    return function(cr, width, height, x, y)
            local start_x, start_y = x, y
            local end_x, end_y = x + width, y + height
            local pat_top = gears.color.create_linear_pattern({ start_x, start_y }, { start_x, start_y + height/5 }, { end_color, start_color })
            local pat_bottom = gears.color.create_linear_pattern({ start_x, end_y }, { start_x, end_y - height/5 }, { start_color, end_color })
            local pat_left = gears.color.create_linear_pattern({ start_x, start_y }, { start_x + width/5, start_y }, { end_color, start_color })
            local pat_right = gears.color.create_linear_pattern({ end_x, start_y }, { end_x - width/5, start_y }, { start_color, end_color })
            local pat_center = gears.color.create_linear_pattern({ start_x, start_y + height/5 }, { start_x, end_y - height/5 }, { start_color, start_color })

            gears.shape.rectangle(cr, width, height)

            cr:set_source(pat_top)
            cr:rectangle(start_x, start_y, width, height/5)
            cr:fill()

            cr:set_source(pat_bottom)
            cr:rectangle(start_x, end_y - height/5, width, height/5)
            cr:fill()

            cr:set_source(pat_left)
            cr:rectangle(start_x, start_y, width/5, height)
            cr:fill()

            cr:set_source(pat_right)
            cr:rectangle(end_x - width/5, start_y, width/5, height)
            cr:fill()

            cr:set_source(pat_center)
            cr:rectangle(start_x + width/5, start_y + height/5, width*3/5, height*3/5)
            cr:fill()
    end
end


-- END GRADIENTS ]]]

-- [[[ CONVERSIONS - For converting colors to other values (RGB, HSL, HEX)

-- Converts a hex color to normalized rgba format
-- @param color The hex color to be converted
-- @return The rgba color in normalized format
function ColorService:hex2rgb(color)
    return gears.color.parse_color(color)
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

function ColorService:hsl2rgb(h, s, l)
    local r, g, b
    if s == 0 then
        r, g, b = l, l, l
    else
        local hue_to_rgb = function(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end

        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q

        r = hue_to_rgb(p, q, h + 1/3)
        g = hue_to_rgb(p, q, h)
        b = hue_to_rgb(p, q, h - 1/3)
    end

    return r * 255, g * 255, b * 255
end

-- END CONVERSIONS ]]]

-- [[[ CONSTRAST - These functions calculate/generate contasts

-- Calculates the relative luminance of a given color
-- @param color The hex color whose relative luminance is to be calculated
-- @return The relative luminance of the given color
function ColorService:relative_luminance(color)
    local r, g, b = self:hex2rgb(color)
    local function from_sRGB(u)
        return u <= 0.0031308 and 25 * u / 323 or
                   ((200 * u + 11) / 211) ^ (12 / 5)
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
-- END CONTRAST ]]]

-- [[[ COLOR MANIPULATION - Functions to manipulate colors (rotate, lighten, darken)

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

-- Darkens an RGB color and returns it as a hex string
-- @param hex_color The RGB color to be darkened, as a hex string
-- @param percent The percentage by which the color should be darkened
-- @return The darkened RGB color as a hex string
function ColorService:rgb_darken(hex_color, percent)
    local r, g, b = gears.color.parse_color(hex_color)
    r = math.max(math.min(255, r * (1 - percent)), 0)
    g = math.max(math.min(255, g * (1 - percent)), 0)
    b = math.max(math.min(255, b * (1 - percent)), 0)
    return string.format("#%02x%02x%02x", r, g, b)
end
-- END COLOR MANIPULATION ]]]

-- Creates a shadow effect for a widget
-- @param radius The radius of the shadow's rounded corners
-- @param offset The offset of the shadow
-- @return A table describing the shadow effect
function ColorService:create_shadow(radius, offset)
    return {
        offset = offset,
        color = "#000000",
        opacity = 1.4,
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, radius)
        end
    }
end

return ColorService
