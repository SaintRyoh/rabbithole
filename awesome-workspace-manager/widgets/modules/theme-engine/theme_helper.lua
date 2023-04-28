local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local ThemeHelper = {}
ThemeHelper.__index = ThemeHelper

function ThemeHelper.new()
    local self = setmetatable({}, ThemeHelper)
    return self
end

-- Returns a linear gradient bg as a table
function ThemeHelper:bg_grad_linear(color1, color2)
    return {
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

-- returns a table for adding shadows to widgets
function ThemeHelper:create_shadow(radius, offset)
    return {
        offset = offset,
        color = "#000000",
        opacity = 1.4,
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, radius)
        end
    }
end

-- Darkens an RGb color and returns as a string
function ThemeHelper:rgb_darken(hex_color, percent)
    local r, g, b = gears.color.parse_color(hex_color)
    r = math.max(math.min(255, r * (1 - percent)), 0)
    g = math.max(math.min(255, g * (1 - percent)), 0)
    b = math.max(math.min(255, b * (1 - percent)), 0)
    return string.format("#%02x%02x%02x", r, g, b)
end

-- Create a radial gradient for a 3D effect
function ThemeHelper:create_radial_gradient(color1, color2)
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

-- Apply a 3D effect to a widget
function ThemeHelper:apply_3d_effect(widget, color1, color2, shadow_radius, shadow_offset)
    local shadow = self:create_widget_shadow(shadow_radius, shadow_offset)
    local gradient = self:create_radial_gradient(color1, color2)

    widget:set_bg(gradient)
    widget:set_shape(function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, shadow_radius)
    end)
    widget:set_shape_clip(true)
    widget:set_shape_border_width(dpi(1))
    widget:set_shape_border_color(shadow.color)
end

return ThemeHelper